class Bayeux < Formula
  desc "Bayeux Library"
  homepage ""
  version "2.1.0"
  url "https://files.warwick.ac.uk/supernemo/files/Cadfael/distfiles/Bayeux-2.1.0.tar.gz"
  sha256 "28deba44bfff73319a117ab5b8425703d73ee4764b19bb4162661f8ecf979efc"
  revision 2

  depends_on "cmake" => :build
  depends_on "doxygen" => :build

  depends_on "homebrew/versions/gsl1"
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
    ENV.cxx11
    mkdir "bayeux.build" do
      bx_cmake_args = std_cmake_args
      bx_cmake_args << "-DCMAKE_INSTALL_LIBDIR=lib"
      bx_cmake_args << "-DBAYEUX_CXX_STANDARD=11"
      bx_cmake_args << "-DBAYEUX_COMPILER_ERROR_ON_WARNING=OFF"
      bx_cmake_args << "-DBAYEUX_WITH_DEVELOPER_TOOLS=OFF" unless build.with? "devtools"
      system "cmake", "..", *bx_cmake_args
      system "make", "install"
    end
  end

  test do
    system "false"
  end
end
