class Bayeux < Formula
  desc "Core C++ Framework Library for SuperNEMO Experiment"
  homepage "https://github.com/supernemo-dbd/bayeux"
  head "https://github.com/SuperNEMO-DBD/Bayeux.git", :branch => "develop"
  stable do
    url "https://github.com/SuperNEMO-DBD/Bayeux/archive/3.3.0.tar.gz"
    sha256 "6468251da50214e744651260770bf252f677a8f9b9f822085c38dc69d71b52a9"
  end

  option "with-devtools", "Build debug tools for Bayeux developers"

  needs :cxx11

  depends_on "cmake" => :build
  depends_on "supernemo-dbd/cadfael/doxygen" => :build
  depends_on "icu4c"
  depends_on "readline"
  depends_on "supernemo-dbd/cadfael/gsl"
  depends_on "supernemo-dbd/cadfael/boost"
  depends_on "supernemo-dbd/cadfael/camp"
  depends_on "supernemo-dbd/cadfael/clhep"
  depends_on "supernemo-dbd/cadfael/geant4"
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
      bx_cmake_args << "-DBAYEUX_ENABLE_TESTING=ON" if build.devel?

      system "cmake", "..", *bx_cmake_args

      if build.devel?
        system "make"
        system "ctest"
      end

      system "make", "install"
    end
  end

  test do
    system "#{bin}/bxg4_production", "--help"
  end
end
