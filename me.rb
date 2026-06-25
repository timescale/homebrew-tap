class Me < Formula
  desc "Permanent memory for AI agents"
  homepage "https://memory.build"
  version "0.3.3"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-darwin-arm64"
      sha256 "0c5157ab6b64bf87170804f768de618f335b1c4abdc02abc42e767077aa2158c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-linux-arm64"
      sha256 "7a815813d6605084e63f28aa2de9d00473c03101bc01be2bd00fc0f62acdd13f"
    end
    on_intel do
      url "https://github.com/timescale/memory-engine/releases/download/v#{version}/me-linux-x64"
      sha256 "e814eb19d76dff21f8a23810d8f753a95f02de995dc6d374705497502516412a"
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
