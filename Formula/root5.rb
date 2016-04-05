class Root5 < Formula
   homepage "http://root.cern.ch"

   stable do
     version "5.34.30"
     sha1 "28fce7f2adc775f7327ee54dcca11199f605b22c"
     url "https://root.cern.ch/download/root_v#{version}.source.tar.gz"
     mirror "http://ftp.riken.jp/pub/ROOT/root_v#{version}.source.tar.gz"
     patch :DATA
   end

   devel do
     version "5.34.34"
     sha256 "8c1faf893ed3b279f3500368b3dcd2087352020a69d3055c4d36726e7f6acd58"
     url "https://root.cern.ch/download/root_v#{version}.source.tar.gz"
     mirror "http://ftp.riken.jp/pub/ROOT/root_v#{version}.source.tar.gz"
   end

   head do
     url "https://github.com/root-mirror/root.git", :branch => "v5-34-00-patches"
   end

   depends_on "cmake" => :build
   option :cxx11

   depends_on "openssl"
   depends_on "supernemo-dbd/cadfael/gsl" => :recommended
   depends_on :python => :recommended

   def install
     # When building the head, temp patch for ROOT-8032
     if build.head? || build.devel?
       inreplace "cmake/modules/RootBuildOptions.cmake", "thread|cxx11|cling|builtin_llvm|builtin_ftgl|explicitlink", "thread|cxx11|cling|builtin_llvm|builtin_ftgl|explicitlink|python|mathmore|asimage|gnuinstall|rpath|soversion|opengl|builtin_glew"
     end

     mkdir "hb-build-root" do
       ENV.cxx11 if build.cxx11?

       # Defaults
       args = std_cmake_args
       args << "-Dgnuinstall=ON"
       args << "-DCMAKE_INSTALL_SYSCONFDIR=etc/root"
       args << "-Dgminimal=ON"
       args << "-Dx11=OFF" if OS.mac?
       args << "-Dcocoa=ON" if OS.mac?
       args << "-Dlibcxx=ON" if OS.mac?
       args << "-Dfortran=OFF"
       args << "-Drpath=ON"
       args << "-Dsoversion=ON"
       args << "-Dasimage=ON"
       args << "-Dbuiltin_asimage=ON"
       args << "-Dbuiltin_freetype=ON"
       args << "-Dopengl=ON"
       args << "-Dbuiltin_glew=ON" if OS.mac?

       # Options
       args << "-Dcxx11=ON" if build.cxx11?
       args << "-Dpython=".concat((build.with? "python") ? "ON" : "OFF")
       args << "-Dmathmore=".concat((build.with? "gsl") ? "ON" : "OFF")

       system "cmake", "../", *args
       system "make"
       system "make", "install"
     end
   end
end
__END__
diff --git a/cmake/modules/RootBuildOptions.cmake b/cmake/modules/RootBuildOptions.cmake
index 09ed495..298ebc0 100644
--- a/cmake/modules/RootBuildOptions.cmake
+++ b/cmake/modules/RootBuildOptions.cmake
@@ -197,21 +197,6 @@ if(DEFINED c++11)   # For backward compatibility
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
 
@@ -229,6 +214,20 @@ endif()
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
 
 
 
diff --git a/cmake/modules/SetUpLinux.cmake b/cmake/modules/SetUpLinux.cmake
index 080f38a..b1d0a30 100644
--- a/cmake/modules/SetUpLinux.cmake
+++ b/cmake/modules/SetUpLinux.cmake
@@ -54,7 +54,7 @@ if(CMAKE_COMPILER_IS_GNUCXX)
   set(CMAKE_SHARED_LIBRARY_CREATE_C_FLAGS "${CMAKE_SHARED_LIBRARY_CREATE_C_FLAGS}")
   set(CMAKE_SHARED_LIBRARY_CREATE_CXX_FLAGS "${CMAKE_SHARED_LIBRARY_CREATE_CXX_FLAGS}")
 
-  set(CMAKE_SHARED_LINKER_FLAGS "-Wl,--no-undefined")
+  set(CMAKE_SHARED_LINKER_FLAGS "-Wl,--no-undefined ${CMAKE_SHARED_LINKER_FLAGS}")
 
   # Select flags.
   set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "-O2 -g -DNDEBUG")
@@ -89,7 +89,7 @@ elseif(CMAKE_CXX_COMPILER_ID STREQUAL Clang)
   set(CMAKE_SHARED_LIBRARY_CREATE_C_FLAGS "${CMAKE_SHARED_LIBRARY_CREATE_C_FLAGS}")
   set(CMAKE_SHARED_LIBRARY_CREATE_CXX_FLAGS "${CMAKE_SHARED_LIBRARY_CREATE_CXX_FLAGS}")
 
-  set(CMAKE_SHARED_LINKER_FLAGS "-Wl,--no-undefined")
+  set(CMAKE_SHARED_LINKER_FLAGS "-Wl,--no-undefined ${CMAKE_SHARED_LINKER_FLAGS}")
 
   # Select flags.
   set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "-O2 -g -DNDEBUG")
@@ -145,25 +145,25 @@ elseif(CMAKE_CXX_COMPILER_ID STREQUAL Intel)
   if(ICC_MAJOR EQUAL 11)
     set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${BIT_ENVIRONMENT} -wd1572 -wd279")
     set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${BIT_ENVIRONMENT} -wd1572 -wd279")
-    set(CMAKE_SHARED_LINKER_FLAGS "${BIT_ENVIRONMENT} -Wl,--no-undefined")
+    set(CMAKE_SHARED_LINKER_FLAGS "${BIT_ENVIRONMENT} -Wl,--no-undefined ${CMAKE_SHARED_LINKER_FLAGS}")
   endif()
 
   if(ICC_MAJOR EQUAL 12)
     set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${BIT_ENVIRONMENT} -wd1572 -wd279")
     set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${BIT_ENVIRONMENT} -wd1572 -wd279")
-    set(CMAKE_SHARED_LINKER_FLAGS "${BIT_ENVIRONMENT} -Wl,--no-undefined")
+    set(CMAKE_SHARED_LINKER_FLAGS "${BIT_ENVIRONMENT} -Wl,--no-undefined ${CMAKE_SHARED_LINKER_FLAGS}")
   endif()
 
   if(ICC_MAJOR EQUAL 13)
     set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${BIT_ENVIRONMENT} -wd1572 -wd279")
     set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${BIT_ENVIRONMENT} -wd1572 -wd279")
-    set(CMAKE_SHARED_LINKER_FLAGS "${BIT_ENVIRONMENT} -Wl,--no-undefined")
+    set(CMAKE_SHARED_LINKER_FLAGS "${BIT_ENVIRONMENT} -Wl,--no-undefined ${CMAKE_SHARED_LINKER_FLAGS}")
   endif()
 
   if(ICC_MAJOR EQUAL 14)
     set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${BIT_ENVIRONMENT} -wd1572 -wd279 -wd2536 -wd873")
     set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${BIT_ENVIRONMENT} -wd1572 -wd279 -wd2536 -wd873")
-    set(CMAKE_SHARED_LINKER_FLAGS "${BIT_ENVIRONMENT} -Wl,--no-undefined")
+    set(CMAKE_SHARED_LINKER_FLAGS "${BIT_ENVIRONMENT} -Wl,--no-undefined ${CMAKE_SHARED_LINKER_FLAGS}")
   endif()
 
   set(CMAKE_SHARED_LIBRARY_CREATE_C_FLAGS "${CMAKE_SHARED_LIBRARY_CREATE_C_FLAGS}")


