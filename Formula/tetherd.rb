class Tetherd < Formula
  desc "Serial Tether — daemon that owns a serial port and exposes it to multiple clients (humans + agents)"
  homepage "https://github.com/hulryung/serial-tether"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hulryung/serial-tether/releases/download/v0.2.1/tetherd-aarch64-apple-darwin.tar.xz"
      sha256 "9cae20cb0f5c7d08fb08ac3aadfdaaae2aef474fde51d0187c919251acbe6c71"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hulryung/serial-tether/releases/download/v0.2.1/tetherd-x86_64-apple-darwin.tar.xz"
      sha256 "f93f29dad823eff106c53cd799180367d937dab98b3120c5e5538012138b3f88"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hulryung/serial-tether/releases/download/v0.2.1/tetherd-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f91d3510c2f199d2458e0577921bb3a7b16a5c9321fc4666aa47e53241efbc4f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hulryung/serial-tether/releases/download/v0.2.1/tetherd-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "96e1824d87eb980629dcf5a1b82ab94ec97744fd476875c9e625dadb8d9d3b2f"
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
    bin.install "tetherd" if OS.mac? && Hardware::CPU.arm?
    bin.install "tetherd" if OS.mac? && Hardware::CPU.intel?
    bin.install "tetherd" if OS.linux? && Hardware::CPU.arm?
    bin.install "tetherd" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
