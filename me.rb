class Me < Formula
  desc "Permanent memory for AI agents"
  homepage "https://memory.build"
  version "0.3.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-darwin-arm64"
      sha256 "9554691e9ea4f86f5732a91af8e58a8d981c7c4a50e42df3dc348b97b24aa67a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-linux-arm64"
      sha256 "8ca5620e9e4f64148e73e5d5b00f675078fc58ab20bd7786be93f06ae236fb45"
    end
    on_intel do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-linux-x64"
      sha256 "05c2a72f4ce9e1b55c10598c7de4c8a39e9a53b7019e185b99cb564df38171a3"
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
