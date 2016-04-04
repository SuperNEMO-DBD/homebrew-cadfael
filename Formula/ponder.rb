class Ponder < Formula
  desc "C++ Reflection Library"
  homepage "http://billyquith.github.io/ponder/"
  url "https://github.com/billyquith/ponder/archive/1.0.1.tar.gz"
  version "1.0.1"
  sha256 "fe35a6edfe586d0be233a03d1e7e4eb5e715dcbcdb57636793ed09ac70276156"
  head "https://github.com/billyquith/ponder.git"
  revision 2

  patch :DATA

  depends_on "cmake" => :build
  option "with-doxygen", "Build documentation for ponder"
  depends_on "doxygen" => [:optional,:build]
  needs :cxx11

  def install
    mkdir "brew-ponder-build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install" 
    end
  end

  test do
    system "false"
  end
end
__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index f8b25ef..0118fa4 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -51,13 +51,9 @@ set(PONDER_SRCS
     ${SRC_SOURCE}
 )
 
-# find Boost - for unit testing
-find_package(Boost 1.38.0 REQUIRED)
-
 # include files search paths
 include_directories(
     ${PONDER_SOURCE_DIR}/include
-    ${Boost_INCLUDE_DIRS}
 )
 
 # generate version.hpp
@@ -65,11 +61,60 @@ message("Generate version.hpp")
 configure_file(${CMAKE_SOURCE_DIR}/version.in ${CMAKE_SOURCE_DIR}/include/ponder/version.hpp @ONLY)
 
 # instruct CMake to build a shared library from all of the source files
+set(CMAKE_CXX_EXTENSIONS OFF)
+
 add_library(ponder ${PONDER_SRCS})
 
 # required standard level (needed to pass -std=c++11 to gcc and clang)
-set_property(TARGET ponder PROPERTY CXX_STANDARD 11) # fails silently
-target_compile_features(ponder PRIVATE cxx_range_for cxx_variable_templates) # required
+
+# GCC 4.9 appears to be earliest version that compiles ponder,
+# so use its compile feature list as conservative minimum
+target_compile_features(ponder PUBLIC
+  cxx_alias_templates
+  cxx_alignas
+  cxx_alignof
+  cxx_attributes
+  cxx_auto_type
+  cxx_constexpr
+  cxx_decltype
+  cxx_decltype_incomplete_return_types
+  cxx_default_function_template_args
+  cxx_defaulted_functions
+  cxx_defaulted_move_initializers
+  cxx_delegating_constructors
+  cxx_deleted_functions
+  cxx_enum_forward_declarations
+  cxx_explicit_conversions
+  cxx_extended_friend_declarations
+  cxx_extern_templates
+  cxx_final
+  cxx_func_identifier
+  cxx_generalized_initializers
+  cxx_inheriting_constructors
+  cxx_inline_namespaces
+  cxx_lambdas
+  cxx_local_type_template_args
+  cxx_long_long_type
+  cxx_noexcept
+  cxx_nonstatic_member_init
+  cxx_nullptr
+  cxx_override
+  cxx_range_for
+  cxx_raw_string_literals
+  cxx_reference_qualified_functions
+  cxx_right_angle_brackets
+  cxx_rvalue_references
+  cxx_sizeof_member
+  cxx_static_assert
+  cxx_strong_enums
+  cxx_trailing_return_types
+  cxx_unicode_literals
+  cxx_uniform_initialization
+  cxx_unrestricted_unions
+  cxx_user_literals
+  cxx_variadic_macros
+  cxx_variadic_templates
+  )
 
 # define the export macro
 if(BUILD_SHARED_LIBS)
