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


  keg_only "Qt5 conflicts with the more widely used Qt4"
  conflicts_with "qt5", :because => "Core homebrew ships a complete Qt5 install"

  depends_on :xcode => :build if OS.mac?
  depends_on "pkg-config" => :build

  def install
    args = ["-prefix", prefix,
            "-opensource",
            "-confirm-license",
            "-release",
            "-nomake", "tests",
            "-nomake", "examples",
            "-system-zlib",
            "-qt-libpng",
            "-qt-libjpeg",
            "-qt-freetype",
            "-qt-pcre"]

    args << "-qt-xcb" if OS.linux?

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
