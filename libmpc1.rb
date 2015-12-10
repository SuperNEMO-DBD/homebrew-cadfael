class Libmpc1 < Formula
  homepage "http://multiprecision.org"
  url "http://ftpmirror.gnu.org/mpc/mpc-1.0.3.tar.gz"
  mirror "http://multiprecision.org/mpc/download/mpc-1.0.3.tar.gz"
  sha1 "b8be66396c726fdc36ebb0f692ed8a8cca3bcc66"

  bottle do
    cellar :any
    sha1 "c96c76d63b166fb13e6818a0ae7094455002b420" => :yosemite
    sha1 "b1a74b2c579600f12002a842bc8ddd82785277ce" => :mavericks
    sha1 "5fe25b2992da6773db6fec8a72260272a6058782" => :mountain_lion
  end

  keg_only "Conflicts with libmpc in main repository"

  depends_on "gmp6"
  depends_on "mpfr3"

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{Formula["gmp6"].lib}"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{Formula["mpfr3"].lib}"

    args = [
      "--prefix=#{prefix}",
      "--disable-dependency-tracking",
      "--with-gmp=#{Formula["gmp6"].opt_prefix}",
      "--with-mpfr=#{Formula["mpfr3"].opt_prefix}"
    ]

    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <mpc.h>

      int main()
      {
        mpc_t x;
        mpc_init2 (x, 256);
        mpc_clear (x);
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-I#{Formula["gmp6"].include}", "-L#{Formula["gmp6"].lib}", "-lgmp", "-I#{Formula["mpfr3"].include}", "-L#{Formula["mpfr3"].lib}", "-lmpfr", "-L#{lib}", "-lmpc", "-o", "test"
    system "./test"
  end
end
