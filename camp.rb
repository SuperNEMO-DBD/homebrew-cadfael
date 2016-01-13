require 'formula'

class Camp < Formula
  homepage "https://github.com/tegesoft/camp"
  url "https://github.com/drbenmorgan/camp.git", :revision => "7564e57f7b406d1021290cf2260334d57d8df255"
  version "0.8.0"

  option :cxx11

  depends_on "cmake" => :build

  # This appears to be a more robust way of defining options so that the
  # dependency is always installed
  option "with-doxygen", "Build with doxygen documentation"
  depends_on "doxygen" => [:optional, :build] 

  if build.cxx11?
    depends_on "supernemo-dbd/cadfael/boost" => "c++11"
  else
    depends_on "supernemo-dbd/cadfael/boost"
  end

  def install
    ENV.cxx11 if build.cxx11?
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "doc" if build.with? "doxygen"
    system "make", "install"
  end

  test do
    system "false"
  end
end
