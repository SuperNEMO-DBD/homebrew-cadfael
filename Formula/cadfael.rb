require 'formula'

class GCCRequirement < Requirement
  fatal true
  default_formula "supernemo-dbd/cadfael/gcc49"

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
      ohai "considering #{gcc}"
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

    ohai "in env with gnu = #{gcc}, #{gpp}"
  end

  def message
    s = "GCC #{@version} or later is required."
    s += super
    s
  end
end


class Cadfael < Formula
  url File.dirname(File.dirname(__FILE__)), :using => :git
  version "2016.04"

  keg_only "Cadfael is a requirement/dependent tracking only formula"

  # Install suitable minimal C/C++ toolchain on Linux, if required
  if OS.linux?
    # Need binutils built first, and listing it first should be sufficient
    # System must supply at least GCC 4.9
    depends_on "binutils" => !GCCRequirement.new(["4.9"]).satisfied? ? 
      [:recommended, "with-default-names"] : :optional
    depends_on GCCRequirement => "4.9"
    depends_on "patchelf"
  end

  # Additional useful build/dev tools that may otherwise not be
  # installed by dependencies
  depends_on "ninja"

  def install
    # Want to really record formula versions etc here...
    # Could also link to gcc/g++ if required, but homebrew will
    # always pick up system version anyway if that's what we're using.
    bin.mkdir
    system "touch", "#{bin}/cadfael-installed-#{version}"
  end
end
