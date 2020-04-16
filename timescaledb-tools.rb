class TimescaledbTools < Formula
  desc "Client tools for working with TimescaleDB"
  homepage "https://www.timescaledb.com"
  url "https://timescalereleases.blob.core.windows.net/homebrew/timescaledb-tools-0.8.1.tar.lzma"
  version "0.8.1"
  sha256 "d9dd80f8d2465134ed5d508faa0efdf60593bdf339d8582bb3109fad19acd174"

  def install
    bin.install "timescaledb-tune"
    bin.install "timescaledb-parallel-copy"
    end

  test do
    system "timescaledb-tune", "--version"
    system "timescaledb-parallel-copy", "--version"
  end
end
