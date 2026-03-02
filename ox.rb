class Ox < Formula
  desc "Run AI coding agents in isolated sandboxes"
  homepage "https://ox.build"
  version "0.14.2"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/timescale/ox/releases/download/v#{version}/ox-darwin-arm64"
      sha256 "c40a65a9348adc6ab429b12cb6bcda91b18f5e6fd2d587e43fde6cac883ca80e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/timescale/ox/releases/download/v#{version}/ox-linux-arm64"
      sha256 "aa346f2116c6258495e9536de2fe55431bd78b1a94a11e3ec6212696a7bb28a7"
    end
    on_intel do
      url "https://github.com/timescale/ox/releases/download/v#{version}/ox-linux-x64"
      sha256 "4a22c67423fcae7f8bb1af764f253d4432de3484c028165006854f517a3e382e"
    end
  end

  def install
    binary = Dir.glob("ox-*").first
    # Downloaded raw binaries don't have the execute bit set.
    chmod 0755, binary
    if OS.mac?
      system "/usr/bin/xattr", "-cr", binary
    end
    bin.install binary => "ox"

    generate_completions_from_executable(bin/"ox", "complete")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ox --version")
  end
end
