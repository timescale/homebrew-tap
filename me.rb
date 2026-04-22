class Me < Formula
  desc "Permanent memory for AI agents"
  homepage "https://memory.build"
  version "0.1.17"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-darwin-arm64"
      sha256 "3eccf55a32a011d2df4f41a922dc8c9a3b69152a70c5f63d462cf2c3cb2e4abc"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-linux-arm64"
      sha256 "ae5a6e72e318e7a54f130be9fef747903682c234452af2dad9bcc3f18106f46a"
    end
    on_intel do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-linux-x64"
      sha256 "1709254dcd8d8d14aee504a72eccd0e2a06adf54636948c8dfaaca588bb3bfaa"
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
