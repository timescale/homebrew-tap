class Me < Formula
  desc "Permanent memory for AI agents"
  homepage "https://memory.build"
  version "0.2.2"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-darwin-arm64"
      sha256 "ac0e0d47da46c22d28049040a802560320e0e9e65bdfb0629802473cd5cb0a37"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-linux-arm64"
      sha256 "f21d893f8ffdea45617d1aa4858ade5ca7e8cdf55151a5364d0d75e46823f3bf"
    end
    on_intel do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-linux-x64"
      sha256 "0dd2f7536c85f1ef46763d9a6ab3f5edf285a02024a4a6ecf372ac400efddc6a"
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
