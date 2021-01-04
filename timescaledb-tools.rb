class TimescaledbTools < Formula
  desc "Client tools for working with TimescaleDB"
  homepage "https://www.timescaledb.com"
  url "https://timescalereleases.blob.core.windows.net/homebrew/timescaledb-tools-0.10.0.tar.lzma"
  version "0.10.0"
  sha256 "114e41c19a3d0abd53dacbafc403148d5266aaa39cddd3fa2946b9d7c4991c35"

  def install
    bin.install "timescaledb-tune"
    bin.install "timescaledb-parallel-copy"
    end

  test do
    system "timescaledb-tune", "--version"
    system "timescaledb-parallel-copy", "--version"
  end
end
