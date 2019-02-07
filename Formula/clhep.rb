class Clhep < Formula
  desc "C++ Class Library for High Energy Physics"
  homepage "http://proj-clhep.web.cern.ch/proj-clhep/"
  revision 1

  stable do
    url "http://proj-clhep.web.cern.ch/proj-clhep/DISTRIBUTION/tarFiles/clhep-2.1.3.1.tgz"
    sha256 "5d3e45b39a861731fe3a532bb1426353bf62b54c7b90ecf268827e50f925642b"

    # Patch for clang compatibility, adapted from MacPorts
    patch :DATA
  end

  devel do
    url "http://proj-clhep.web.cern.ch/proj-clhep/DISTRIBUTION/tarFiles/clhep-2.3.1.0.tgz"
    sha256 "66272ae3100d3aec096b1298e1e24ec25b80e4dac28332b45ec3284023592963"
  end

  depends_on "cmake" => :build

  def install
    ENV.cxx11
    mkdir "clhep-build" do
      system "cmake", "../CLHEP", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <iostream>
      #include <Vector/ThreeVector.h>

      int main() {
        CLHEP::Hep3Vector aVec(1, 2, 3);
        std::cout << "r: " << aVec.mag();
        std::cout << " phi: " << aVec.phi();
        std::cout << " cos(theta): " << aVec.cosTheta() << std::endl;
        return 0;
      }
    EOS
    system ENV.cxx, "-L#{lib}", "-lCLHEP", "-I#{include}/CLHEP",
           testpath/"test.cpp", "-o", "test"
    assert_equal "r: 3.74166 phi: 1.10715 cos(theta): 0.801784",
                 shell_output("./test").chomp
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
