class Tether < Formula
  desc "Serial Tether — non-interactive CLI for tetherd (designed for AI agents and shell scripts)"
  homepage "https://github.com/hulryung/serial-tether"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hulryung/serial-tether/releases/download/v0.2.1/tether-aarch64-apple-darwin.tar.xz"
      sha256 "f102a8ab5d88c6425f0640b4b288a1c909555b2ca864e3a0423fa72b175b8efe"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hulryung/serial-tether/releases/download/v0.2.1/tether-x86_64-apple-darwin.tar.xz"
      sha256 "b8c8c406326f8ebca30d1e190d6137252afa0325e3d1dd9772a4f011ce441289"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hulryung/serial-tether/releases/download/v0.2.1/tether-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "275248ba972a7a95104256aa9348787c0f37da93d935bee6235dc5a0b3b56b39"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hulryung/serial-tether/releases/download/v0.2.1/tether-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8796eb594f7db0ceabd1b6eb8eb27d355da148bc5b953555ca74bcf46ad7bb26"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

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
    bin.install "tether" if OS.mac? && Hardware::CPU.arm?
    bin.install "tether" if OS.mac? && Hardware::CPU.intel?
    bin.install "tether" if OS.linux? && Hardware::CPU.arm?
    bin.install "tether" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
