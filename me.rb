class Me < Formula
  desc "Permanent memory for AI agents"
  homepage "https://memory.build"
  version "0.3.4"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-darwin-arm64"
      sha256 "77f6985116ea3237f8b3a9a65c3c7c3e04e51ffb4853059ba48ca5d9aad7433f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-linux-arm64"
      sha256 "714eae7759c9840a7bba1bae16e921a3d15d69cccefa039b6ccba8ad9917286b"
    end
    on_intel do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-linux-x64"
      sha256 "fa320d63bb448580ccfc7b1d12400d06aeb931e733905f466bccdcb15408ff11"
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
