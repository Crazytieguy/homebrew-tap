class Precis < Formula
  desc "A CLI tool that extracts a token-efficient summary of a codebase"
  homepage "https://github.com/Crazytieguy/precis"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Crazytieguy/precis/releases/download/v0.1.2/precis-aarch64-apple-darwin.tar.xz"
      sha256 "c360b53a48b947a447da0f7aa695ae4d631643377e623c3bbd5e8f7d9eded58b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Crazytieguy/precis/releases/download/v0.1.2/precis-x86_64-apple-darwin.tar.xz"
      sha256 "53da98b3ffdf13161341c39a4f748ca8241d2d8a07d6cabc60b8c2d4cae281e5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Crazytieguy/precis/releases/download/v0.1.2/precis-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "efe005b7fa9fa2b9e1e05d77b1873c2a97e0aeb0d11a14e650c570c77142a7a7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Crazytieguy/precis/releases/download/v0.1.2/precis-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e4547e9057952bc2e118e8f2952ef891a481c4d864b1b9455c3271e3805305f5"
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
    bin.install "precis" if OS.mac? && Hardware::CPU.arm?
    bin.install "precis" if OS.mac? && Hardware::CPU.intel?
    bin.install "precis" if OS.linux? && Hardware::CPU.arm?
    bin.install "precis" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
