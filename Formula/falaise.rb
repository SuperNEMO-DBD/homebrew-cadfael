class Falaise < Formula
  desc "Falaise Software for SuperNEMO"
  homepage ""
  url "https://files.warwick.ac.uk/supernemo/files/Cadfael/distfiles/Falaise-2.0.1-Source.tar.bz2"
  version "2.0.1"
  sha256 "01991eea64267585b4303b6e77a49b6113a0ea51815cf983d28dc73ae6ecd931"

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
      fl_cmake_args << "-DFalaise_USE_SYSTEM_BAYEUX=ON"
      system "cmake", "..", *fl_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/flsimulate", "-o", "test.txt"
  end
end