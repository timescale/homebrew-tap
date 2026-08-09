class Me < Formula
  desc "Permanent memory for AI agents"
  homepage "https://memory.build"
  version "0.7.2"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-darwin-arm64"
      sha256 "3cf23fed17307df8711f741dc2d069c3faba5a3b2f0b83ed0a72e16a000a4e59"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-linux-arm64"
      sha256 "47ceac62effc8abfe2eb51af3cd3e7b0b2089de9a6778d3206282cfedf349e24"
    end
    on_intel do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-linux-x64"
      sha256 "9c84b16d5d3d29ccf9f73083b72cc80ac0e7f59b74b3d02a850998355321cf14"
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
