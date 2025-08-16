class TimescaledbTools < Formula
  desc "Client tools for working with TimescaleDB"
  homepage "https://www.timescaledb.com"
  url "https://github.com/timescale/timescaledb-tune/releases/download/v0.18.1/timescaledb-tools-0.18.1-darwin.tgz"
  version "0.18.1"
  sha256 "9cdbb82eaf547957d127201346b400efd4bbd978d4f15268ac8b8a9c1e307dc1"

  def install
    bin.install "timescaledb-tune"
    bin.install "timescaledb-parallel-copy"
  end

  test do
    system "timescaledb-tune", "--version"
    system "timescaledb-parallel-copy", "--version"
  end
end
