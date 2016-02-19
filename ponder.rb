class Ponder < Formula
  desc "C++ Reflection Library"
  homepage "http://billyquith.github.io/ponder/"
  url "https://github.com/billyquith/ponder/archive/1.0.1.tar.gz"
  version "1.0.1"
  sha256 "fe35a6edfe586d0be233a03d1e7e4eb5e715dcbcdb57636793ed09ac70276156"
  head "https://github.com/billyquith/ponder.git"

  depends_on "cmake" => :build
  needs :cxx11

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install" # if this fails, try separate make/make install steps
  end

  test do
    system "false"
  end
end
