class Me < Formula
  desc "Permanent memory for AI agents"
  homepage "https://memory.build"
  version "0.1.16"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-darwin-arm64"
      sha256 "e03d1cfd2a796728620e90176083f51d2452a705270c80ef439d132ec23774e1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-linux-arm64"
      sha256 "72f7ba1831e0cbc26c2a551eca1fbdda7a978369b3df134c0beb8d568cea55fe"
    end
    on_intel do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-linux-x64"
      sha256 "975a573be86b53804bef6b67a14ef557d8fe4cced1cac865dceb798bf3aa4ef1"
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
