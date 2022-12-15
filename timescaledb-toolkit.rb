class TimescaledbToolkit < Formula
  desc "Extension for more hyperfunctions, fully compatible with TimescaleDB and PostgreSQL"
  homepage "https://www.timescale.com"
  url "https://github.com/timescale/timescaledb-toolkit/archive/refs/tags/1.13.0.tar.gz"
  sha256 "409ca12db5a1b67ecd92e9c385fadb20a8476703373897efa8398f785d1c9e20"
  head "https://github.com/timescale/timescaledb-toolkit.git", branch: "main"

  bottle do
    root_url "https://github.com/timescale/timescaledb-toolkit/releases/download/1.13.0"
    sha256 cellar: :any, arm64_ventura: "5f3f7d9e6035d4826209ba6258cbe2a8a52b63b66d0fd75a2b4feb8d0a4b60e4"
    sha256 cellar: :any, arm64_monterey: "7d318b620957c27002b46c6b442c49febec738427dfd5be7cca738fb964d4a23"
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
