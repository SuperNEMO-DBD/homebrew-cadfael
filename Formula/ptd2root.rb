class Ptd2root < Formula
  desc "Falaise plugin to convert BRIO reconstruction output to ROOT"
  homepage "https://github.com/SuperNEMO-DBD/PTD2Root"
  url "https://github.com/SuperNEMO-DBD/PTD2Root/archive/v0.1.0.tar.gz"
  sha256 "394a53a5d25b0907a7b60c2d6f81f695b2362e1b30519cad57de5ae5cc917d77"

  depends_on "cmake" => :build
  depends_on "supernemo-dbd/cadfael/falaise"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/flptd2root.py", "--help"
  end
end
