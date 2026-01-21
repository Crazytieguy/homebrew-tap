class Kibitz < Formula
  desc "A terminal UI for kibitzing on your coding agent's changes"
  homepage "https://github.com/Crazytieguy/kibitz"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Crazytieguy/kibitz/releases/download/v0.1.0/kibitz-aarch64-apple-darwin.tar.xz"
      sha256 "1c20501c19ea51bc3d8d39354e935502177b8c716f17e969b9da3e6531dcccb8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Crazytieguy/kibitz/releases/download/v0.1.0/kibitz-x86_64-apple-darwin.tar.xz"
      sha256 "9dd59c7677a35e2c4aafb8bb2e018563fcb94fca2b66d2a9980b21abb1ecf475"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Crazytieguy/kibitz/releases/download/v0.1.0/kibitz-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fde4c9be0cca616033e3a8fca44f3c1bbfcfab9dfe83a5caf6ac4e91bf891a5e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Crazytieguy/kibitz/releases/download/v0.1.0/kibitz-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a283a240d0b6f51383aa1122a4c3d2f40d47a5b6059cc44a0c69e01096cb9ad7"
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
    bin.install "kibitz" if OS.mac? && Hardware::CPU.arm?
    bin.install "kibitz" if OS.mac? && Hardware::CPU.intel?
    bin.install "kibitz" if OS.linux? && Hardware::CPU.arm?
    bin.install "kibitz" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
