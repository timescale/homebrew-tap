class Me < Formula
  desc "Permanent memory for AI agents"
  homepage "https://memory.build"
  version "0.2.1"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-darwin-arm64"
      sha256 "9d8d77a8b65225f6b7a6913ed3947d1332df52abe5ea831ad2b7e22c5ae217ab"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-linux-arm64"
      sha256 "b579f785bdd8d2983eb6e9e1c42704594842ae8a52781f035defd2fddb601cb9"
    end
    on_intel do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-linux-x64"
      sha256 "2c09dc2a0cb1376b9a35bde71cf3e5bc28b65b0e707b8c8db12a42af2fe94142"
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
