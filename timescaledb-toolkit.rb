class TimescaledbToolkit < Formula
  desc "Extension for more hyperfunctions, fully compatible with TimescaleDB and PostgreSQL"
  homepage "https://www.timescale.com"
  url "https://github.com/timescale/timescaledb-toolkit/archive/refs/tags/1.19.0.tar.gz"
  sha256 "b7d58e1b1ed7c5b66409991133e4e361f723cf446cbea7dd9f894ec11ddd6652"
  head "https://github.com/timescale/timescaledb-toolkit.git", branch: "main"

  depends_on "rust" => :build
  depends_on "rustfmt" => :build
  depends_on "postgresql@17"

  def postgresql
    Formula["postgresql@17"]
  end

  resource "cargo-pgrx" do
    url "https://github.com/pgcentralfoundation/pgrx/archive/refs/tags/v0.12.8.tar.gz"
    sha256 "bfdbeb96c777a15daa9cba0308d75ef49e23a8b30f4d3040ddde528d6ef337f8"
  end

  def install
    ENV["PG_CONFIG"] = postgresql.opt_bin/"pg_config"
    ENV["PGRX_HOME"] = buildpath

    resource("cargo-pgrx").stage "pgrx"
    system "cargo", "install", "--locked", "--path", "pgrx/cargo-pgrx"
    system "cargo", "pgrx", "init", "--pg17", "pg_config"

    cd "extension" do
      system "cargo", "pgrx", "package"
    end

    system "cargo", "run", "--bin", "post-install", "--", "--dir", "target/release/timescaledb_toolkit-pg17"

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
