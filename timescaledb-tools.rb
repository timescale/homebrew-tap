class TimescaledbTools < Formula
  desc "Client tools for working with TimescaleDB"
  homepage "https://www.timescaledb.com"
  url "https://github.com/timescale/timescaledb-tune/releases/download/v0.14.3/timescaledb-tools-0.14.3-darwin.tgz"
  version "0.14.3"
  sha256 "e3f546f2c7bfce82ad008a7af3ad05940a46266e6fe2006fcb82a60c3eb1ed20"

  def install
    bin.install "timescaledb-tune"
    bin.install "timescaledb-parallel-copy"
  end

  test do
    system "timescaledb-tune", "--version"
    system "timescaledb-parallel-copy", "--version"
  end
end
