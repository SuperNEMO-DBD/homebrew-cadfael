class BayeuxAT2 < Formula
  desc "Bayeux Library"
  homepage ""
  version "2.2.0"
  url "https://files.warwick.ac.uk/supernemo/files/Cadfael/distfiles/Bayeux-2.2.0-rc1.tar.bz2"
  sha256 "c6b429131c5f5f527d3b474eb3fc05884f8c876d0d0e26d47c8b41a54de7e525"
  
  patch :DATA

  keg_only "Conflicts with newer production versions"

  depends_on "cmake" => :build
  depends_on "supernemo-dbd/cadfael/doxygen" => :build

  depends_on "gsl"
  depends_on "readline"

  needs :cxx11
  depends_on "icu4c" => "c++11"
  depends_on "boost" => ["c++11", "with-icu4c"]
  depends_on "supernemo-dbd/cadfael/camp" => "c++11"
  depends_on "supernemo-dbd/cadfael/clhep" => "c++11"
  depends_on "supernemo-dbd/cadfael/geant4" => "c++11"
  depends_on "supernemo-dbd/cadfael/root6"

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
__END__
diff --git a/source/bxmctools/src/g4/run_action.cc b/source/bxmctools/src/g4/run_action.cc
index 5aa80d5..11d4aad 100644
--- a/source/bxmctools/src/g4/run_action.cc
+++ b/source/bxmctools/src/g4/run_action.cc
@@ -422,7 +422,7 @@ namespace mctools {
       return;
     }
 
-    void run_action::dump(ostream & a_out) const
+    void run_action::dump(std::ostream & a_out) const
     {
       a_out << "run_action::dump:" << std::endl;
       a_out << "|-- Save data           : "  << _save_data_ << std::endl;
