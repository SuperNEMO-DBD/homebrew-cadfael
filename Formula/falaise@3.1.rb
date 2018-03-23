class FalaiseAT31 < Formula
  desc "Simulation, Reconstruction and Analysis Software for SuperNEMO"
  homepage "https://github.com/supernemo-dbd/Falaise"
  url "https://github.com/SuperNEMO-DBD/Falaise/archive/Falaise-3.1.1.tar.gz"
  sha256 "5befdf043186860dd4d8c7a07a3ebfb201999e27c8ab0b006849ef83bfc3474c"

  patch do
   # Addresses ROOT 6.12.04 generate_dictionary change
   url "https://github.com/SuperNEMO-DBD/Falaise/pull/76.patch?full_index=1"
   sha256 "a5deadda12c9a46008631e6e001b55aef0920884636787f4774b29a5981f24cf"
  end

  depends_on "cmake" => :build
  depends_on "supernemo-dbd/cadfael/doxygen" => :build
  # Bayeux dependency pulls in all additional deps of Falaise at present
  depends_on "supernemo-dbd/cadfael/bayeux"

  needs :cxx11

  keg_only :versioned_formula

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
