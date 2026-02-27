class Ox < Formula
  desc "Run AI coding agents in isolated sandboxes"
  homepage "https://ox.build"
  version "0.13.1"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/timescale/ox/releases/download/v#{version}/ox-darwin-arm64"
      sha256 "03f0464d27383d8b8ed5d7333c81b66f97cbeb1d264572e08aab99c8bc7138fe"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/timescale/ox/releases/download/v#{version}/ox-linux-arm64"
      sha256 "b0e0130cebb2a4d9ab67d5f0b890a557a308e7bdf867cb77e09405dbd0ac851c"
    end
    on_intel do
      url "https://github.com/timescale/ox/releases/download/v#{version}/ox-linux-x64"
      sha256 "269be0f611a864694e097cba81c28f2979628576a45341f30c56629303b4b36c"
    end
  end

  def install
    binary = Dir.glob("ox-*").first
    if OS.mac?
      system "/usr/bin/xattr", "-cr", binary
    end
    bin.install binary => "ox"

    # Debug: check the binary
    ohai "Installed binary: #{bin}/ox"
    ohai "File exists: #{File.exist?(bin/"ox")}"
    ohai "File executable: #{File.executable?(bin/"ox")}"
    ohai "File stat: #{File.stat(bin/"ox").mode.to_s(8)}"
    ohai "PATH: #{ENV["PATH"]}"

    # Try direct Ruby exec test
    result = `"#{bin}/ox" --version 2>&1`
    ohai "Direct backtick result: #{result.strip}, exit: #{$?.exitstatus}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ox --version")
  end
end
