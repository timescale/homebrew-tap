class TimescaledbTools < Formula
  desc "Client tools for working with TimescaleDB"
  homepage "https://www.timescaledb.com"
  url "https://timescalereleases.blob.core.windows.net/homebrew/timescaledb-tools-0.10.1.tar.lzma"
  version "0.10.1"
  sha256 "84fcca9d067613be1f713ecadfad16d4d4f0745d9906ee1e93ea450a2dfd48cf"

  def install
    bin.install "timescaledb-tune"
    bin.install "timescaledb-parallel-copy"
    bin.install "ts-dump"
    bin.install "ts-restore"
    end

  test do
    system "timescaledb-tune", "--version"
    system "timescaledb-parallel-copy", "--version"
  end
end
