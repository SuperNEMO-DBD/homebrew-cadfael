class Bayeux < Formula
  desc "Bayeux Library"
  homepage ""
  version "3.0.0"
  url "https://files.warwick.ac.uk/supernemo/files/Cadfael/distfiles/Bayeux-3.0.0.tar.bz2"
  sha256 "b4aa1ab505a7c36b8a1b0e07da10ecc0841df244fd1e0da2a316cf960ef7d59c"

  depends_on "cmake" => :build
  depends_on "supernemo-dbd/cadfael/doxygen" => :build

  depends_on "gsl"
  depends_on "readline"

  needs :cxx11
  depends_on "icu4c" => "c++11"
  depends_on "supernemo-dbd/cadfael/boost" => ["c++11", "with-icu4c"]
  depends_on "supernemo-dbd/cadfael/camp" => "c++11"
  depends_on "supernemo-dbd/cadfael/clhep" => "c++11"
  depends_on "supernemo-dbd/cadfael/geant4" => "c++11"
  depends_on "supernemo-dbd/cadfael/root6"
  depends_on "supernemo-dbd/cadfael/qt5-base"

  option "with-devtools", "Build debug tools for Bayeux developers"

  def install
    ENV.cxx11
    mkdir "bayeux.build" do
      bx_cmake_args = std_cmake_args
      bx_cmake_args << "-DCMAKE_INSTALL_LIBDIR=lib"
      bx_cmake_args << "-DBAYEUX_CXX_STANDARD=11"
      bx_cmake_args << "-DBAYEUX_COMPILER_ERROR_ON_WARNING=OFF"
      bx_cmake_args << "-DBAYEUX_WITH_QT_GUI=ON"
      bx_cmake_args << "-DBAYEUX_WITH_DEVELOPER_TOOLS=OFF" unless build.with? "devtools"
      system "cmake", "..", *bx_cmake_args
      system "make", "install"
    end
  end

  test do
    system "false"
  end
end

