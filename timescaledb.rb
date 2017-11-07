class Timescaledb < Formula
  desc "An open-source time-series database optimized for fast ingest and complex queries. Fully compatible with PostgreSQL."
  homepage "https://www.timescaledb.com"
  url "https://timescalereleases.blob.core.windows.net/homebrew/timescaledb-0.6.1.tar.gz"
  version "0.6.1"
  sha256 "5d570c3931eb6363c07a9f7bc0b15cf75b26ea9890b5681c19790b719fe4a211"

  depends_on "postgresql@9.6" => :build

  def install
    system "make"
    system "make", "install", "DESTDIR=#{buildpath}/stage"
    libdir = `pg_config --libdir`
    sharedir = `pg_config --sharedir`
    `touch timescaledb_move.sh`
    `chmod +x timescaledb_move.sh`
    `echo "#!/bin/bash" >> timescaledb_move.sh`
    `echo "echo 'Moving files into place...'" >> timescaledb_move.sh`
    `echo "/usr/bin/install -c -m 755 #{lib}/timescaledb/timescaledb.so #{libdir.strip}/timescaledb.so" >> timescaledb_move.sh`
    `echo "/usr/bin/install -c -m 644 #{share}/timescaledb/* #{sharedir.strip}/extension/" >> timescaledb_move.sh`
    `echo "echo 'Success.'" >> timescaledb_move.sh`
    bin.install "timescaledb_move.sh"
    (lib/"timescaledb").install Dir["stage/**/lib/*"]
    (share/"timescaledb").install Dir["stage/**/share/postgresql@9.6/extension/*"]
    end

  test do
    system "test", "-e", "#{lib}/timescaledb/timescaledb.so"
  end

  def caveats
    pgvar = (var/"postgresql@9.6")
    s = "Make sure to update #{pgvar}/postgresql.conf to include the extension:\n\n"
    s += "  shared_preload_libraries = 'timescaledb'\n\n"
    s += "To finish the installation, you will need to run:\n\n"
    s += "  $ timescaledb_move.sh\n\n"
    s += "This will install the extension files in the proper place. Finally, restart:\n\n"
    s += "  $ brew services restart postgresql@9.6\n\n"
    s
  end
end
