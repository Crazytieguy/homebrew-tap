class Precis < Formula
  desc "A CLI tool that extracts a token-efficient summary of a path"
  homepage "https://github.com/Crazytieguy/precis"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Crazytieguy/precis/releases/download/v0.2.1/precis-aarch64-apple-darwin.tar.xz"
      sha256 "207ba58d1e3d61e1cfdd155f8e0f5336c4830a17778773c49e36c7527288503b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Crazytieguy/precis/releases/download/v0.2.1/precis-x86_64-apple-darwin.tar.xz"
      sha256 "28b873a6b3f527d0ccc98dd2e269ac848c5a5a1f0ec9662fcb239417f3b49af8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Crazytieguy/precis/releases/download/v0.2.1/precis-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0074224a2fc4add90c54d2bb7162a4e5aba9c6c1ac1a8d7bd960da1ee474e96f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Crazytieguy/precis/releases/download/v0.2.1/precis-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "40626871dce6c24b5f2e3f799bbedaa8030f4338c2d349eaf63409c1044609c4"
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
