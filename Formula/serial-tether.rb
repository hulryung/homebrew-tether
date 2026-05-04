class SerialTether < Formula
  desc "Serial Tether — daemon and CLI for sharing a serial device with humans and AI agents"
  homepage "https://github.com/hulryung/serial-tether"
  version "0.3.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hulryung/serial-tether/releases/download/v0.3.2/serial-tether-aarch64-apple-darwin.tar.xz"
      sha256 "24bbdb51319626cab096c8a4e84d07fb2a875ed2200b015e72e454266a32d68f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hulryung/serial-tether/releases/download/v0.3.2/serial-tether-x86_64-apple-darwin.tar.xz"
      sha256 "2dac162e90beffa5c13918c2dd8265a5f90408889bf8361605b57d6a7fd67837"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hulryung/serial-tether/releases/download/v0.3.2/serial-tether-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8cd567207649da7584614588c8241265b0a7dedab8100c8f342a3f6583ffc2fa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hulryung/serial-tether/releases/download/v0.3.2/serial-tether-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6d067ae71235910f7ebccf1b0c386404cf4e9d90efcc14a9c0ff40937e388d7c"
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
