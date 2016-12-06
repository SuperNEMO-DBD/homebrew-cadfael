class Falaise < Formula
  desc "Falaise Software for SuperNEMO"
  homepage ""
  url "https://files.warwick.ac.uk/supernemo/files/Cadfael/distfiles/Falaise-2.1.0.tar.gz"
  version "2.1.0"
  sha256 "d3daa4b7c1ce623e584b976e53f5822643803255c5a8aaa32eb3ff1b52b9d576"
  revision 2

  patch :DATA

  depends_on "cmake" => :build
  depends_on "supernemo-dbd/cadfael/doxygen" => :build

  needs :cxx11

  # Bayeux dependency pulls in all additional deps of Falaise at present
  depends_on "supernemo-dbd/cadfael/bayeux"

  def install
    ENV.cxx11
    mkdir "falaise.build" do
      fl_cmake_args = std_cmake_args
      fl_cmake_args << "-DCMAKE_INSTALL_LIBDIR=lib"
      fl_cmake_args << "-DFALAISE_CXX_STANDARD=11"
      fl_cmake_args << "-DFALAISE_COMPILER_ERROR_ON_WARNING=OFF"
      system "cmake", "..", *fl_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/flsimulate", "-o", "test.brio"
  end
end
__END__
diff --git a/modules/GammaTracking/CMakeLists.txt b/modules/GammaTracking/CMakeLists.txt
index 71d1fbf..17faedf 100644
--- a/modules/GammaTracking/CMakeLists.txt
+++ b/modules/GammaTracking/CMakeLists.txt
@@ -60,13 +60,15 @@ add_library(Falaise_GammaTracking SHARED
   ${FalaiseGammaTrackingPlugin_HEADERS}
   ${FalaiseGammaTrackingPlugin_SOURCES})
 
-target_link_libraries(Falaise_GammaTracking GammaTracking Falaise)
+target_link_libraries(Falaise_GammaTracking GammaTracking FalaiseModule)
 
 # Apple linker requires dynamic lookup of symbols, so we
 # add link flags on this platform
 if(APPLE)
   set_target_properties(Falaise_GammaTracking
-    PROPERTIES LINK_FLAGS "-undefined dynamic_lookup"
+    PROPERTIES
+      LINK_FLAGS "-undefined dynamic_lookup"
+      INSTALL_RPATH "@loader_path"
     )
 endif()
 
diff --git a/modules/TrackFit/CMakeLists.txt b/modules/TrackFit/CMakeLists.txt
index 89d6b32..802c3da 100644
--- a/modules/TrackFit/CMakeLists.txt
+++ b/modules/TrackFit/CMakeLists.txt
@@ -68,18 +68,20 @@ add_library(Falaise_TrackFit SHARED
   ${FalaiseTrackFitPlugin_HEADERS}
   ${FalaiseTrackFitPlugin_SOURCES})
 
-target_link_libraries(Falaise_TrackFit TrackFit Falaise)
+target_link_libraries(Falaise_TrackFit TrackFit FalaiseModule)
 
 # Apple linker requires dynamic lookup of symbols, so we
 # add link flags on this platform
 if(APPLE)
   set_target_properties(Falaise_TrackFit
-    PROPERTIES LINK_FLAGS "-undefined dynamic_lookup"
+    PROPERTIES
+      LINK_FLAGS "-undefined dynamic_lookup"
+      INSTALL_RPATH "@loader_path"
     )
 endif()
 
 # Install it:
-install(TARGETS Falaise_TrackFit DESTINATION ${CMAKE_INSTALL_LIBDIR}/Falaise/modules)
+install(TARGETS Falaise_TrackFit DESTINATION ${CMAKE_INSTALL_LIBDIR}/${FALAISE_PLUGINLIBDIR})
 
 # Test support:
 option(FalaiseTrackFitPlugin_ENABLE_TESTING "Build unit testing system for FalaiseTrackFitPlugin" ON)

diff --git a/modules/things2root/CMakeLists.txt b/modules/things2root/CMakeLists.txt
index b22ff0d..7cf9d45 100644
--- a/modules/things2root/CMakeLists.txt
+++ b/modules/things2root/CMakeLists.txt
@@ -12,4 +12,4 @@ add_library(Things2Root SHARED Things2Root.h Things2Root.cpp)
 target_link_libraries(Things2Root FalaiseModule)
 
 # Install it
-install(TARGETS Things2Root DESTINATION ${CMAKE_INSTALL_LIBDIR}/${Falaise_PLUGINLIBDIR})
+install(TARGETS Things2Root DESTINATION ${CMAKE_INSTALL_LIBDIR}/${FALAISE_PLUGINLIBDIR})
