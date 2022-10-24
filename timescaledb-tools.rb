class TimescaledbTools < Formula
  desc "Client tools for working with TimescaleDB"
  homepage "https://www.timescaledb.com"
  url "https://github.com/timescale/timescaledb-tune/releases/download/v0.14.2/timescaledb-tools-0.14.2-darwin.tgz"
  version "0.14.2"
  sha256 "f8ad6ae64814c313e1510c91f611dc35fb375456676b3dbe2e8f8ae32597c79d"

  def install
    bin.install "timescaledb-tune"
    bin.install "timescaledb-parallel-copy"
  end

  test do
    system "timescaledb-tune", "--version"
    system "timescaledb-parallel-copy", "--version"
  end
end
