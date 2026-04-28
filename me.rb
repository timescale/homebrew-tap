class Me < Formula
  desc "Permanent memory for AI agents"
  homepage "https://memory.build"
  version "0.2.4"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-darwin-arm64"
      sha256 "d87f8b150c66a01408e41950ceb84d73fe3100bb59ffdfc7c9f5caa47b4264ea"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-linux-arm64"
      sha256 "496a4e5ec67f47ce963e4c28d406ef766b617608cb85d093382d1e086a832a79"
    end
    on_intel do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-linux-x64"
      sha256 "17a00abcb4573d8749c4e109d84182dd51d0839c2744efb69b3cd25b2f94a06d"
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
