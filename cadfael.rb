require 'formula'

class Cadfael < Formula
  url File.dirname(__FILE__), :using => :git
  version "1.1.1"

  keg_only "Requirement and version tracking formula only"

  # Basic toolset
  depends_on "pkg-config"
  depends_on "python"

  depends_on "boost"
  depends_on "camp"
  depends_on "clhep"
  depends_on "geant4"
  depends_on "gsl"
  depends_on "root5"
  depends_on "xerces-c"

  def install
    # Want to really record formula versions etc here...
    bin.mkdir
    system "touch", "#{bin}/cadfael-installed-#{version}"
  end
end
