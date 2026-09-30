class Precis < Formula
  desc "A CLI tool that extracts a token-efficient summary of a path"
  homepage "https://github.com/Crazytieguy/precis"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Crazytieguy/precis/releases/download/v0.2.0/precis-aarch64-apple-darwin.tar.xz"
      sha256 "106692562b96333433f3e1f51d22a1ccf42aab10f24da32d8368da2929dc3a9f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Crazytieguy/precis/releases/download/v0.2.0/precis-x86_64-apple-darwin.tar.xz"
      sha256 "c1fe90969d00dcdd5939e73f877771e5478fb87a3ffd6d6ec78e025635d936cc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Crazytieguy/precis/releases/download/v0.2.0/precis-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e55bb62bbed9ab2081e04f131da3b208a1367e2b83e6edd058302e16c30149b1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Crazytieguy/precis/releases/download/v0.2.0/precis-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a0fd9f4e5a5f2ebe3264baec3662d6ca4661c0f663d46094cc4688317db7943d"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "precis"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "precis"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "precis"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "precis"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
