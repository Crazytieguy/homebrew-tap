class Coven < Formula
  desc "A minimal streaming display and workflow runner for Claude Code's -p mode"
  homepage "https://github.com/Crazytieguy/coven"
  version "0.1.13"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Crazytieguy/coven/releases/download/v0.1.13/coven-aarch64-apple-darwin.tar.xz"
      sha256 "ba3226e7016f881031ef9b2179fcab6244925ecafe31ca3f250e7320f3730dc5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Crazytieguy/coven/releases/download/v0.1.13/coven-x86_64-apple-darwin.tar.xz"
      sha256 "7a6e62aba3d26fe04add61620b2eb3fdcd967f8a1a95671ce4a101f386fe0720"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Crazytieguy/coven/releases/download/v0.1.13/coven-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1502fd4e49e4f76a6827119c5af7be6d35173870779c94984e6cfa5c54d14bd7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Crazytieguy/coven/releases/download/v0.1.13/coven-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ba642d7d6385108cf64ffde941422f2af65af8ed6b92430633a6771f0114fe2a"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
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
    bin.install "coven" if OS.mac? && Hardware::CPU.arm?
    bin.install "coven" if OS.mac? && Hardware::CPU.intel?
    bin.install "coven" if OS.linux? && Hardware::CPU.arm?
    bin.install "coven" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
