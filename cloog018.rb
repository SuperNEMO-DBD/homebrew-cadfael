require 'formula'

class Cloog018 < Formula
  homepage 'http://www.cloog.org/'
  url 'http://www.bastoul.net/cloog/pages/download/count.php3?url=./cloog-0.18.1.tar.gz'
  mirror 'http://gcc.cybermirror.org/infrastructure/cloog-0.18.1.tar.gz'
  sha1 '2dc70313e8e2c6610b856d627bce9c9c3f848077'

  bottle do
    cellar :any
    revision 2
    sha1 "65900e9655ab8f444ecf7edf4118caa01ca56ddb" => :yosemite
    sha1 "851f64756bb082a5a354e0992976acd70cfdacbf" => :mavericks
    sha1 "06252f0a9c453818c319b21647ebaa9a26c3f4ac" => :mountain_lion
    sha1 "1a2edaabaceee7c5079d4142c90b972b0345902e" => :x86_64_linux
  end

  head do
    url 'http://repo.or.cz/r/cloog.git'
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only "Conflicts with cloog in main repository"

  depends_on 'pkg-config' => :build
  depends_on 'gmp6'
  depends_on 'isl012'

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{Formula["gmp6"].lib}"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{Formula["isl012"].lib}"
    
    system "./autogen.sh" if build.head?

    args = [
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
      "--with-gmp=system",
      "--with-gmp-prefix=#{Formula["gmp6"].opt_prefix}",
      "--with-isl=system",
      "--with-isl-prefix=#{Formula["isl012"].opt_prefix}"
    ]

    args << "--with-osl=bundled" if build.head?

    system "./configure", *args
    system "make install"
  end

  test do
    cloog_source = <<-EOS.undent
      c

      0 2
      0

      1

      1
      0 2
      0 0 0
      0

      0
    EOS

    output = pipe_output("#{bin}/cloog /dev/stdin", cloog_source)
    assert_match /Generated from \/dev\/stdin by CLooG/, output
  end
end
