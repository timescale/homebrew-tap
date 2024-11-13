class TimescaledbTools < Formula
  desc "Client tools for working with TimescaleDB"
  homepage "https://www.timescaledb.com"
  url "https://github.com/timescale/timescaledb-tune/releases/download/v0.18.0/timescaledb-tools-0.18.0-darwin.tgz"
  version "0.18.0"
  sha256 "7eedad104e01a9e468c8d8ac2bace26138e98c702c813b3f9abd0ca7552d8d78"

  def install
    bin.install "timescaledb-tune"
    bin.install "timescaledb-parallel-copy"
  end

  test do
    system "timescaledb-tune", "--version"
    system "timescaledb-parallel-copy", "--version"
  end
end
