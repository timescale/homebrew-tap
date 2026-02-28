class TimescaledbToolkit < Formula
  desc "Extension for more hyperfunctions, fully compatible with TimescaleDB and PostgreSQL"
  homepage "https://www.timescale.com"
  url "https://github.com/timescale/timescaledb-toolkit/archive/refs/tags/1.22.0.tar.gz"
  sha256 "b07a9fa180715e019dc19b21212238ad68bfdb38dced5fbfe55098ddee92821d"
  head "https://github.com/timescale/timescaledb-toolkit.git", branch: "main"

  depends_on "rust" => :build
  depends_on "rustfmt" => :build
  depends_on "postgresql@18"

  def postgresql
    Formula["postgresql@18"]
  end

  resource "cargo-pgrx" do
    url "https://github.com/pgcentralfoundation/pgrx/archive/refs/tags/v0.16.1.tar.gz"
    sha256 "8638d911003b93e8a73ad86e3cfa807165d2d3e69fce45dff98b19838ca66d13"
  end

  def install
    ENV["PG_CONFIG"] = postgresql.opt_bin/"pg_config"
    ENV["PGRX_HOME"] = buildpath

    resource("cargo-pgrx").stage "pgrx"
    system "cargo", "install", "--locked", "--path", "pgrx/cargo-pgrx"
    system "cargo", "pgrx", "init", "--pg18", "pg_config"

    cd "extension" do
      system "cargo", "pgrx", "package"
    end

    dylib = Dir.glob("target/release/timescaledb_toolkit-pg18/**/timescaledb_toolkit*.dylib").first
    if dylib
      File.rename(dylib, dylib.sub(/\.dylib$/, '.so'))
    end

    system "cargo", "run", "--bin", "post-install", "--", "--dir", "target/release/timescaledb_toolkit-pg18"

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
