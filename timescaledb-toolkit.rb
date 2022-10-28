class TimescaledbToolkit < Formula
  desc "Extension for more hyperfunctions, fully compatible with TimescaleDB and PostgreSQL"
  homepage "https://www.timescale.com"
  url "https://github.com/timescale/timescaledb-toolkit/archive/refs/tags/1.11.0.tar.gz"
  sha256 "965766c9360a6a1f3be9960e9233ccfaa3f1b555d0a2e1928dc5914b348e2416"
  head "https://github.com/timescale/timescaledb-toolkit.git", branch: "main"

  bottle do
    root_url "https://github.com/timescale/timescaledb-toolkit/releases/download/1.11.0"
    sha256 cellar: :any, arm64_monterey: "b6a587176b3c6e353fc3c852813b3c09da2153b644f42422f4ce5648266b25c7"
  end

  depends_on "rust" => :build
  depends_on "rustfmt" => :build
  depends_on "postgresql@14"

  def postgresql
    Formula["postgresql@14"]
  end

  resource "cargo-pgx" do
    url "https://github.com/tcdi/pgx/archive/refs/tags/v0.4.5.tar.gz"
    sha256 "dad315b56495c7a35efa941a71494b71a6d9eb3549900534ed5fc0ba88dcb0fe"
  end

  def install
    ENV["PG_CONFIG"] = postgresql.opt_bin/"pg_config"
    ENV["PGX_HOME"] = buildpath

    resource("cargo-pgx").stage "pgx"
    system "cargo", "install", "--locked", "--path", "pgx/cargo-pgx"
    system "cargo", "pgx", "init", "--pg14", "pg_config"

    cd "extension" do
      system "cargo", "pgx", "package"
    end

    (lib/postgresql.name).install Dir["target/release/**/lib/**/timescaledb_toolkit.so"]
    (share/postgresql.name/"extension").install Dir["target/release/**/share/**/timescaledb_toolkit--*.sql"]
    (share/postgresql.name/"extension").install Dir["target/release/**/share/**/timescaledb_toolkit.control"]
  end

  test do
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    psql = postgresql.opt_bin/"psql"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"

      shared_preload_libraries = 'timescaledb_toolkit'
      port = #{port}
    EOS
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"
    begin
      system psql, "-p", port.to_s, "-c", "CREATE EXTENSION \"timescaledb_toolkit\";", "postgres"
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end
