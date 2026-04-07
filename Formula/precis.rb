class Precis < Formula
  desc "A CLI tool that extracts a token-efficient summary of a path"
  homepage "https://github.com/Crazytieguy/precis"
  version "0.1.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Crazytieguy/precis/releases/download/v0.1.6/precis-aarch64-apple-darwin.tar.xz"
      sha256 "d2c68f3b6017f47f2e8127f2638ded6ba2f6c0201c8155c6048895cdb129e814"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Crazytieguy/precis/releases/download/v0.1.6/precis-x86_64-apple-darwin.tar.xz"
      sha256 "b0107206b593bbbdeff76951acdb1faf5b7cdbbec2eb76500abb03a27f4a5451"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Crazytieguy/precis/releases/download/v0.1.6/precis-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bb6f5af452f83a4bbc9fb3fc1d28ab6a9295b7b4cb509b8029c2fdc56dc3a465"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Crazytieguy/precis/releases/download/v0.1.6/precis-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d533a4d7bfc94f3f6d0c5da537df1d20a57803fdf3f18a960c865f7ae9dad39e"
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
