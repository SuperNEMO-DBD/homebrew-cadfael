class Falaise < Formula
  desc "Falaise Software for SuperNEMO"
  homepage ""
  url "https://files.warwick.ac.uk/supernemo/files/Cadfael/distfiles/Falaise-2.1.0.tar.gz"
  version "2.1.0"
  sha256 "d3daa4b7c1ce623e584b976e53f5822643803255c5a8aaa32eb3ff1b52b9d576"

  depends_on "cmake" => :build
  depends_on "doxygen" => :build

  needs :cxx11

  # Bayeux dependency pulls in all additional deps of Falaise at present
  depends_on "supernemo-dbd/cadfael/bayeux"

  def install
    ENV.cxx11
    mkdir "falaise.build" do
      fl_cmake_args = std_cmake_args
      fl_cmake_args << "-DCMAKE_INSTALL_LIBDIR=lib"
      fl_cmake_args << "-DFALAISE_CXX_STANDARD=11"
      bx_cmake_args << "-DFALAISE_COMPILER_ERROR_ON_WARNING=OFF"
      system "cmake", "..", *fl_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/flsimulate", "-o", "test.brio"
  end
end
