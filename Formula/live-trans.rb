class LiveTrans < Formula
  desc "Real-time translation of Spotify song lyrics"
  homepage "https://github.com/Crazytieguy/live-trans"
  version "0.1.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Crazytieguy/live-trans/releases/download/v0.1.6/live-trans-aarch64-apple-darwin.tar.xz"
      sha256 "61512a1cfd8a82229ee9dbec71280dd53bbfe57dd349b49ad4dd14165900731d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Crazytieguy/live-trans/releases/download/v0.1.6/live-trans-x86_64-apple-darwin.tar.xz"
      sha256 "79da3ee0caef4493118302c398aec82feae1aaae3afd958e9630d11bbbe76da3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Crazytieguy/live-trans/releases/download/v0.1.6/live-trans-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "82554aa1bcdf9640de7b5eecb839a5d0568b300e35e9b9abe7d3f905b4ecb515"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Crazytieguy/live-trans/releases/download/v0.1.6/live-trans-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e05a8ec0b28e28f0fe41f30f4375a19ccecf2d89afa3289dc3fdb48a69b36dbb"
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
