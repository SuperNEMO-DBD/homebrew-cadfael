class Root5 < Formula
   homepage "http://root.cern.ch"
   version "5.34.30"
   sha1 "28fce7f2adc775f7327ee54dcca11199f605b22c"
   url "ftp://root.cern.ch/root/root_v#{version}.source.tar.gz"
   mirror "http://ftp.riken.jp/pub/ROOT/root_v#{version}.source.tar.gz"
   head "https://github.com/root-mirror/root.git", :branch => "v5-34-00-patches"

   patch :DATA

   depends_on "cmake" => :build
   option :cxx11
   
   depends_on "openssl"
   depends_on "gsl" => :recommended
   depends_on :python => :optional


   def install
     mkdir "hb-build-root" do
       ENV.cxx11 if build.cxx11?

       args = std_cmake_args
       args << "-Dgnuinstall=ON"
       args << "-DCMAKE_INSTALL_SYSCONFDIR=etc/root"
       args << "-Dgminimal=ON"
       args << "-Dcxx11=OFF" unless build.cxx11?
       args << "-Dlibcxx=ON" if OS.mac?
       args << "-Dfortran=OFF"
       args << "-Dpython=OFF" unless build.with? "python"
       args << "-Dmathmore=OFF" unless build.with? "gsl"
       args << "-Drpath=ON"
       args << "-Dsoversion=ON"

       # NB, need to patch RootBuildOptions to set INSTALL RPATH correctly
       # Then probably also need RPATH use link path to find HB libdir
       system "cmake", "../", *args
       system "make"
       system "make", "install"
     end
   end
end
__END__
diff --git a/cmake/modules/RootBuildOptions.cmake b/cmake/modules/RootBuildOptions.cmake
index a89bb53..a09967b 100644
--- a/cmake/modules/RootBuildOptions.cmake
+++ b/cmake/modules/RootBuildOptions.cmake
@@ -8,7 +8,7 @@ function(ROOT_BUILD_OPTION name defvalue)
     set(description ${ARGN})
   else()
     set(description " ")
-  endif()    
+  endif()
   option(${name} "${description}" ${defvalue})
   set(root_build_options ${root_build_options} ${name} PARENT_SCOPE )
 endfunction()
@@ -184,7 +184,7 @@ ROOT_BUILD_OPTION(xft ON "Xft support (X11 antialiased fonts)")
 ROOT_BUILD_OPTION(xml ON "XML parser interface")
 ROOT_BUILD_OPTION(x11 ${x11_defvalue} "X11 support")
 ROOT_BUILD_OPTION(xrootd ON "Build xrootd file server and its client (if supported)")
-  
+
 option(fail-on-missing "Fail the configure step if a required external package is missing" OFF)
 option(minimal "Do not automatically search for support libraries" OFF)
 option(gminimal "Do not automatically search for support libraries, but include X11" OFF)
@@ -196,21 +196,6 @@ if(DEFINED c++11)   # For backward compatibility
   set(cxx11 ${c++11} CACHE BOOL "" FORCE)
 endif()
 
-#---General Build options----------------------------------------------------------------------
-# use, i.e. don't skip the full RPATH for the build tree
-set(CMAKE_SKIP_BUILD_RPATH  FALSE)
-# when building, don't use the install RPATH already (but later on when installing)
-set(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE) 
-# add the automatically determined parts of the RPATH
-# which point to directories outside the build tree to the install RPATH
-set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
-
-# the RPATH to be used when installing---------------------------------------------------------
-if(rpath)
-  set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib")
-  set(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE) 
-endif()
-
 #---Avoid creating dependencies to 'non-statndard' header files -------------------------------
 include_regular_expression("^[^.]+$|[.]h$|[.]icc$|[.]hxx$|[.]hpp$")
 
@@ -236,6 +221,21 @@ endif()
 #---Add Installation Variables------------------------------------------------------------------
 include(RootInstallDirs)
 
+#---General Build options----------------------------------------------------------------------
+# use, i.e. don't skip the full RPATH for the build tree
+set(CMAKE_SKIP_BUILD_RPATH  FALSE)
+# when building, don't use the install RPATH already (but later on when installing)
+set(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
+# add the automatically determined parts of the RPATH
+# which point to directories outside the build tree to the install RPATH
+set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
+
+# the RPATH to be used when installing---------------------------------------------------------
+if(rpath)
+  set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_FULL_LIBDIR}")
+  set(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)
+endif()
+

