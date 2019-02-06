class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "http://xrootd.org"
  url "http://xrootd.org/download/v4.6.1/xrootd-4.6.1.tar.gz"
  sha256 "0261ce760e8788f85d68918d7702ae30ec677a8f331dae14adc979b4cc7badf5"
  head "https://github.com/xrootd/xrootd.git"

  depends_on "cmake" => :build
  depends_on "libxml2"
  depends_on "openssl"
  depends_on "python@2"
  depends_on "readline"

  def install
    ENV.cxx11
    mkdir "build" do
      system "cmake", "..", "-DCMAKE_INSTALL_LIBDIR=#{lib}", "-DENABLE_FUSE=OFF", "-DENABLE_KRB5=OFF", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/xrootd", "-H"
  end
end
