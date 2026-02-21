class Precis < Formula
  desc "A CLI tool that extracts a token-efficient summary of a codebase"
  homepage "https://github.com/Crazytieguy/precis"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Crazytieguy/precis/releases/download/v0.1.1/precis-aarch64-apple-darwin.tar.xz"
      sha256 "57783bff1e6b317ab861223b60f26d566f710535ddc476a7ddf8d6c29c55148b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Crazytieguy/precis/releases/download/v0.1.1/precis-x86_64-apple-darwin.tar.xz"
      sha256 "f4a4561b2b958863d41a1e710c4958c191aa1885e9ad132655012e2161819a8d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Crazytieguy/precis/releases/download/v0.1.1/precis-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b18701fbb9d15631c0a9c7ad25d144577907bf930bfbe0f6b7bcce787c839cca"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Crazytieguy/precis/releases/download/v0.1.1/precis-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "25179a7308bd30f3890631c0e9523c3745c89e60906b05e4ff984eabe5e57b89"
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
    bin.install "clone_fixtures", "precis" if OS.mac? && Hardware::CPU.arm?
    bin.install "clone_fixtures", "precis" if OS.mac? && Hardware::CPU.intel?
    bin.install "clone_fixtures", "precis" if OS.linux? && Hardware::CPU.arm?
    bin.install "clone_fixtures", "precis" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
