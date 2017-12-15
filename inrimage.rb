
class Inrimage < Formula
  desc "Scientific image processing software"
  homepage "http://inrimage.gforge.inria.fr"
  url "http://inrimage.gforge.inria.fr/dist/4.6.8/inrimage-4.6.8.tar.gz"
  sha256 "b7182c7feed6b93acc35c0f6cac921dd1aeb02c180d7c2d178e6428158415412"

  depends_on :x11
  depends_on "gcc"
  depends_on "jpeg" => :recommended
  depends_on "libtiff" => :recommended
  depends_on "libpng" => :recommended
  depends_on "netpbm" => :recommended
  depends_on "jasper" => :recommended
  depends_on "hdf5" => :recommended
  depends_on "gtk+"

  def install
    ENV.deparallelize

    system "./configure", "--prefix=#{prefix}", "--disable-build-fonts"
    system "cd share/fonts; tar xf font.tgz"
    system "make", "install"
  end

  test do
    system "#{bin}/inrinfo"
    (testpath/"test.c").write <<~EOS
      #include <inrimage/image.h>
      int main(int argc, char **argv) {
      Fort_int lfmt[] = { 3, 1, 1, 0, 3, 1, 1, 1, 0};
      unsigned char buf[] = {0,127,255};
      struct image *nf;
      inr_init(argc,argv,"1.0","","");
      nf = image_(">","c"," ",lfmt);
      c_ecr(nf, 1, buf);
      fermnf_(&nf);
      return 0;
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-linrimage"
    system "./test | #{bin}/tpr".to_s
  end
end
