#:  * `snemo-doctor`:
#:    Check your system for potential problems for brewing SuperNEMO software.
#:    Snemo-doctor exits with a non-zero status if any potential problems are found.
#:    Warnings are just used to help the SuperNEMO maintainers with debugging if
#:    you file an issue. If everything you use Homebrew for is working fine:
#:    please don't worry or file an issue; just ignore this.

require "csv"
require "ostruct"
require "diagnostic"
require "system_command"
require "system_config"
require "version"

# Assume packageset will be simple one package per line in a file
# To check packages,need to:
#  1. Get system fingerprint
#  2. Fail if not supported
#  3. Get packageset for that fingerprint
#  4. Check install state of each package
#    - If installed, o.k.
#    - If not installed, add to missing list
#  5. If missing list not empty, construct command needed to install
def rpm_installed?(name)
  system_command("rpm", args: ["-q", "--qf", "%{NAME}-%{VERSION}", name]).success?
end

def deb_installed?(name)
  system_command("dpkg-query", args: ["-W", "-f='${Package}-${Version}'", name]).success?
end

def system_packages_to_install
  fingerprint = LinuxOSRelease.fingerprint
  case fingerprint.id
  when "centos"
    cmd = %w(yum install)
    packages = %w(
     curl
     gcc
     gcc-c++
     git
     make
     which
     libX11-devel
     libXext-devel
     libXft-devel
     libXpm-devel
     mesa-libGL-devel
     mesa-libGLU-devel
     perl-Data-Dumper
     perl-Thread-Queue
    )
    missing = packages.select { |p| true unless rpm_installed?(p) }
    cmd.concat(missing).join(" ") if missing
  when "ubuntu"
    cmd = %w(apt-get install)
    packages = %w(
     ca-certificates
     curl
     file
     g++
     git
     locales
     make
     uuid-runtime
     libx11-dev
     libxpm-dev
     libxft-dev
     libxext-dev
     libglu1-mesa-dev
     flex
     texinfo
    )
    missing = packages.select { |p| true unless deb_installed?(p) }
    cmd.concat(missing).join(" ") if missing
  end
end

LinuxOSRelease = Struct.new(:id, :version_id, :pretty_name) do
  def supported?
    # No fingerprint
    if self == LinuxOSRelease.new
      false
    else
      case self.id
      when "centos"
        true if self.version_id >= Version.new("6")
      when "ubuntu"
        true if self.version_id >= Version.new("16.04")
      else
        false
      end
    end
  end

  def self.fingerprint
    if File.exist?("/etc/os-release")
      osr = Hash[CSV.read("/etc/os-release", col_sep: "=").select {|row|
        row unless row.empty?
      }]
      LinuxOSRelease.new(
        osr["ID"],
        Version.new(osr["VERSION_ID"]),
        osr["PRETTY_NAME"]
      ).freeze
    elsif which("lsb_release")
      LinuxOSRelease.new(
        `lsb_release -is`.chomp.downcase,
        Version.new(`lsb_release -rs`.chomp),
        # Delete quotes because CentOS is weird
        `lsb_release -ds`.chomp.delete("\"")
      ).freeze
    elsif (redhat_release = Pathname.new("/etc/redhat-release")).readable?
      LinuxOSRelease.new(
        redhat_release.read.chomp.split(' ')[0].downcase,
        Version.new("0"),
        redhat_release.read.chomp
      ).freeze
    else
      LinuxOSRelease.new
    end
  end
end


def host_linux_release
  LinuxOSRelease.fingerprint
end

module Homebrew
  module Diagnostic
    class Checks
      def check_linux_release
        return unless OS.linux?
        return if host_linux_release.supported?
        osr = host_linux_release
        <<~EOS
          Your Linux system is not supported by SuperNEMO, or cannot be
          fingerprinted using /etc/os-release or lsb_release:
            ID:          #{osr.id}
            VERSION_ID:  #{osr.version_id}
            PRETTY_NAME: #{osr.pretty_name}

          SuperNEMO and Homebrew only have minimal requirements on the
          actual Linux distribution, but some formulae or bottles may 
          fail to install.
        EOS
      end

      def check_linux_packages
        return unless OS.linux?

        unless host_linux_release.supported?
          <<~EOS
            Your Linux system is not supported by SuperNEMO, so checks on
            the needed system packages cannot be performed. This does
            not mean your system is missing these packages, but some
            formulae may fail to install.
          EOS
        else
          installMissing = system_packages_to_install
          return unless installMissing
          <<~EOS
            Your Linux system is missing several system packages required 
            to bootstrap or install SuperNEMO software. You, or a user with sufficient 
            adminstrator privileges, will need to run:

              #{installMissing}

            to install them.
          EOS
        end
      end
    end
  end
end

# Create and run checks
checks = Homebrew::Diagnostic::Checks.new
methods = checks.all.sort

first_warning = true
methods.each do |method|
  out = checks.send(method)
  next if out.nil? || out.empty?

  if first_warning
    $stderr.puts <<~EOS
      #{Tty.bold}Please note that these warnings are just used to help the SuperNEMO maintainers
      with debugging if you file an issue. If everything you use Homebrew for is
      working fine: please don't worry or file an issue; just ignore this. Thanks!#{Tty.reset}
   EOS
  end

  $stderr.puts
  opoo out
  Homebrew.failed = true
  first_warning = false
end

puts "Your system is ready to brew SuperNEMO software." unless Homebrew.failed?

