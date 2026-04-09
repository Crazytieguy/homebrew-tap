class Precis < Formula
  desc "A CLI tool that extracts a token-efficient summary of a path"
  homepage "https://github.com/Crazytieguy/precis"
  version "0.1.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Crazytieguy/precis/releases/download/v0.1.8/precis-aarch64-apple-darwin.tar.xz"
      sha256 "b6843c1d992d630fc16c62b1d31401a69bf97b515349cb9163c9bd0841e94207"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Crazytieguy/precis/releases/download/v0.1.8/precis-x86_64-apple-darwin.tar.xz"
      sha256 "444bc7a40ced8d75b4c3bea2bd293adc0bc9baaf63e94a5996cbd69b75645f13"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Crazytieguy/precis/releases/download/v0.1.8/precis-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4f69a572e4401edd740075ad28889731762ade1dbf99b24903087c440669e6a2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Crazytieguy/precis/releases/download/v0.1.8/precis-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4c960eb84a615f1ca72d40c1be3a7572be9c497ddffb5f4ff4c54f7a1b564535"
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
