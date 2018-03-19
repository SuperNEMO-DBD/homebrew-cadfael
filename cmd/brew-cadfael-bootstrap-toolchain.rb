require "requirement"

class GCCRequirement < Requirement
  fatal true
  # Homebrew removed default formula from 1.5
  #default_formula "supernemo-dbd/cadfael/gcc49"

  def initialize(tags)
    @version = tags.shift if /\d+\.*\d*/ === tags.first
    raise "GCCRequirement requires a version!" unless @version
    super
  end

  # Return array of all gcc programs in path, sorted by path then version
  def find_all_gcc(path = ENV["PATH"])
    path.split(File::PATH_SEPARATOR).map do |p|
      Dir.glob(File.join(p, "gcc{,-[4-9]*}")).sort.reverse
    end.flatten
  end

  def find_newest_gcc(path = ENV["PATH"])
    find_all_gcc(path).select do |gcc|
      gccVersion = Utils.popen_read(gcc, "-dumpversion")
      gppProgram = File.join(File.dirname(gcc), File.basename(gcc).sub("cc","++"))
      Version.new(gccVersion) >= Version.new(@version) && File.executable?(gppProgram)
    end.first
  end

  satisfy :build_env => false do
    # NB, at present only considers PATH, ignores CC/CXX/HOMEBREW_{CC,CXX}...
    find_newest_gcc
  end

  env do
    gcc = find_newest_gcc
    gpp = File.join(File.dirname(gcc), File.basename(gcc).sub("cc","++"))
    ENV["CC"] = gcc
    ENV["CXX"] = gpp
  end

  def message
    s = "GCC #{@version} or later is required."
    s += super
    s
  end
end


CADFAEL_BREW_BOOTSTRAP_TOOLCHAIN_HELP = <<-EOS
usage: brew cadfael-bootstrap-toolchain

Overview:
  Install development toolchain for cadfael. This comprises a base C/C++
  compiler, binary tools, Python interpreter, and programs to help with 
  software build, testing, documentation and packaging.

  This is implemented as a command rather than Formula as the order of
  installation and subsequent Formula build environments matters.

Options:
  --help        Show this help message and exit

Caveats:
  The bootstrap of the toolchain is intended for internal use, so may result
  in errors or undefined behaviour if used directly.

EOS

if ARGV.include?("--help")
  puts CADFAEL_BREW_BOOTSTRAP_TOOLCHAIN
  Kernel.exit(0)
end

# - Implementation
require "cmd/install"
ohai "Bootstrapping Cadfael toolchain"
Homebrew.perform_preinstall_checks

# - Base toolchain
# On OS X, doctor will handle this for us in installing Xcode/cmd line tools
# On Linux, need GCC if system does not supply a sufficient version
# - In future may also need binutils, gdb etc
if OS.linux?
  req = GCCRequirement.new(["4.9"])
  if !req.satisfied?
    oh1 "Installing Cadfael GCC 4.9 this may take some time"
    Homebrew.install_formula(Formula["supernemo-dbd/cadfael/gcc49"])
  end
end
  
# - General tools
# Installed after toolchain so that they *should* be built using it
cadfael_tools = []
cadfael_tools << "patchelf" if OS.linux?
cadfael_tools += %w[
  python@2
  ninja
  cmake
  git-flow-avh
]

cadfael_tools.each { |f|
  if !Formula[f].installed?
    oh1 "Installing Cadfael tool #{f}"
    Homebrew.install_formula(Formula[f])
  else
    ohai "Cadfael tool #{f} already installed"
  end
}

