class FalaiseAT32 < Formula
  desc "Simulation, Reconstruction and Analysis Software for SuperNEMO"
  homepage "https://github.com/supernemo-dbd/Falaise"
  url "https://github.com/SuperNEMO-DBD/Falaise/archive/Falaise-3.2.0.tar.gz"
  sha256 "a84c278b8f27b75138a9604d07ffa852fc036d42b3f8080688466ff38270b7ac"

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "supernemo-dbd/cadfael/doxygen" => :build
  # Bayeux dependency pulls in all additional deps of Falaise at present
  depends_on "supernemo-dbd/cadfael/bayeux"

  needs :cxx11

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
    system "#{bin}/flreconstruct", "-i", "test.brio", "-p", "urn:snemo:demonstrator:reconstruction:1.0.0", "-o", "test.root"
  end
end
