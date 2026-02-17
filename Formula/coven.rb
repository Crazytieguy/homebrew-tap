class Coven < Formula
  desc "A minimal streaming display and workflow runner for Claude Code's -p mode"
  homepage "https://github.com/Crazytieguy/coven"
  version "0.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Crazytieguy/coven/releases/download/v0.1.5/coven-aarch64-apple-darwin.tar.xz"
      sha256 "01d5222e7afde1f49d61b51df85ca4a4d5c488ae1e6f6bfa5e67d2f361982fe1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Crazytieguy/coven/releases/download/v0.1.5/coven-x86_64-apple-darwin.tar.xz"
      sha256 "8bac0c433014b51135f0e39f020df18def38260a04c6748b83e6f4418d2353d3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Crazytieguy/coven/releases/download/v0.1.5/coven-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "85b6b6c746c49165c1115013cc0187c3a12648ad59bcb859711e6814f1c7bd79"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Crazytieguy/coven/releases/download/v0.1.5/coven-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1a693c4bfb5b481206ebedca10fdcedbe21167f4347db3d3c6029f07d9899981"
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
