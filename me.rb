class Me < Formula
  desc "Permanent memory for AI agents"
  homepage "https://memory.build"
  version "0.2.6"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-darwin-arm64"
      sha256 "7ea4fc1099f4cc2105d535a4130ab4dce17722a74124fc194fc0c74cfa53f56c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-linux-arm64"
      sha256 "27f850f2f98cce7bf98c3e0a90d9b7dc4c6ff76ccdf0ec19cd2cbef34acc65a3"
    end
    on_intel do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-linux-x64"
      sha256 "d5f1dd22c2d153457240087849f82da22129fcbb80db81fe3dfdb3194096ab78"
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
