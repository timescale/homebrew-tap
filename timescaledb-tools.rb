class TimescaledbTools < Formula
  desc "Client tools for working with TimescaleDB"
  homepage "https://www.timescaledb.com"
  url "https://timescalereleases.blob.core.windows.net/homebrew/timescaledb-tools-0.4.1.tar.gz"
  version "0.4.1"
  sha256 "2d166d1e9750df5b91ef06d3c14c1cc1693db16fd3b805a88432254d9e3ad44a"

  def install
    bin.install "timescaledb-tune"
    bin.install "timescaledb-parallel-copy"
    end

  test do
    system "timescaledb-tune", "--version"
    system "timescaledb-parallel-copy", "--version"
  end
end
