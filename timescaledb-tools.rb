class TimescaledbTools < Formula
  desc "Client tools for working with TimescaleDB"
  homepage "https://www.timescaledb.com"
  url "https://timescalereleases.blob.core.windows.net/homebrew/timescaledb-tools-0.11.0.tar.lzma"
  version "0.11.0"
  sha256 "3a29f2063f85d7788a585370ac059e19b47f09af0486d0b5c7cb2d91e2c67f2b"

  def install
    bin.install "timescaledb-tune"
    bin.install "timescaledb-parallel-copy"
    bin.install "ts-dump"
    bin.install "ts-restore"
    end

  test do
    system "timescaledb-tune", "--version"
    system "timescaledb-parallel-copy", "--version"
    system "ts-dump", "--help"
    system "ts-restore", "--help"
  end
end
