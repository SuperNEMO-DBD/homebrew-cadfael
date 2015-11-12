class Bayeux < Formula
  desc "Bayeux Library"
  homepage ""
  url "https://files.warwick.ac.uk/supernemo/files/Cadfael/distfiles/Bayeux-2.0.1-Source.tar.bz2"
  version "2.0.1"
  sha256 "8a1db5cc6d032a034e79560248328c1bc45b5fda700a47e6fa3bcd1096fa2909"

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "camp"
  depends_on "doxygen"
  depends_on "gsl"
  depends_on "readline"
  depends_on "root5"

  def install
    mkdir "bayeux.build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "false"
  end
end
