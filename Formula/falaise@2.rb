class FalaiseAT2 < Formula
  desc "Falaise Software for SuperNEMO"
  homepage ""
  url "https://files.warwick.ac.uk/supernemo/files/Cadfael/distfiles/Falaise-2.2.0-rc1.tar.bz2"
  version "2.2.0"
  sha256 "53399b8fb574c5f72196476eed14624e2eeab86fb7e9bd6a464e663071385266"

  keg_only "Conflicts with newer production versions"

  depends_on "cmake" => :build
  depends_on "supernemo-dbd/cadfael/doxygen" => :build

  needs :cxx11

  # Bayeux dependency pulls in all additional deps of Falaise at present
  depends_on "supernemo-dbd/cadfael/bayeux@2"

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
    system "#{bin}/flreconstruct", "-i", "test.brio", "-p", "@falaise:pipeline/snemo.demonstrator/1.0.0", "-o", "test.root"
  end
end

