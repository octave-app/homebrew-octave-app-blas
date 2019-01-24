class BlasRi < Formula
  desc "BLAS Reference Implementation from Netlib"
  homepage "http://www.netlib.org/blas/"
  url "http://www.netlib.org/blas/blas-3.8.0.tgz"
  sha256 "55df2a24966c2928d3d2ab4a20e9856d9914b856cf4742ebd4f7a4507c8e44e8"

  keg_only :provided_by_macos,
           "macOS provides BLAS in the Accelerate framework"

  depends_on "gcc"

  def install
    ENV.deparallelize
    inreplace "make.inc", "PLAT = _LINUX", "PLAT ="
    system "make", "all"
    lib.mkdir
    lib.install "blas.a"
  end

  test do
    (testpath/"test.f90").write <<~EOS
    program main
      print *, 'Hello, world!'
    end program main
    EOS
    system "gfortran", "-o", "test", "test.f90",
      "-L#{lib}", "-lblas"
    system "./test"
  end
end
