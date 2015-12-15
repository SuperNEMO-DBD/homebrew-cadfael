require 'formula'

class Cadfael < Formula
  url File.dirname(__FILE__), :using => :git
  version "2015.12"
  revision 1

  keg_only "Requirement and version tracking formula only"

  option :cxx11

  # Basic toolset *should* be built before anything else
  # If it isn't, need to split this off into separate
  # "toolchain formulae"
  if OS.linux?
    depends_on "patchelf"
    depends_on "binutils" => ["with-default-names"]
    depends_on "gcc49"
  end

  depends_on "pkg-config"
  depends_on "python"
  depends_on "doxygen"
  depends_on "gsl"

  if build.cxx11?
    depends_on "boost" => ["c++11"]
    depends_on "camp" => ["c++11"]
    depends_on "clhep" => ["c++11"]
    depends_on "geant4" => ["c++11"]
    depends_on "root5" => ["c++11"]
    depends_on "xerces-c" => ["c++11"]
  else
    depends_on "boost"
    depends_on "camp"
    depends_on "clhep"
    depends_on "geant4"
    depends_on "root5"
    depends_on "xerces-c"
  end


  def install
    # Want to really record formula versions etc here...
    bin.mkdir
    system "touch", "#{bin}/cadfael-installed-#{version}"
  end
end
