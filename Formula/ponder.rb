class Ponder < Formula
  desc "C++ Reflection Library"
  homepage "http://billyquith.github.io/ponder/"
  url "https://github.com/billyquith/ponder/archive/1.1.0.tar.gz"
  version "1.1.0"
  sha256 "e048301041894565c0e13ca877ed2f49a17a226d86a7ed641b28c2589836346e"
  head "https://github.com/billyquith/ponder.git"

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  needs :cxx11

  def install
    mkdir "brew-ponder-build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install" 
    end
  end

  test do
    system "false"
  end
end

