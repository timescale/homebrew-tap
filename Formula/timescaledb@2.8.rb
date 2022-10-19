class TimescaledbAT28 < Formula
  desc "An open-source time-series database optimized for fast ingest and complex queries. Fully compatible with PostgreSQL."
  homepage "https://www.timescaledb.com"
  url "https://github.com/timescale/timescaledb/archive/refs/tags/2.8.1.tar.gz"
  sha256 "22a057c4472d23bf08778932e391f38f350ef0307cf99fb8e279c8245667d3e9"
  version "2.8.1"
  env :std

  depends_on "cmake" => :build
  depends_on "postgresql@14" => :build
  depends_on "openssl" => :build
  depends_on "xz" => :build
  depends_on "timescaledb-tools" => :recommended

  option "with-oss-only", "Build TimescaleDB with only Apache-2 licensed code"

  def postgresql
    Formula["postgresql@14"]
  end

  def install
    ossvar = build.with?("oss-only") ? " -DAPACHE_ONLY=1" : ""
    ssldir = Formula["openssl"].opt_prefix

    system "./bootstrap -DCMAKE_BUILD_TYPE=RelWithDebInfo -DREGRESS_CHECKS=OFF -DTAP_CHECKS=OFF -DWARNINGS_AS_ERRORS=OFF -DLINTER=OFF -DPROJECT_INSTALL_METHOD=\"brew\"#{ossvar} -DOPENSSL_ROOT_DIR=\"#{ssldir}\""
    system "make -C build"
    system "make -C build install DESTDIR=#{buildpath}/stage"

    (lib/postgresql.name).install Dir["stage/**/lib/**/timescaledb*.so"]
    (share/postgresql.name/"extension").install Dir["stage/**/share/**/extension/timescaledb--*.sql"]
    (share/postgresql.name/"extension").install Dir["stage/**/share/**/extension/timescaledb.control"]
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

  def caveats
    <<~EOS
      RECOMMENDED: Run 'timescaledb-tune' to update your config settings for TimescaleDB.
        timescaledb-tune --quiet --yes

      IF NOT, you'll need to update "postgresql.conf" to include the extension:
        shared_preload_libraries = 'timescaledb'

      If PostgreSQL is installed via Homebrew, restart it:
        brew services restart #{postgresql.name}
    EOS
  end
end
