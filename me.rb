class Me < Formula
  desc "Permanent memory for AI agents"
  homepage "https://memory.build"
  version "0.9.1"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-darwin-arm64"
      sha256 "73d52bd46c180c5d62933a8ebe3fad6cdbb61fac7d689b27b90fba369b165c5c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-linux-arm64"
      sha256 "13bdc4672f880937fbe9f6e4e3cebd7133816d69bdd861bcf705822acc1f0416"
    end
    on_intel do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-linux-x64"
      sha256 "387e0633e675b783817a5ef05347d00c6085716acf5b0de34f90bca35496ac87"
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
