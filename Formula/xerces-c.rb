class XercesC < Formula
  desc "Validating XML parser"
  homepage "https://xerces.apache.org/xerces-c/"
  url "https://www.apache.org/dyn/closer.cgi?path=xerces/c/3/sources/xerces-c-3.1.2.tar.gz"
  sha256 "743bd0a029bf8de56a587c270d97031e0099fe2b7142cef03e0da16e282655a0"

  depends_on "cmake" => :build
  resource "XercesCCMakeSupport" do
    url "https://github.com/SuperNEMO-DBD/XercesCCMakeSupport.git", :using => :git
  end

  option :universal
  option :cxx11

  def install
    ENV.universal_binary if build.universal?
    ENV.cxx11 if build.cxx11?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
    # Remove a sample program that conflicts with libmemcached
    # on case-insensitive file systems
    (bin/"MemParse").unlink

    # Install cmake support files
    resources.each do |r|
      r.stage do
        xercesc_support_args = std_cmake_args
        xercesc_support_args << "-Dxercesc_VERSION=#{version}"
        system "cmake", *xercesc_support_args
        system "make install"
      end
    end
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
