class Timescaledb < Formula
  desc "An open-source time-series database optimized for fast ingest and complex queries. Fully compatible with PostgreSQL."
  homepage "https://www.timescaledb.com"
  url "https://github.com/timescale/timescaledb/archive/refs/tags/2.6.0.tar.gz"
  sha256 "058991ae9c312ed3e08356262103cfbe9d6380a94bb8a207710c31c38f2a2d5f"
  version "2.6.0"
  env :std

  depends_on "cmake" => :build
  depends_on "postgresql" => :build
  depends_on "openssl" => :build
  depends_on "xz" => :build
  depends_on "timescaledb-tools" => :recommended

  option "with-oss-only", "Build TimescaleDB with only Apache-2 licensed code"

  def install
    ossvar = ""
    if build.with?("oss-only")
      ossvar = " -DAPACHE_ONLY=1"
    end
    ssldir = `brew --prefix openssl`.chomp()
    system "./bootstrap -DCMAKE_BUILD_TYPE=RelWithDebInfo -DREGRESS_CHECKS=OFF -DTAP_CHECKS=OFF -DWARNINGS_AS_ERRORS=OFF -DLINTER=OFF -DPROJECT_INSTALL_METHOD=\"brew\"#{ossvar} -DOPENSSL_ROOT_DIR=\"#{ssldir}\""
    system "make -C build"
    system "make -C build install DESTDIR=#{buildpath}/stage"
    libdir = `pg_config --pkglibdir`
    sharedir = `pg_config --sharedir`
    `touch timescaledb_move.sh`
    `chmod +x timescaledb_move.sh`
    `echo "#!/bin/bash" >> timescaledb_move.sh`
    `echo "echo 'Moving files into place...'" >> timescaledb_move.sh`
    `echo "/usr/bin/install -c -m 755 \\\$(find #{lib} -name timescaledb*.so) #{libdir.strip}/" >> timescaledb_move.sh`
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
    pgvar = `find #{HOMEBREW_PREFIX}/var/postgres* -name "postgresql.conf" | head -n 1`
    s = "RECOMMENDED: Run 'timescaledb-tune' to update your config settings for TimescaleDB.\n\n"
    s += "  timescaledb-tune --quiet --yes\n\n"

    s += "IF NOT, you'll need to make sure to update #{pgvar.strip}\nto include the extension:\n\n"
    s += "  shared_preload_libraries = 'timescaledb'\n\n"

    s += "To finish the installation, you will need to run:\n\n"
    s += "  timescaledb_move.sh\n\n"

    s += "If PostgreSQL is installed via Homebrew, restart it:\n\n"
    s += "  brew services restart postgresql\n\n"
    s
  end
end
