class Timescaledb < Formula
  desc "An open-source time-series database optimized for fast ingest and complex queries. Fully compatible with PostgreSQL."
  homepage "https://www.timescaledb.com"
  url "https://timescalereleases.blob.core.windows.net/homebrew/timescaledb-0.8.0.tar.gz"
  version "0.8.0"
  sha256 "c4010b246ffd0e1247914f884dffff3971b0e590ac52ccb842a23ab015b4f299"

  depends_on "cmake" => :build
  depends_on "postgresql" => :build

  def install
    system "./bootstrap"
    system "cd ./build && make"
    system "cd ./build && make install DESTDIR=#{buildpath}/stage"
    libdir = `pg_config --pkglibdir`
    sharedir = `pg_config --sharedir`
    `touch timescaledb_move.sh`
    `chmod +x timescaledb_move.sh`
    `echo "#!/bin/bash" >> timescaledb_move.sh`
    `echo "echo 'Moving files into place...'" >> timescaledb_move.sh`
    `echo "/usr/bin/install -c -m 755 \\\$(find #{lib} -name timescaledb.so) #{libdir.strip}/timescaledb.so" >> timescaledb_move.sh`
    `echo "/usr/bin/install -c -m 644 #{share}/timescaledb/* #{sharedir.strip}/extension/" >> timescaledb_move.sh`
    `echo "echo 'Success.'" >> timescaledb_move.sh`
    bin.install "timescaledb_move.sh"
    (lib/"timescaledb").install Dir["stage/**/lib/*"]
    (share/"timescaledb").install Dir["stage/**/share/postgresql*/extension/*"]
    end

  test do
    system "test", "-e", "#{lib}/timescaledb/timescaledb.so"
  end

  def caveats
    pgvar = `find /usr/local/var/postgres* -name "postgresql.conf" | head -n 1`
    s = "Make sure to update #{pgvar.strip} to include the extension:\n\n"
    s += "  shared_preload_libraries = 'timescaledb'\n\n"
    s += "To finish the installation, you will need to run:\n\n"
    s += "  $ timescaledb_move.sh\n\n"
    s += "This will install the extension files in the proper place. \n"
    s += "If installed via Homebrew:\n\n"
    s += "  $ brew services restart postgresql\n\n"
    s
  end
end
