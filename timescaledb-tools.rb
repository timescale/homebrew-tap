class TimescaledbTools < Formula
  desc "Client tools for working with TimescaleDB"
  homepage "https://www.timescaledb.com"
  url "https://timescalereleases.blob.core.windows.net/homebrew/timescaledb-tools-0.2.0.tar.gz"
  version "0.2.0"
  sha256 "5aa89289279b1d5f1a5c47d22d1aea8358a075cc2be3d89593465c0e083ce248"

  def install
    bin.install "timescaledb-tune"
    bin.install "timescaledb-parallel-copy"
    end

  test do
    system "timescaledb-tune", "--version"
    system "timescaledb-parallel-copy", "--version"
  end
end
