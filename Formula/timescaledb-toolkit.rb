class TimescaledbToolkit < Formula
  desc "Extension for more hyperfunctions, fully compatible with TimescaleDB and PostgreSQL"
  homepage "https://www.timescale.com"
  url "https://github.com/timescale/timescaledb-toolkit/archive/refs/tags/1.13.1.tar.gz"
  sha256 "34faa1cb1220fff3614374bf504904c503354ad452b1a62e4e82cd16d680c944"
  head "https://github.com/timescale/timescaledb-toolkit.git", branch: "main"

  bottle do
    root_url "https://github.com/timescale/timescaledb-toolkit/releases/download/1.13.1"
    sha256 cellar: :any, arm64_ventura: "4e50b39d9c85170fb2359618ee6827fe8361d05a1d3215e4e48888ac52c39c5c"
    sha256 cellar: :any, arm64_monterey: "7e68b3f2c73e60d4fb7d64ac0bee2cfba4dcdaa25b822e2cf93ef9d25d8bcae2"
  end

  depends_on "rust" => :build
  depends_on "rustfmt" => :build
  depends_on "postgresql@14"

  def postgresql
    Formula["postgresql@14"]
  end

  resource "cargo-pgx" do
    url "https://github.com/tcdi/pgx/archive/refs/tags/v0.6.1.tar.gz"
    sha256 "7af4d9a79ceaf938d58905acdceeaa018cacd98addfbe42d95de76da7d5f20ab"
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

    system "cargo", "run", "--bin", "post-install", "--", "--dir", "target/release/timescaledb_toolkit-pg14"

    (lib/postgresql.name).install Dir["target/release/**/lib/**/timescaledb_toolkit*.so"]
    (share/postgresql.name/"extension").install Dir["target/release/**/share/**/timescaledb_toolkit--*.sql"]
    (share/postgresql.name/"extension").install Dir["target/release/**/share/**/timescaledb_toolkit.control"]
  end

  test do
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    psql = postgresql.opt_bin/"psql"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"

      shared_preload_libraries = 'timescaledb_toolkit-#{version}'
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
