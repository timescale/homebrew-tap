class Me < Formula
  desc "Permanent memory for AI agents"
  homepage "https://memory.build"
  version "0.6.1"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-darwin-arm64"
      sha256 "8f2d1cde02bae73adfb9d65495a537dd254cb21f25881cee3801863e701a30a9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-linux-arm64"
      sha256 "f6b84c7221db49dcda2df32bbe6aa4d1026ba0de02e5ba1ecbc0bc0722d770df"
    end
    on_intel do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-linux-x64"
      sha256 "b84f613fbc0262dd870b2830e393c652bcef87b1c10f9aec551d4444cdb275bd"
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
