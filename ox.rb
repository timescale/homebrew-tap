class Ox < Formula
  desc "Run AI coding agents in isolated sandboxes"
  homepage "https://ox.build"
  version "0.16.5"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/timescale/ox/releases/download/v#{version}/ox-darwin-arm64"
      sha256 "713843b0843038b86b3ba1a15b6cae5c266a65b949cc87dfc6341d8538de09b5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/timescale/ox/releases/download/v#{version}/ox-linux-arm64"
      sha256 "2478c8fc638c7e62f713ee73f889decb6cd457e0b5edaafcd4f17c13013eeacf"
    end
    on_intel do
      url "https://github.com/timescale/ox/releases/download/v#{version}/ox-linux-x64"
      sha256 "88d19df1fd250d3c2da6b55835e2d9669c2c0fb3f416026b1f6b4807e60f7257"
    end
  end

  def install
    binary = Dir.glob("ox-*").first
    # Downloaded raw binaries don't have the execute bit set.
    chmod 0755, binary
    if OS.mac?
      system "/usr/bin/xattr", "-cr", binary
    end
    bin.install binary => "ox"

    generate_completions_from_executable(bin/"ox", "complete")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ox --version")
  end
end
