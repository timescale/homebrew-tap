class TimescaledbTools < Formula
  desc "Client tools for working with TimescaleDB"
  homepage "https://www.timescaledb.com"
  url "https://github.com/timescale/timescaledb-tune/releases/download/v0.13.0/timescaledb-tools-0.13.0-darwin.tgz"
  version "0.13.0"
  sha256 "9598224d88c03156e7a5c3004617e1715862c5ec42adb4cb3852786acd5e436d"

  def install
    bin.install "timescaledb-tune"
    bin.install "timescaledb-parallel-copy"
    end

  test do
    system "timescaledb-tune", "--version"
    system "timescaledb-parallel-copy", "--version"
  end
end
