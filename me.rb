class Me < Formula
  desc "Permanent memory for AI agents"
  homepage "https://memory.build"
  version "0.6.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-darwin-arm64"
      sha256 "cdd98b234fd30e9d721b30d79dc937a943bec6ba9ab4596c29209c9b8aefb46e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-linux-arm64"
      sha256 "afa556902d19566619a375f07131e3b3b8e36284fde07c54bff2e66a689e5fea"
    end
    on_intel do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-linux-x64"
      sha256 "3e9fab132139dfa26e4fdb76a8e0ee4434b0cc6cde6694ab3ded2312e1bc903c"
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
