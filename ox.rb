class Ox < Formula
  desc "Run AI coding agents in isolated sandboxes"
  homepage "https://ox.build"
  version "0.20.1"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/timescale/ox/releases/download/v#{version}/ox-darwin-arm64"
      sha256 "11dcf863520a396c7599d1a96f2ebfc636f2fdf1e0ccad3f4ce4d27d19e96fef"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/timescale/ox/releases/download/v#{version}/ox-linux-arm64"
      sha256 "bb1434b34f52f75e63cb1333f45f2948f9d33098af92e3306220f36b4703b189"
    end
    on_intel do
      url "https://github.com/timescale/ox/releases/download/v#{version}/ox-linux-x64"
      sha256 "65130ad45403c8d9f97590355593656a5259603a07cff876ed2001d4fcc68eb5"
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
