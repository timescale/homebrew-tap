class Me < Formula
  desc "Permanent memory for AI agents"
  homepage "https://memory.build"
  version "0.2.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-darwin-arm64"
      sha256 "5c6a68969cd32722dac773f85cbffdb5343fa7fee0ff6a717473aa8110356bbf"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-linux-arm64"
      sha256 "6f406efa5b07a6d747c5729a4afa9c634e123cc9d469c4488ece452a1d8b53d0"
    end
    on_intel do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-linux-x64"
      sha256 "86326286d8b844cc6e405a5ce4ca3d4942d66f6aa97c9e700d2277da4a7a096a"
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
