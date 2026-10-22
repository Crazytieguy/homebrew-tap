class Precis < Formula
  desc "A CLI tool that extracts a token-efficient summary of a path"
  homepage "https://github.com/Crazytieguy/precis"
  version "0.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Crazytieguy/precis/releases/download/v0.2.2/precis-aarch64-apple-darwin.tar.xz"
      sha256 "19b66e5345d0cd03aef32cf8626e757937e8b17e9439b56267ac77ceda963965"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Crazytieguy/precis/releases/download/v0.2.2/precis-x86_64-apple-darwin.tar.xz"
      sha256 "ea1898d7d9b00ba2e7fbf6b9101bea0897576eec03996f21b7c1cf447b82ad8e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Crazytieguy/precis/releases/download/v0.2.2/precis-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2b8c7b3a00dbd6ce74a8ea0378f3c4708f2f1f28f405f9f36ff1157fb4952283"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Crazytieguy/precis/releases/download/v0.2.2/precis-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "770a5c4b74b5408e201f49865d283e31589de3537c96532b24ff19b7ac76920a"
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
