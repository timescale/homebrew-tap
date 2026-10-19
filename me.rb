class Me < Formula
  desc "Permanent memory for AI agents"
  homepage "https://memory.build"
  version "0.9.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-darwin-arm64"
      sha256 "3ba12fa997e96f1c32f1ab6be05668e2d783c4cbec6ed54ca26d40b9f5f56779"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-linux-arm64"
      sha256 "cfd965479cce6a7bcc458df70276a3f63aabeaffbd7c8f4c5cd0272b200f7449"
    end
    on_intel do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-linux-x64"
      sha256 "5c0d20cdd1a3964ef2439f7242d0c35456ce8ce71210ac189c3399b1aa940198"
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
