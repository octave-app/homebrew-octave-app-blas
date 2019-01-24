class Blis < Formula
  desc "BLAS-like Library Instantiation Software Framework"
  homepage "https://github.com/flame/blis"
  url "https://github.com/flame/blis/archive/0.5.1.tar.gz"
  sha256 "7816a1f6085b1d779f074bca2435c195c524582edbb04d9cd399dade9187a72d"
  head "https://github.com/flame/blis.git"

  def install
    # If we create bottles, "auto" will need to be replaced by e.g. "haswell"
    system "./configure", "--prefix=#{prefix}",
                          "auto"
    system "make", "V=1", "BLIS_ENABLE_DYNAMIC_BUILD=yes"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <blis/blis.h>

      int main(int argc, char *argv[]) {
        printf("%s", "Hello, world!\\n");
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-o", "test_static", "#{opt_lib}/libblis.a"
    system "./test_static"
    #TODO: This "-L" shouldn't be necessary because this keg is linked
    system ENV.cc, "test.c", "-o", "test_dynamic", "-L#{opt_lib}", "-lblis"
    system "./test_dynamic"
  end
end
