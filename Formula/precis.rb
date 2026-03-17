class Precis < Formula
  desc "A CLI tool that extracts a token-efficient summary of a codebase"
  homepage "https://github.com/Crazytieguy/precis"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Crazytieguy/precis/releases/download/v0.1.3/precis-aarch64-apple-darwin.tar.xz"
      sha256 "d22f274da5ef4b2ed638916ff792bbbb6ab05cb1d247a22d72695eb01f843641"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Crazytieguy/precis/releases/download/v0.1.3/precis-x86_64-apple-darwin.tar.xz"
      sha256 "b120fca46a5c5056369018a0cb5cd7bb045b2e060205c6050cb38a1c2fc0b51d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Crazytieguy/precis/releases/download/v0.1.3/precis-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "65509036d90aa19efff37ff89bd8a4bad749a40714308d484d0c7e541ab88c84"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Crazytieguy/precis/releases/download/v0.1.3/precis-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "025165de9cb28112e9fecafe39822f614d9f131b592287baebb9d69ecee6f96a"
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
    bin.install "precis" if OS.mac? && Hardware::CPU.arm?
    bin.install "precis" if OS.mac? && Hardware::CPU.intel?
    bin.install "precis" if OS.linux? && Hardware::CPU.arm?
    bin.install "precis" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
