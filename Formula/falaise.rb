class Falaise < Formula
  desc "Simulation, Reconstruction and Analysis Software for SuperNEMO"
  homepage "https://supernemo-dbd.github.io"
  url "https://files.warwick.ac.uk/supernemo/files/Cadfael/distfiles/Falaise-3.0.0.tar.bz2"
  version "3.0.0"
  sha256 "c445ba9720df5d5c7771728528d9e4af3d5523e9d31ada56e60c034ed611dc33"

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
    system "#{bin}/flreconstruct", "-i", "test.brio", "-p", "urn:snemo:demonstrator:reconstruction:1.0.0", "-o", "test.root"
  end
end
