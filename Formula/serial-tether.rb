class SerialTether < Formula
  desc "Daemon and CLI that lets AI agents and humans share a single serial device. Ships `tetherd` (daemon) and `tether` (non-interactive client) with JSON-RPC over NDJSON, UDS and TCP transports, and agent-friendly defaults."
  homepage "https://github.com/hulryung/serial-tether"
  version "0.10.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hulryung/serial-tether/releases/download/v0.10.0/serial-tether-aarch64-apple-darwin.tar.xz"
      sha256 "df7cfc5ef982e642e54160260967b247bb4103c8b245bf6ba7a148596ddeece6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hulryung/serial-tether/releases/download/v0.10.0/serial-tether-x86_64-apple-darwin.tar.xz"
      sha256 "e53f22ed51ec8879eedbb29c52b1bf9165aedb665a8d98a4ceb33f1908e53ed1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hulryung/serial-tether/releases/download/v0.10.0/serial-tether-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4daa7b83d0a6a16a1a3c9385fbcf281d0f23d670ce48f7abb3e8a901d5d6f4c8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hulryung/serial-tether/releases/download/v0.10.0/serial-tether-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "38247abe3cdfde852969f752effbb8ad5ca1659b2547e188efe81ac8bb05eff1"
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
    bin.install "tether", "tetherd" if OS.mac? && Hardware::CPU.arm?
    bin.install "tether", "tetherd" if OS.mac? && Hardware::CPU.intel?
    bin.install "tether", "tetherd" if OS.linux? && Hardware::CPU.arm?
    bin.install "tether", "tetherd" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
