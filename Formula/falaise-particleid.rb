class FalaiseParticleid < Formula
  desc "Particle ID Plugin Module for Falaise"
  homepage "https://github.com/xgarrido/ParticleIdentification"
  head "https://github.com/xgarrido/ParticleIdentification.git"

  patch :DATA

  depends_on "cmake" => :build
  depends_on "supernemo-dbd/cadfael/falaise"

  def install
    system "cmake", *std_cmake_args, "."
    system "make", "install"

  end
end
__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 2750da1..9b53f47 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -5,6 +5,8 @@
 cmake_minimum_required(VERSION 3.3)
 project(FalaiseParticleIdentificationPlugin)
 
+include(GNUInstallDirs)
+
 # Ensure our code can see the Falaise headers
 include_directories(${CMAKE_CURRENT_BINARY_DIR})
 include_directories(${CMAKE_CURRENT_SOURCE_DIR}/source)
@@ -100,12 +102,14 @@ list(APPEND FalaiseParticleIdentificationPlugin_SOURCES
 
 ###########################################################################################
 
+find_package(Falaise REQUIRED)
+
 # Build a dynamic library from our sources
 add_library(Falaise_ParticleIdentification SHARED
   ${FalaiseParticleIdentificationPlugin_HEADERS}
   ${FalaiseParticleIdentificationPlugin_SOURCES})
 
-target_link_libraries(Falaise_ParticleIdentification Falaise)
+target_link_libraries(Falaise_ParticleIdentification Falaise::FalaiseModule)
 
 # Apple linker requires dynamic lookup of symbols, so we
 # add link flags on this platform
@@ -121,10 +125,10 @@ endif()
 install(TARGETS Falaise_ParticleIdentification DESTINATION ${CMAKE_INSTALL_LIBDIR}/Falaise/modules)
 
 # - Publish headers
-foreach(_hdrin ${FalaiseParticleIdentificationPlugin_HEADERS})
-  string(REGEX REPLACE "source/falaise/" "" _hdrout "${_hdrin}")
-  configure_file(${_hdrin} ${PROJECT_BUILD_INCLUDEDIR}/falaise/${_hdrout} @ONLY)
-endforeach()
+#foreach(_hdrin ${FalaiseParticleIdentificationPlugin_HEADERS})
+#  string(REGEX REPLACE "source/falaise/" "" _hdrout "${_hdrin}")
+#  configure_file(${_hdrin} ${PROJECT_BUILD_INCLUDEDIR}/falaise/${_hdrout} @ONLY)
+#endforeach()
 
 # Test support:
 option(FalaiseParticleIdentificationPlugin_ENABLE_TESTING "Build unit testing system for FalaiseParticleIdentification" ON)
diff --git a/testing/CMakeLists.txt b/testing/CMakeLists.txt
index 71724e3..a00423a 100644
--- a/testing/CMakeLists.txt
+++ b/testing/CMakeLists.txt
@@ -17,7 +17,7 @@ foreach(_testsource ${FalaiseParticleIdentificationPlugin_TESTS})
   get_filename_component(_testname ${_testsource} NAME_WE)
   set(_testname "falaiseparticleidentificationplugin-${_testname}")
   add_executable(${_testname} ${_testsource})
-  target_link_libraries(${_testname} Falaise_ParticleIdentification)
+  target_link_libraries(${_testname} Falaise::Falaise Falaise_ParticleIdentification)
   # - On Apple, ensure dynamic_lookup of undefined symbols
   if(APPLE)
     set_target_properties(${_testname} PROPERTIES LINK_FLAGS "-undefined dynamic_lookup")
@@ -27,11 +27,11 @@ foreach(_testsource ${FalaiseParticleIdentificationPlugin_TESTS})
     APPEND PROPERTY ENVIRONMENT ${_trackfit_TEST_ENVIRONMENT}
     )
   # - For now, dump them into the testing output directory
-  set_target_properties(${_testname}
-    PROPERTIES
-    RUNTIME_OUTPUT_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/fltests/modules
-    ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/fltests/modules
-    )
+  #set_target_properties(${_testname}
+  #  PROPERTIES
+  #  RUNTIME_OUTPUT_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/fltests/modules
+  #  ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/fltests/modules
+  #  )
 endforeach()
 
 # end of CMakeLists.txt

