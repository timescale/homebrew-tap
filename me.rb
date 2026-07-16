class Me < Formula
  desc "Permanent memory for AI agents"
  homepage "https://memory.build"
  version "0.6.2"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-darwin-arm64"
      sha256 "92d5f8543ce1d074aada1c53557e39a5e828cf1b55fed7a976b2c5330ef00899"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-linux-arm64"
      sha256 "865220d3553a8b6e6a1bbbc6d87e3db416f3c1f31d6d18ab52ab150af1e82184"
    end
    on_intel do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-linux-x64"
      sha256 "1eee5b08429b422d5f05a67c5ab835ed8f972e03799840d6ec8fae4d999449d9"
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
