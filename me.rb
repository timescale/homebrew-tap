class Me < Formula
  desc "Permanent memory for AI agents"
  homepage "https://memory.build"
  version "0.4.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-darwin-arm64"
      sha256 "070833d834cae23a529bec3278b99b77082c18ec00b3acb37c8a4353f9bdb06d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-linux-arm64"
      sha256 "41dc13db7556aac4c54763149e3012806c413c1bac39b2dab5c4c0cf4fd404e1"
    end
    on_intel do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-linux-x64"
      sha256 "bc1ce31f784fe03a2da35bc14f3e87f27ceda60996ca1ddcf5fe27b9f7696823"
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
