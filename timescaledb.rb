class Timescaledb < Formula
  desc "An open-source time-series database optimized for fast ingest and complex queries. Fully compatible with PostgreSQL."
  homepage "https://www.timescaledb.com"
  url "https://github.com/timescale/timescaledb/archive/refs/tags/2.13.0.tar.gz"
  sha256 "584a351c7775f0e067eaa0e7277ea88cab9077cc4c455cbbf09a5d9723dce95d"
  version "2.13.0"
  env :std

  option "with-oss-only", "Build TimescaleDB with only Apache-2 licensed code"

  depends_on "cmake" => :build
  depends_on "openssl" => :build
  depends_on "postgresql@16" => :build
  depends_on "xz" => :build
  depends_on "timescale/tap/timescaledb-tools" => :recommended

  def postgresql
    Formula["postgresql@16"]
  end

  def install
    ossvar = build.with?("oss-only") ? " -DAPACHE_ONLY=1" : ""
    ssldir = Formula["openssl"].opt_prefix

    system "./bootstrap -DCMAKE_BUILD_TYPE=RelWithDebInfo -DREGRESS_CHECKS=OFF -DTAP_CHECKS=OFF -DWARNINGS_AS_ERRORS=OFF -DLINTER=OFF -DPROJECT_INSTALL_METHOD=\"brew\"#{ossvar} -DOPENSSL_ROOT_DIR=\"#{ssldir}\""
    system "make", "-C", "build"
    system "make", "-C", "build", "install", "DESTDIR=#{buildpath}/stage"
    libdir = `pg_config --pkglibdir`
    sharedir = `pg_config --sharedir`
    `touch timescaledb_move.sh`
    `chmod +x timescaledb_move.sh`
    `echo "#!/bin/bash" >> timescaledb_move.sh`
    `echo "echo 'Moving files into place...'" >> timescaledb_move.sh`
    `echo "/usr/bin/install -c -m 755 \\\$(find #{lib} -name timescaledb*.dylib) #{libdir.strip}/" >> timescaledb_move.sh`
    `echo "/usr/bin/install -c -m 644 #{share}/timescaledb/* #{sharedir.strip}/extension/" >> timescaledb_move.sh`
    `echo "echo 'Success.'" >> timescaledb_move.sh`
    bin.install "timescaledb_move.sh"
    (lib/"timescaledb").install Dir["stage/**/lib/*"]
    (share/"timescaledb").install Dir["stage/**/share/postgresql*/extension/*"]
  end

  def caveats
    <<~EOS
      RECOMMENDED: Run 'timescaledb-tune' to update your config settings for TimescaleDB.
        timescaledb-tune --quiet --yes

      IF NOT, you'll need to update "postgresql.conf" to include the extension:
        shared_preload_libraries = 'timescaledb'

      To finish the installation, you will need to run:
        timescaledb_move.sh

      If PostgreSQL is installed via Homebrew, restart it:
        brew services restart #{postgresql.name}
    EOS
  end

  test do
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    psql = postgresql.opt_bin/"psql"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"

      shared_preload_libraries = 'timescaledb'
      port = #{port}
    EOS
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"
    begin
      system psql, "-p", port.to_s, "-c", "CREATE EXTENSION \"timescaledb\";", "postgres"
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end
