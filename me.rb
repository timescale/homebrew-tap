class Me < Formula
  desc "Permanent memory for AI agents"
  homepage "https://memory.build"
  version "0.3.2"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-darwin-arm64"
      sha256 "889c22e4ea90524d66793bb23c4b6f8a33f3e703d50d397ad9c8b1bad876f1f9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-linux-arm64"
      sha256 "abe7e93bb3eb30679d71d6bdbd040702aa7568f03f9c2a7cf03ad8919f45092a"
    end
    on_intel do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-linux-x64"
      sha256 "9db477e111490a9a94372a488ea511426a950b420da4bc95baaf3c216a68f3f0"
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
