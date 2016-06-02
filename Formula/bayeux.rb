class Bayeux < Formula
  desc "Bayeux Library"
  homepage ""
  url "https://files.warwick.ac.uk/supernemo/files/Cadfael/distfiles/Bayeux-2.0.1-Source.tar.bz2"
  version "2.0.1"
  sha256 "8a1db5cc6d032a034e79560248328c1bc45b5fda700a47e6fa3bcd1096fa2909"
  revision 6

  patch do
    url "https://files.warwick.ac.uk/supernemo/files/Cadfael/distfiles/bayeux-2.0.1-binreloc.patch"
    sha256 "000ceb4313ab07a500847bcb274a93f686a7e225e1f550672d8d97f5bc3fb2b2"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build

  depends_on "supernemo-dbd/cadfael/gsl"
  depends_on "readline"

  needs :cxx11
  depends_on "icu4c" => "c++11"
  depends_on "supernemo-dbd/cadfael/boost" => ["c++11", "with-icu4c"]
  depends_on "supernemo-dbd/cadfael/camp" => "c++11"
  depends_on "supernemo-dbd/cadfael/clhep" => "c++11"
  depends_on "supernemo-dbd/cadfael/root5" => "c++11"
  depends_on "supernemo-dbd/cadfael/geant4" => "c++11"

  option "with-devtools", "Build debug tools for Bayeux developers"

  def install
    # Micro patch to correct setting of argv with const char* instead of char
    inreplace "source/bxdatatools/src/kernel.cc", "'\\0'", "\"\\0\""

    ENV.cxx11
    mkdir "bayeux.build" do
      bx_cmake_args = std_cmake_args
      bx_cmake_args << "-DCMAKE_INSTALL_LIBDIR=lib"
      bx_cmake_args << "-DBAYEUX_WITH_DEVELOPER_TOOLS=OFF" unless build.with? "devtools"
      bx_cmake_args << "-DGSL_DIR=#{Formula["gsl"].lib}/cmake/GSL-#{Formula["gsl"].version}"
      system "cmake", "..", *bx_cmake_args
      system "make", "install"
    end
  end

  test do
    system "false"
  end
end
