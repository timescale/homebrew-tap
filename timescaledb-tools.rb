class TimescaledbTools < Formula
  desc "Client tools for working with TimescaleDB"
  homepage "https://www.timescaledb.com"
  version "0.19.1"
  url "https://github.com/timescale/timescaledb-tune/releases/download/v#{version}/timescaledb-tools-#{version}-darwin.tgz"
  sha256 "31961c3213125b95e73d945bfac1cbbd9974e85480ab10675d582cd38d924f55"

  def install
    bin.install "timescaledb-tune"
    bin.install "timescaledb-parallel-copy"
  end

  test do
    system "timescaledb-tune", "--version"
    system "timescaledb-parallel-copy", "--version"
  end
end
