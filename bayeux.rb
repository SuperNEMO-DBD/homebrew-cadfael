class Bayeux < Formula
  desc "Bayeux Library"
  homepage ""
  url "https://files.warwick.ac.uk/supernemo/files/Cadfael/distfiles/Bayeux-2.0.1-Source.tar.bz2"
  version "2.0.1"
  sha256 "8a1db5cc6d032a034e79560248328c1bc45b5fda700a47e6fa3bcd1096fa2909"
  revision 2

  option :cxx11

  depends_on "cmake" => :build
  
  depends_on "doxygen"
  depends_on "supernemo-dbd/cadfael/gsl"
  depends_on "readline"

  if build.cxx11?
    depends_on "supernemo-dbd/cadfael/boost" => "c++11"
    depends_on "supernemo-dbd/cadfael/camp" => "c++11"
    depends_on "supernemo-dbd/cadfael/root5" => "c++11"
    depends_on "supernemo-dbd/cadfael/geant4" => "c++11"
  else
    depends_on "supernemo-dbd/cadfael/boost"
    depends_on "supernemo-dbd/cadfael/camp"
    depends_on "supernemo-dbd/cadfael/root5"
    depends_on "supernemo-dbd/cadfael/geant4"
  end

  def install
    # Micro patch to correct setting of argv with const char* instead of char
    inreplace "source/bxdatatools/src/kernel.cc", "'\\0'", "\"\\0\""

    ENV.cxx11 if build.cxx11?
    mkdir "bayeux.build" do
      bx_cmake_args = std_cmake_args
      bx_cmake_args << "-DCMAKE_INSTALL_LIBDIR=lib"
      bx_cmake_args << "-DGSL_DIR=#{Formula["gsl"].lib}/cmake/GSL-#{Formula["gsl"].version}"
      system "cmake", "..", *bx_cmake_args
      system "make", "install"
    end
  end

  test do
    system "false"
  end
end
