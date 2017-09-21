class Camp < Formula
  desc "Tegesoft C++ reflection library"
  homepage "https://github.com/tegesoft/camp"
  url "https://github.com/drbenmorgan/camp.git", :revision => "7564e57f7b406d1021290cf2260334d57d8df255"
  version "0.8.0"
  revision 1

  needs :cxx11

  depends_on "cmake" => :build
  depends_on "doxygen" => [:optional, :build]
  depends_on "supernemo-dbd/cadfael/boost"

  def install
    ENV.cxx11
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "doc" if build.with? "doxygen"
    system "make", "install"
  end

  test do
    system "false"
  end
end
