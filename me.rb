class Me < Formula
  desc "Permanent memory for AI agents"
  homepage "https://memory.build"
  version "0.5.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-darwin-arm64"
      sha256 "1767ca82a3fba895734d14809fdb5e9e5a251cf82c6d7728598ce1651bd12b32"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-linux-arm64"
      sha256 "b523f9ffa926fccdda2a0f37bca141e1f4ad80032e03d1932201e5a28c81dcd4"
    end
    on_intel do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-linux-x64"
      sha256 "579702694d3a2baf9c09fb6448fbb6a2037db809d1c97742029c58c1a0c1b075"
    end
  end

  def install
    binary = Dir.glob("me-*").first
    # Downloaded raw binaries don't have the execute bit set.
    chmod 0755, binary
    if OS.mac?
      system "/usr/bin/xattr", "-cr", binary
    end
    bin.install binary => "me"

    generate_completions_from_executable(bin/"me", "complete")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/me --version")
  end
end
