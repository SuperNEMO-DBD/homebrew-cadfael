class Bayeux < Formula
  desc "Core C++ Framework Library for SuperNEMO Experiment"
  homepage "https://github.com/supernemo-dbd/bayeux"
  url "https://files.warwick.ac.uk/supernemo/files/Cadfael/distfiles/Bayeux-3.0.0.tar.bz2"
  sha256 "f0f01465ad20e51a05ca889cfdc52c12d0a2cf16d70dd6f4e04551c652ce967e"
  revision 2

  option "with-devtools", "Build debug tools for Bayeux developers"

  needs :cxx11

  depends_on "cmake" => :build
  depends_on "icu4c" => "c++11"
  depends_on "readline"

  depends_on "supernemo-dbd/cadfael/doxygen" => :build
  depends_on "supernemo-dbd/cadfael/gsl"
  depends_on "supernemo-dbd/cadfael/boost" => ["c++11", "with-icu4c"]
  depends_on "supernemo-dbd/cadfael/camp" => "c++11"
  depends_on "supernemo-dbd/cadfael/clhep" => "c++11"
  depends_on "supernemo-dbd/cadfael/geant4" => "c++11"
  depends_on "supernemo-dbd/cadfael/root6"
  depends_on "supernemo-dbd/cadfael/qt5-base"

  def install
    ENV.cxx11
    mkdir "bayeux.build" do
      bx_cmake_args = std_cmake_args
      bx_cmake_args << "-DCMAKE_INSTALL_LIBDIR=lib"
      bx_cmake_args << "-DBAYEUX_CXX_STANDARD=11"
      bx_cmake_args << "-DBAYEUX_COMPILER_ERROR_ON_WARNING=OFF"
      bx_cmake_args << "-DBAYEUX_WITH_QT_GUI=ON"
      bx_cmake_args << "-DBAYEUX_WITH_DEVELOPER_TOOLS=OFF" if build.without? "devtools"
      system "cmake", "..", *bx_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/bxg4_production", "--help"
  end
end
