class Falaise < Formula
  desc "Simulation, Reconstruction and Analysis Software for SuperNEMO"
  homepage "https://supernemo-dbd.github.io"
  url "https://files.warwick.ac.uk/supernemo/files/Cadfael/distfiles/Falaise-3.0.0.tar.bz2"
  version "3.0.0"
  sha256 "2cba670ce626887270af5f6e98106c6f07c5f3214fb281af5ef7894442d544d7"

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
