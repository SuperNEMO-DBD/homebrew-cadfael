require 'formula'

# Please don't update me to the 2.x branch yet until issues discussed in
# https://github.com/Homebrew/homebrew/issues/45812 are resolved.
# If you want 2.x now, file a PR in homebrew/versions. Thanks!

class Gsl < Formula
  homepage 'http://www.gnu.org/software/gsl/'
  stable do
    url 'http://ftpmirror.gnu.org/gsl/gsl-1.16.tar.gz'
    sha256 "73bc2f51b90d2a780e6d266d43e487b3dbd78945dd0b04b14ca5980fe28d2f53"
  end

  # - Temporary resource bundle to allow use of imported targets
  #   for GSl from Falaise/Bayeux
  #   Remove me when CMake is at least 3.5 and Bayeux/Falaise at least 2.1
  depends_on "cmake" => :build
  resource "GSLCMakeSupport" do
    url "https://github.com/SuperNEMO-DBD/GSLCMakeSupport.git", :using => :git
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make" # A GNU tool which doesn't support just make install! Shameful!
    system "make install"

    # Install cmake support files
    resources.each do |r|
      r.stage do
        gsl_support_args = std_cmake_args
        gsl_support_args << "-Dgsl_VERSION=#{version}"
        system "cmake", *gsl_support_args
        system "make install"
      end
    end

  end

  test do
    system bin/"gsl-randist", "0", "20", "cauchy", "30"
  end
end
