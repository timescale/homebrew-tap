class TimescaledbTools < Formula
  desc "Client tools for working with TimescaleDB"
  homepage "https://www.timescaledb.com"
  url "https://github.com/timescale/timescaledb-tune/releases/download/v0.17.0/timescaledb-tools-0.17.0-darwin.tgz"
  version "0.17.0"
  sha256 "2f1de7ac7e0ee9740c966d23ae92f50522ed265f8453b340e20d57463dbf0e44"

  def install
    bin.install "timescaledb-tune"
    bin.install "timescaledb-parallel-copy"
  end

  test do
    system "timescaledb-tune", "--version"
    system "timescaledb-parallel-copy", "--version"
  end
end
