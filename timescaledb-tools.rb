class TimescaledbTools < Formula
  desc "Client tools for working with TimescaleDB"
  homepage "https://www.timescaledb.com"
  url "https://github.com/timescale/timescaledb-tune/releases/download/v0.14.1/timescaledb-tools-0.14.1-darwin.tgz"
  version "0.14.1"
  sha256 "300d760062408f767ef2b020658578fc9d5b405522d8d4d78ddf8623cae5469c"

  def install
    bin.install "timescaledb-tune"
    bin.install "timescaledb-parallel-copy"
  end

  test do
    system "timescaledb-tune", "--version"
    system "timescaledb-parallel-copy", "--version"
  end
end
