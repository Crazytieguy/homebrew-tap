class Coven < Formula
  desc "A minimal streaming display and workflow runner for Claude Code's -p mode"
  homepage "https://github.com/Crazytieguy/coven"
  version "0.1.11"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Crazytieguy/coven/releases/download/v0.1.11/coven-aarch64-apple-darwin.tar.xz"
      sha256 "56ce5bb6892f1344054f07a8a5b162d4b8a4220a5bef4a4bb98b03f44dde1962"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Crazytieguy/coven/releases/download/v0.1.11/coven-x86_64-apple-darwin.tar.xz"
      sha256 "7c2d8a38c79ccd5940fffded587ea7805588306c9516c642bae73fbe4670eacd"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Crazytieguy/coven/releases/download/v0.1.11/coven-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9bf79111eb8510495f7aaeef0c57e4242f2979df0c2d77d8704db95027ba2730"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Crazytieguy/coven/releases/download/v0.1.11/coven-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "425ff715091319bb9a72a9fe080e543e51eb41d59b6d63bc1d2742253d4b6732"
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
