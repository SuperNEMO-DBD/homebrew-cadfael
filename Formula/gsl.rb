require 'formula'

class Gsl < Formula
  homepage 'http://www.gnu.org/software/gsl/'
  url 'http://ftpmirror.gnu.org/gsl/gsl-1.15.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/gsl/gsl-1.15.tar.gz'
  sha1 'd914f84b39a5274b0a589d9b83a66f44cd17ca8e'

  option :universal

  depends_on "cmake" => :build
  resource "GSLCMakeSupport" do
    url "https://github.com/SuperNEMO-DBD/GSLCMakeSupport.git", :using => :git
  end

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
    (testpath/"CMakeLists.txt").write <<-EOS.undent
    project(testGSL C)
    find_package(GSL REQUIRED NO_MODULE)
    add_executable(testGSL testGSL.c)
    target_include_directories(testGSL PRIVATE ${GSL_INCLUDE_DIRS})
    target_link_libraries(testGSL gsl)
    EOS

    (testpath/"testGSL.c").write <<-EOS.undent
    #include <gsl/gsl_version.h>
    int main(int argc, char** argv) {
    return 0;
    }
    EOS

    system "cmake", *std_cmake_args
    system "make"
    system "./testGSL"
  end
end
