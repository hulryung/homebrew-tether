class SerialTether < Formula
  desc "Daemon and CLI that lets AI agents and humans share a single serial device. Ships `tetherd` (daemon) and `tether` (non-interactive client) with JSON-RPC over NDJSON, UDS and TCP transports, and agent-friendly defaults."
  homepage "https://github.com/hulryung/serial-tether"
  version "0.7.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hulryung/serial-tether/releases/download/v0.7.1/serial-tether-aarch64-apple-darwin.tar.xz"
      sha256 "cc162ee793066d6a1bb3d461462d320ce21a42fbb77c48aeb0520f5107b99e2f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hulryung/serial-tether/releases/download/v0.7.1/serial-tether-x86_64-apple-darwin.tar.xz"
      sha256 "4aaa4013728614748f85a6a086565e4fe8825031822012d4a0ac82befe699996"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hulryung/serial-tether/releases/download/v0.7.1/serial-tether-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8f9151361a59a6d8d393ad50c17f4da699609dd13e5d76d53fd017f2d09d6766"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hulryung/serial-tether/releases/download/v0.7.1/serial-tether-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "28a840b5486f204adb58d0125523ee9a6f63c90972f2f5c64fbd68699935bd2a"
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
