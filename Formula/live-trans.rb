class LiveTrans < Formula
  desc "Real-time translation of Spotify song lyrics"
  homepage "https://github.com/Crazytieguy/live-trans"
  version "0.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Crazytieguy/live-trans/releases/download/v0.1.4/live-trans-aarch64-apple-darwin.tar.xz"
      sha256 "d01d15a6b57a435a89f9634e255da55c56d1f62a84643e3406520d49a6680e7d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Crazytieguy/live-trans/releases/download/v0.1.4/live-trans-x86_64-apple-darwin.tar.xz"
      sha256 "139d0b8ed6b438f742ea3f683355dd6e2d02ea5ae91a1569216cb0409699fc2c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Crazytieguy/live-trans/releases/download/v0.1.4/live-trans-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1eb32220386d99a8d31b29193495feeb8f7d12af616b2bb3a5e3e3984b752661"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Crazytieguy/live-trans/releases/download/v0.1.4/live-trans-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3abd743c0956c5283ee9bc6c66c0557d2ec3f48e59ebb372778118de1240de77"
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
