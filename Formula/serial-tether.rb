class SerialTether < Formula
  desc "Daemon and CLI that lets AI agents and humans share a single serial device. Ships `tetherd` (daemon) and `tether` (non-interactive client) with JSON-RPC over NDJSON, UDS and TCP transports, and agent-friendly defaults."
  homepage "https://github.com/hulryung/serial-tether"
  version "0.9.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hulryung/serial-tether/releases/download/v0.9.0/serial-tether-aarch64-apple-darwin.tar.xz"
      sha256 "1535b75748be3eb380d3c1a638adfaf6b9e610b5403fc459f261c6be4b53a9fb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hulryung/serial-tether/releases/download/v0.9.0/serial-tether-x86_64-apple-darwin.tar.xz"
      sha256 "230f442c445ceaf38461d68f2f0132581f0a68c45af161c7359e7de3871f8231"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hulryung/serial-tether/releases/download/v0.9.0/serial-tether-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8fdd00933bb0db556a4dc316634c9a827af3e95c52c0d24be478c6a74140bf67"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hulryung/serial-tether/releases/download/v0.9.0/serial-tether-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b47de3dc4f9c1c3572f3596a787ec365842cb019cf38d7515febde01343daad2"
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
