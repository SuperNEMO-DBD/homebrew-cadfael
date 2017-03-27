require "formula"

class Qt5Base < Formula
  homepage "http://qt-project.org/"
  url "http://download.qt.io/official_releases/qt/5.8/5.8.0/submodules/qtbase-opensource-src-5.8.0.tar.gz"
  sha256 "0f6ecd94abd148f1ea4ad08905308af973c6fad9e8fca7491d68dbc8fbd88872"

  # try submodules as resources
  resource "qtsvg" do
    url "http://download.qt.io/official_releases/qt/5.8/5.8.0/submodules/qtsvg-opensource-src-5.8.0.tar.gz"
    sha256 "542a3a428992c34f8eb10489231608edff91e96ef69186ffa3e9c2f6257a012f"
  end

  keg_only "Qt5 very picky about install locations, so keep it isolated"

  conflicts_with "qt5", :because => "Core homebrew ships a complete Qt5 install"

  depends_on :xcode => :build if OS.mac?
  depends_on "pkg-config" => :build
  depends_on "icu4c" => ["c++11"] if OS.linux?

  def install
    args = %W[
      -verbose
      -prefix #{prefix}
      -release
      -opensource -confirm-license
      -system-zlib
      -qt-libpng
      -qt-libjpeg
      -qt-freetype
      -qt-pcre
      -nomake tests
      -nomake examples
      -pkg-config
      -c++std c++14
    ]

    if OS.linux?
      # Minimizes X11 dependencies
      # See
      # https://github.com/Linuxbrew/homebrew-core/pull/1062
      args << "-qt-xcb"
      # Need to use -R as qt5 seemingly ignores LDFLAGS, and doesn't
      # use -L paths provided by pkg-config. Configure can have odd
      # effects depending on what system provides.
      # Qt5 is keg-only, so add its own libdir
      args << "-R#{lib}"
      # If we depend on anything from brew, then need the core path
      args << "-R#{HOMEBREW_PREFIX}/lib"
      # If we end up depending on any keg_only Formulae, add extra
      # -R lines for each of them below here.
    end

    system "./configure", *args
    # Cannot parellize build os OSX
    system "make"
    system "make", "install"

    resource("qtsvg").stage {
      system "#{bin}/qmake"
      system "make", "install"
    }
  end

  def caveats; <<-EOS.undent
    We agreed to the Qt opensource license for you.
    If this is unacceptable you should uninstall.
    EOS
  end
end
