class Me < Formula
  desc "Permanent memory for AI agents"
  homepage "https://memory.build"
  version "0.8.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-darwin-arm64"
      sha256 "82be60be77fde9638431278d4cd9e189ad2798f40a2d75b599945424a116a1a0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-linux-arm64"
      sha256 "2f323eb23fb141481bc039028e5ca67f7cf2ef633349403af3dcbbe826ce036a"
    end
    on_intel do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-linux-x64"
      sha256 "48680be0a6a9914585fdf143f97d309389f23f2f6e1283596d83afdfa06ca8d2"
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
