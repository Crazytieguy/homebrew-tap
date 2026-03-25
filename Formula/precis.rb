class Precis < Formula
  desc "A CLI tool that extracts a token-efficient summary of a path"
  homepage "https://github.com/Crazytieguy/precis"
  version "0.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Crazytieguy/precis/releases/download/v0.1.4/precis-aarch64-apple-darwin.tar.xz"
      sha256 "d5ba96a10042794d511fcc06eb5b20fffa8b8e872849100bf500efbaa4a4d951"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Crazytieguy/precis/releases/download/v0.1.4/precis-x86_64-apple-darwin.tar.xz"
      sha256 "d73909ec8dc6e5520403b3007faeb7cee381acc1e45441c54d10955c7a686805"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Crazytieguy/precis/releases/download/v0.1.4/precis-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "df9271118c5c6e9d590bd4309357a10d9b435997b733c7276a67d367f6a8a8de"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Crazytieguy/precis/releases/download/v0.1.4/precis-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2254dfcf961f09443a72d4bd72787a0b4ad3cd09773c999dc72bc7a5a2e3e547"
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
