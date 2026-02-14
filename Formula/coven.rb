class Coven < Formula
  desc "A minimal streaming display and workflow runner for Claude Code's -p mode"
  homepage "https://github.com/Crazytieguy/coven"
  version "0.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Crazytieguy/coven/releases/download/v0.1.4/coven-aarch64-apple-darwin.tar.xz"
      sha256 "057c33bdfa387c0f89ae55b60a33991a59f2d521ecfc1eabd5027dd23e620b1c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Crazytieguy/coven/releases/download/v0.1.4/coven-x86_64-apple-darwin.tar.xz"
      sha256 "a9a6957662e6525c8bf8e89b5e1083597a7c19610a5c02b9a5d58372cfe90031"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Crazytieguy/coven/releases/download/v0.1.4/coven-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "364c000bc18e31b201f3decf319c157d1e7fe3976e1998f2bae83370856177e2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Crazytieguy/coven/releases/download/v0.1.4/coven-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "bf80ddeb3961880146c89d2e61cf000a2ddf3483c051b512137dbcfcfd83b89b"
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
