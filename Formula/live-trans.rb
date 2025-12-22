class LiveTrans < Formula
  desc "Real-time translation of Spotify song lyrics"
  homepage "https://github.com/Crazytieguy/live-trans"
  version "0.1.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Crazytieguy/live-trans/releases/download/v0.1.7/live-trans-aarch64-apple-darwin.tar.xz"
      sha256 "b50879f8eaf96577ac0b23007e161590fa7930dedb3863c7b9f6fdd21bde3e06"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Crazytieguy/live-trans/releases/download/v0.1.7/live-trans-x86_64-apple-darwin.tar.xz"
      sha256 "a782cd49706cee2ddbeb9984b2bbd58f3505b78d9d75212d8270a838eaf01941"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Crazytieguy/live-trans/releases/download/v0.1.7/live-trans-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d4646c202446effdd74996bdc19a6783501beb6480703d351cc44efbcfd39151"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Crazytieguy/live-trans/releases/download/v0.1.7/live-trans-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ab0c77ca091558eb3b4b99343d0a8c04954a9a7653000f45da1e4bcb763278c3"
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
    bin.install "live-trans" if OS.mac? && Hardware::CPU.arm?
    bin.install "live-trans" if OS.mac? && Hardware::CPU.intel?
    bin.install "live-trans" if OS.linux? && Hardware::CPU.arm?
    bin.install "live-trans" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
