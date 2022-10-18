class TimescaledbTools < Formula
  desc "Client tools for working with TimescaleDB"
  homepage "https://www.timescaledb.com"
  url "https://github.com/timescale/timescaledb-tune/releases/download/v0.14.3/timescaledb-tools-0.14.3-darwin.tgz"
  version "0.14.3"
  sha256 "fb7bb618f8216c2b43f09a0eae0c92d1e4c658742a41a674c431cbfa4865fac9"

  def install
    bin.install "timescaledb-tune"
    bin.install "timescaledb-parallel-copy"
  end

  test do
    system "timescaledb-tune", "--version"
    system "timescaledb-parallel-copy", "--version"
  end
end
