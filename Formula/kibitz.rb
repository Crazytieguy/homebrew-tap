class Kibitz < Formula
  desc "A terminal UI for kibitzing on your coding agent's changes"
  homepage "https://github.com/Crazytieguy/kibitz"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Crazytieguy/kibitz/releases/download/v0.1.1/kibitz-aarch64-apple-darwin.tar.xz"
      sha256 "cba2e28e88c2082e3defe753cb265f53d85f1cf0f53ad06606c2bae4c4dc7dc8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Crazytieguy/kibitz/releases/download/v0.1.1/kibitz-x86_64-apple-darwin.tar.xz"
      sha256 "c21bd73fc5184b322d434ea9bbce104eea706b93130dbb40c4e4292b2f95df59"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Crazytieguy/kibitz/releases/download/v0.1.1/kibitz-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "276f0ef3ca984ca61f760e980be7a323dcd10cbfc3e2f1eea7bccbe45f7cb30b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Crazytieguy/kibitz/releases/download/v0.1.1/kibitz-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "be220523c24e3940ade55e91398c978093280c0bb1146b6403b33eb684766016"
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
    bin.install "kibitz" if OS.mac? && Hardware::CPU.arm?
    bin.install "kibitz" if OS.mac? && Hardware::CPU.intel?
    bin.install "kibitz" if OS.linux? && Hardware::CPU.arm?
    bin.install "kibitz" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
