require "formula"

class Clhep < Formula
  homepage "http://proj-clhep.web.cern.ch/proj-clhep/"
  url "http://proj-clhep.web.cern.ch/proj-clhep/DISTRIBUTION/tarFiles/clhep-2.1.3.1.tgz"
  sha1 "3ef0b7410d71ca25bb2f5b5ba6d928a338e30e6e"

  # Patch for clang compatibility, adapted from MacPorts
  patch :DATA

  option :cxx11

  depends_on "cmake" => :build

  def install
    ENV.cxx11 if build.cxx11?
    mkdir "clhep-build" do
      system "cmake", "../CLHEP", *std_cmake_args
      system "make install"
    end
  end
end

__END__
# https://savannah.cern.ch/bugs/?104110
# https://trac.macports.org/ticket/42841
#
--- a/CLHEP/Matrix/src/Vector.cc.orig
+++ b/CLHEP/Matrix/src/Vector.cc
@@ -114,9 +114,9 @@ HepVector::HepVector(const HepMatrix &hm1)
 
 // trivial methods
 
-inline int HepVector::num_row() const {return nrow;} 
-inline int HepVector::num_size() const {return nrow;} 
-inline int HepVector::num_col() const { return 1; }
+int HepVector::num_row() const {return nrow;}
+int HepVector::num_size() const {return nrow;}
+int HepVector::num_col() const { return 1; }
 
 // operator()
 
--- a/CLHEP/Random/Random/Randomize.h.orig
+++ b/CLHEP/Random/Random/Randomize.h
@@ -65,7 +65,11 @@
 // On some compilers the static instance of the HepRandom generator
 // needs to be created explicitly in the client code (i.e. here).

-static int HepRandomGenActive = HepRandom::createInstance();
+#if __GNUC__
+static const int HepRandomGenActive __attribute__((unused)) = HepRandom::createInstance();
+#else
+static const int HepRandomGenActive = HepRandom::createInstance();
+#endif

 }  // namespace CLHEP
