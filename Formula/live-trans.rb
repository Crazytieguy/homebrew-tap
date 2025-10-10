class LiveTrans < Formula
  desc "Real-time translation of Spotify song lyrics"
  homepage "https://github.com/Crazytieguy/live-trans"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Crazytieguy/live-trans/releases/download/v0.1.3/live-trans-aarch64-apple-darwin.tar.xz"
      sha256 "33234852140f648d608c1048d77562d0941e1bdb61c94b6078d3a4d9a8c1965a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Crazytieguy/live-trans/releases/download/v0.1.3/live-trans-x86_64-apple-darwin.tar.xz"
      sha256 "cf9603c81be656d752dbab020f8436141baa34360a8c0d3d3acc132beb01e021"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Crazytieguy/live-trans/releases/download/v0.1.3/live-trans-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "14f81476a9ae56d6ef26f00506a173350f6ff76452529389556b8f0d8abea08e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Crazytieguy/live-trans/releases/download/v0.1.3/live-trans-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d94c3f533d7db4dc4a4b82791765d408fae7647d1d2854aa82717d67f5adcf7b"
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
