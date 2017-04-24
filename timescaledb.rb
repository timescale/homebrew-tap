class Timescaledb < Formula
  desc "An open-source time-series database optimized for fast ingest and complex queries. Fully compatible with PostgreSQL."
  homepage "https://www.timescaledb.com"
  url "https://timescalereleases.blob.core.windows.net/homebrew/timescaledb-0.0.9-beta.tar.gz"
  version "0.0.9-beta"
  sha256 "59d90cf14f0e6e2df6fc6bfc19a3200ea9a2b80ff64589658798d44515501521"

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
