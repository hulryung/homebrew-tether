class SerialTether < Formula
  desc "Serial Tether — daemon and CLI for sharing a serial device with humans and AI agents"
  homepage "https://github.com/hulryung/serial-tether"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hulryung/serial-tether/releases/download/v0.3.1/serial-tether-aarch64-apple-darwin.tar.xz"
      sha256 "5a93375834a907c84888521af91b29c380c4ef68578aa115d8a7a2cfa82445c1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hulryung/serial-tether/releases/download/v0.3.1/serial-tether-x86_64-apple-darwin.tar.xz"
      sha256 "719e9f048d0780993db41128a125acf8ce199745ebdf81612d9c0614e6d7026a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hulryung/serial-tether/releases/download/v0.3.1/serial-tether-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "df4022876c87eeb681542061d644d6707beb0e9eae09b1d8e467bf49f3ad6dee"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hulryung/serial-tether/releases/download/v0.3.1/serial-tether-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "42dd87f04c281651cb5e4d70a41f6a6a8720d40952f975c70812a137f2962136"
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
