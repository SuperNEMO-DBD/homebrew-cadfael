class BayeuxAT2 < Formula
  desc "Core C++ Framework Library for the SuperNEMO Experiment"
  homepage "https://github.com/supernemo-dbd/bayeux"
  url "https://files.warwick.ac.uk/supernemo/files/Cadfael/distfiles/Bayeux-2.2.0.tar.bz2"
  sha256 "fe03bfb6563af9aaef0da97c270863f14bd82d5427bdb4eb860edbf4ffb964b1"
  revision 3

  keg_only "conflicts with newer production versions"

  option "with-devtools", "Build debug tools for Bayeux developers"

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "icu4c"
  depends_on "readline"
  depends_on "supernemo-dbd/cadfael/boost"
  depends_on "supernemo-dbd/cadfael/camp"
  depends_on "supernemo-dbd/cadfael/clhep"
  depends_on "supernemo-dbd/cadfael/geant4"
  depends_on "supernemo-dbd/cadfael/gsl"
  depends_on "supernemo-dbd/cadfael/root6"

  needs :cxx11

  def install
    ENV.cxx11
    mkdir "bayeux.build" do
      bx_cmake_args = std_cmake_args
      bx_cmake_args << "-DCMAKE_INSTALL_LIBDIR=lib"
      bx_cmake_args << "-DBAYEUX_CXX_STANDARD=11"
      bx_cmake_args << "-DBAYEUX_COMPILER_ERROR_ON_WARNING=OFF"
      bx_cmake_args << "-DBAYEUX_WITH_DEVELOPER_TOOLS=OFF" if build.without? "devtools"
      system "cmake", "..", *bx_cmake_args
      system "make", "install"
    end
  end

  test do
    system "false"
  end
end
