class TimescaledbTools < Formula
  desc "Client tools for working with TimescaleDB"
  homepage "https://www.timescaledb.com"
  url "https://github.com/timescale/timescaledb-tune/releases/download/v0.12.0/timescaledb-tools-0.12.0-darwin.tgz"
  version "0.12.0"
  sha256 "a6ae6f618ba67410d6935bea4b3519b1b8564cc5aa8307b0115f0e2b95dc9876"

  def install
    bin.install "timescaledb-tune"
    bin.install "timescaledb-parallel-copy"
    bin.install "ts-dump"
    bin.install "ts-restore"
    end

  test do
    system "timescaledb-tune", "--version"
    system "timescaledb-parallel-copy", "--version"
    system "ts-dump", "--help"
    system "ts-restore", "--help"
  end
end
