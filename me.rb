class Me < Formula
  desc "Permanent memory for AI agents"
  homepage "https://memory.build"
  version "0.1.15"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-darwin-arm64"
      sha256 "4ff8bdc0b4207fdbc4ead64f8df7fcba6de9f2df154fae689745708ffb710789"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-linux-arm64"
      sha256 "299fecc3a5ac21b2c4b0bc62fbc8958feef787430521104d2393b22ed15a28c7"
    end
    on_intel do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-linux-x64"
      sha256 "ba5ba9a798259b868f281cbe297278b57c5a19ed2569c37309615e232b3562f6"
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
