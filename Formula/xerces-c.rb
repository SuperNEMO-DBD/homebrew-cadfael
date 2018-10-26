class XercesC < Formula
  desc "Validating XML parser"
  homepage "https://xerces.apache.org/xerces-c/"
  url "https://archive.apache.org/dist/xerces/c/3/sources/xerces-c-3.1.4.tar.gz"
  sha256 "c98eedac4cf8a73b09366ad349cb3ef30640e7a3089d360d40a3dde93f66ecf6"
  revision 4

  needs :cxx11

  depends_on "curl" unless OS.mac?
  depends_on "icu4c" unless OS.mac?

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    # Remove a sample program that conflicts with libmemcached
    # on case-insensitive file systems
    (bin/"MemParse").unlink
  end

  test do
    (testpath/"ducks.xml").write <<-EOS.undent
      <?xml version="1.0" encoding="iso-8859-1"?>

      <ducks>
        <person id="Red.Duck" >
          <name><family>Duck</family> <given>One</given></name>
          <email>duck@foo.com</email>
        </person>
      </ducks>
    EOS

    assert_match /(6 elems, 1 attrs, 0 spaces, 37 chars)/, shell_output("#{bin}/SAXCount #{testpath}/ducks.xml")
  end
end
