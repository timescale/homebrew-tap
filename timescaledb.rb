class Timescaledb < Formula
  desc "An open-source time-series database optimized for fast ingest and complex queries. Fully compatible with PostgreSQL."
  homepage "https://www.timescaledb.com"
  url "https://timescalereleases.blob.core.windows.net/homebrew/timescaledb-0.5.0.tar.gz"
  version "0.5.0"
  sha256 "93c27fd20deb8fe36b1b7238c5205ba438b65844e882e2f581db4db46ae46592"

  depends_on "postgresql@9.6" => :build

  def install
    system "make"
    system "make", "install", "DESTDIR=#{buildpath}/stage"
    (lib/"postgresql").install Dir["stage/**/lib/postgresql/timescaledb.so"]
    (share/"postgresql/extension").install Dir["stage/**/share/postgresql/extension/*"]
  end

  test do
    pglib = (lib/"postgresql")
    system "test", "-e", "#{pglib}/timescaledb.so"
  end

  def caveats
    pgvar = (var/"postgres")
    s = "Make sure to update #{pgvar}/postgresql.conf to include the extension:\n\n"
    s += "shared_preload_libraries = 'timescaledb'\n\n"
    s
  end
end
