class Ox < Formula
  desc "Run AI coding agents in isolated sandboxes"
  homepage "https://ox.build"
  version "0.20.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/timescale/ox/releases/download/v#{version}/ox-darwin-arm64"
      sha256 "8f812de740a3c72bcebc803ebf922a37e27063a1eed5d2b59309d7dac71c108a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/timescale/ox/releases/download/v#{version}/ox-linux-arm64"
      sha256 "631369c205592c6352e83e165a79fe75010d0c4e4a312960606282e5b4bc4d7d"
    end
    on_intel do
      url "https://github.com/timescale/ox/releases/download/v#{version}/ox-linux-x64"
      sha256 "d7ebb7c7e73b5c1037720d28e50fab75dee2e8b8a762ea3d234f4ca53863cff1"
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
