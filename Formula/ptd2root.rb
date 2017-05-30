class Ptd2root < Formula
  desc "Falaise plugin to convert BRIO reconstruction output to ROOT"
  homepage "https://github.com/SuperNEMO-DBD/PTD2Root"
  url "https://github.com/SuperNEMO-DBD/PTD2Root/archive/v1.0.0.tar.gz"
  sha256 "a469ce8708188c2a6601b80e9cafb7d6fea4cf0f1e88e527d77fec13c37ceed4"
  head "https://github.com/SuperNEMO-DBD/PTD2Root.git", :branch => "develop"

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
