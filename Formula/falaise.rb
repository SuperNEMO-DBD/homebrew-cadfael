class Falaise < Formula
  desc "Simulation, Reconstruction and Analysis Software for SuperNEMO"
  homepage "https://github.com/supernemo-dbd/Falaise"
  url "https://github.com/SuperNEMO-DBD/Falaise/archive/Falaise-3.1.1.tar.gz"
  sha256 "5befdf043186860dd4d8c7a07a3ebfb201999e27c8ab0b006849ef83bfc3474c"

  head "https://github.com/SuperNEMO-DBD/Falaise.git", :branch => "develop"

  depends_on "cmake" => :build
  depends_on "supernemo-dbd/cadfael/doxygen" => :build

  needs :cxx11

  # Bayeux dependency pulls in all additional deps of Falaise at present
  depends_on "supernemo-dbd/cadfael/bayeux"

  def install
    ENV.cxx11
    # Create a base directory for plugins that can be linked into by
    # plugins
    falaise_modules = HOMEBREW_PREFIX/"lib/Falaise/modules"
    falaise_modules.mkpath

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
