class Me < Formula
  desc "Permanent memory for AI agents"
  homepage "https://memory.build"
  version "0.7.3"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-darwin-arm64"
      sha256 "29b33a77354bb5c5cbe83ae7c81fd00155971444c0814b7329e6e35874e12194"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-linux-arm64"
      sha256 "74f90f960ab6a47d7671511a4c56aa600df9dc9747db9cc1959c07ebe571f426"
    end
    on_intel do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-linux-x64"
      sha256 "f20124d8d87348f2f2065673e406686412e9de665a53938eb82f16ed3a96d611"
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
