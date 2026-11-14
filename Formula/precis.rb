class Precis < Formula
  desc "A CLI tool that extracts a token-efficient summary of a path"
  homepage "https://github.com/Crazytieguy/precis"
  version "0.2.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Crazytieguy/precis/releases/download/v0.2.3/precis-aarch64-apple-darwin.tar.xz"
      sha256 "69421a46185798ea80d13eec1f9fbf2644f5911ef80f184c6fdf3419e22f988a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Crazytieguy/precis/releases/download/v0.2.3/precis-x86_64-apple-darwin.tar.xz"
      sha256 "48726bc7ba2332538183a201c50d39791506fc9eb8d2ec230bb3a6e41d4c60a2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Crazytieguy/precis/releases/download/v0.2.3/precis-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "90a8586e25152945f3628224749c98ccfe7048ba1066c068af0c8e5f87d50559"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Crazytieguy/precis/releases/download/v0.2.3/precis-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f2da8a607f669e84fdf4d8572893e27d969565025df018731c28cbbe5254750a"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "precis"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "precis"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "precis"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "precis"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
