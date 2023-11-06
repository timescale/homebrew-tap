class TimescaledbTools < Formula
  desc "Client tools for working with TimescaleDB"
  homepage "https://www.timescaledb.com"
  url "https://github.com/timescale/timescaledb-tune/releases/download/v0.15.0/timescaledb-tools-0.15.0-darwin.tgz"
  version "0.15.0"
  sha256 "7b5c99015946605ee2a394eb01850fa3eeb00055bd1b607a2fa71a5987f1edc8"

  def install
    bin.install "timescaledb-tune"
    bin.install "timescaledb-parallel-copy"
  end

  test do
    system "timescaledb-tune", "--version"
    system "timescaledb-parallel-copy", "--version"
  end
end
