class Precis < Formula
  desc "A CLI tool that extracts a token-efficient summary of a path"
  homepage "https://github.com/Crazytieguy/precis"
  version "0.2.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Crazytieguy/precis/releases/download/v0.2.4/precis-aarch64-apple-darwin.tar.xz"
      sha256 "6ee7999b181e94e37946b300e5ac9023ac18fc003ab0661f5596815116b45844"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Crazytieguy/precis/releases/download/v0.2.4/precis-x86_64-apple-darwin.tar.xz"
      sha256 "046244f6b4d1a241e2609b9a95867f1a585dd6743e8251c4583f1938b4fb9850"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Crazytieguy/precis/releases/download/v0.2.4/precis-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ac77129a5718959ffe1766659e5ef226fff94c086eb05481c93ea20ce648b1ae"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Crazytieguy/precis/releases/download/v0.2.4/precis-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5b67b12ad92d9e5bfa1fdb016a03c1870d24a19501f20bdadc59d6f433fc3169"
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
