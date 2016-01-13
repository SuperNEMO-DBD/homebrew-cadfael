require 'formula'

class Cadfael < Formula
  url File.dirname(__FILE__), :using => :git
  version "2016.01"

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

  # Picked up from core
  depends_on "pkg-config"
  depends_on "python"
  depends_on "doxygen"

  # Our own deps
  depends_on "supernemo-dbd/cadfael/gsl"

  if build.cxx11?
    depends_on "supernemo-dbd/cadfael/boost" => ["c++11"]
    depends_on "supernemo-dbd/cadfael/camp" => ["c++11"]
    depends_on "supernemo-dbd/cadfael/clhep" => ["c++11"]
    depends_on "supernemo-dbd/cadfael/geant4" => ["c++11"]
    depends_on "supernemo-dbd/cadfael/root5" => ["c++11"]
    depends_on "supernemo-dbd/cadfael/xerces-c" => ["c++11"]
  else
    depends_on "supernemo-dbd/cadfael/boost"
    depends_on "supernemo-dbd/cadfael/camp"
    depends_on "supernemo-dbd/cadfael/clhep"
    depends_on "supernemo-dbd/cadfael/geant4"
    depends_on "supernemo-dbd/cadfael/root5"
    depends_on "supernemo-dbd/cadfael/xerces-c"
  end


  def install
    # Want to really record formula versions etc here...
    bin.mkdir
    system "touch", "#{bin}/cadfael-installed-#{version}"
  end
end
