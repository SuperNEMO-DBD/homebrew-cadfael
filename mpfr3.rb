class Mpfr3 < Formula
  desc "C library for multiple-precision floating-point computations"
  homepage "http://www.mpfr.org/"
  # Upstream is down a lot, so use mirrors
  url "https://mirrors.kernel.org/debian/pool/main/m/mpfr4/mpfr4_3.1.3.orig.tar.xz"
  mirror "https://ftp.gnu.org/gnu/mpfr/mpfr-3.1.3.tar.xz"
  sha256 "6835a08bd992c8257641791e9a6a2b35b02336c8de26d0a8577953747e514a16"

  # http://www.mpfr.org/mpfr-current/allpatches
  patch do
    url "https://gist.github.com/anonymous/3a7d24cf2c68f21eb940/raw/471e928fcdbfb5c2fa7428cfb496496e6ee469aa/mpfr-3.1.3.diff"
    sha256 "1ca002acc121413b9ce39e9f12bb6efe4bed4ec45cf3f3ffcff122b94f6694de"
  end

  keg_only "Conflicts with mpfr in main repository"

  option "32-bit"

  depends_on "supernemo-dbd/cadfael/gmp6"

  fails_with :clang do
    build 421
    cause <<-EOS.undent
      clang build 421 segfaults while building in superenv;
      see https://github.com/Homebrew/homebrew/issues/15061
      EOS
  end

  def install
    ENV.m32 if build.build_32_bit?

    # Fix error makeinfo: command not found
    # The mpfr.info timestamp is older than the mpfr.texi timestamp.
    touch "doc/mpfr.info"

    gmp6 = Formula["gmp6"]
    ENV.append "LDFLAGS", "-Wl,-rpath,#{gmp6.lib}"

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}", "--with-gmp=#{gmp6.opt_prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <gmp.h>
      #include <mpfr.h>

      int main()
      {
        mpfr_t x;
        mpfr_init(x);
        mpfr_clear(x);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-I#{Formula["gmp6"].include}" , "-L#{Formula["gmp6"].lib}", "-lgmp", "-L#{lib}", "-lmpfr", "-o", "test"
    system "./test"
  end
end
