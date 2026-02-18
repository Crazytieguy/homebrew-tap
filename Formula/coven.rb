class Coven < Formula
  desc "A minimal streaming display and workflow runner for Claude Code's -p mode"
  homepage "https://github.com/Crazytieguy/coven"
  version "0.1.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Crazytieguy/coven/releases/download/v0.1.7/coven-aarch64-apple-darwin.tar.xz"
      sha256 "60c173e650bfc514106568c75bc81dc34dd43fd6e213de6e905de7b5f920984c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Crazytieguy/coven/releases/download/v0.1.7/coven-x86_64-apple-darwin.tar.xz"
      sha256 "7b5f50834f314b164c0f2d458de1c9665d05d85c141264b63eed7e27c502d7e3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Crazytieguy/coven/releases/download/v0.1.7/coven-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5f5aa05d3e6a05e562e6617e96199e5195cd9d3694c047bcd920f223f8248512"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Crazytieguy/coven/releases/download/v0.1.7/coven-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6fe7ca9255f17fd61194c401949216747687961326c90eb5d06b50ba9cca493e"
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
