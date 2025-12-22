class LiveTrans < Formula
  desc "Real-time translation of Spotify song lyrics"
  homepage "https://github.com/Crazytieguy/live-trans"
  version "0.1.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Crazytieguy/live-trans/releases/download/v0.1.8/live-trans-aarch64-apple-darwin.tar.xz"
      sha256 "dd9bd55eb78c4deb452ca463e4ef37cbc69994eca4cc101fffbae33d2b6934cb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Crazytieguy/live-trans/releases/download/v0.1.8/live-trans-x86_64-apple-darwin.tar.xz"
      sha256 "aab3406dddb6122287443eb6dc249cf0c6b2e20e6d10dc925e55feb9e8b920a4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Crazytieguy/live-trans/releases/download/v0.1.8/live-trans-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3d810f14c2d2188cca448b546cd27e9bd92010cdba495b34c59b8efab13cda94"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Crazytieguy/live-trans/releases/download/v0.1.8/live-trans-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b4a93ac903f1ca5674659a8cfcc33df8ec7a231e64d0e3fae0c916146f2bb719"
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
