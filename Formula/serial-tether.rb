class SerialTether < Formula
  desc "Daemon and CLI that lets AI agents and humans share a single serial device. Ships `tetherd` (daemon) and `tether` (non-interactive client) with JSON-RPC over NDJSON, UDS and TCP transports, and agent-friendly defaults."
  homepage "https://github.com/hulryung/serial-tether"
  version "0.9.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hulryung/serial-tether/releases/download/v0.9.2/serial-tether-aarch64-apple-darwin.tar.xz"
      sha256 "7608c8d505df0110280b691709902d3cad0e8e494b9fee04002e15b0f14657d7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hulryung/serial-tether/releases/download/v0.9.2/serial-tether-x86_64-apple-darwin.tar.xz"
      sha256 "aef86543632b81d69990d6825bc87adf482fbc675c3443fda00b297322c2bf80"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hulryung/serial-tether/releases/download/v0.9.2/serial-tether-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4507ea5a44bedfa64e27b4c0850205849255977486e7c480d012f8444fa5ebb0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hulryung/serial-tether/releases/download/v0.9.2/serial-tether-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0f0099f4c4d675b6119689c7c5a56b0bcb86939b7f0ad3c1717f5180b96e73b7"
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
