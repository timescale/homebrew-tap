class TimescaledbTools < Formula
  desc "Client tools for working with TimescaleDB"
  homepage "https://www.timescaledb.com"
  url "https://github.com/timescale/timescaledb-tune/releases/download/v0.19.0/timescaledb-tools-0.19.0-darwin.tgz"
  version "0.19.0"
  sha256 "8cfa4b5a08d03b03c1dcdb28bbdbb56363d126cb1b134aea009a25b72450b61a"

  def install
    bin.install "timescaledb-tune"
    bin.install "timescaledb-parallel-copy"
  end

  test do
    system "timescaledb-tune", "--version"
    system "timescaledb-parallel-copy", "--version"
  end
end
