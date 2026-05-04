class SerialTether < Formula
  desc "Serial Tether — daemon and CLI for sharing a serial device with humans and AI agents"
  homepage "https://github.com/hulryung/serial-tether"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hulryung/serial-tether/releases/download/v0.4.0/serial-tether-aarch64-apple-darwin.tar.xz"
      sha256 "85b9ae2c392e3339669958a017aedafb2568472235deffbaa052374d5d037380"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hulryung/serial-tether/releases/download/v0.4.0/serial-tether-x86_64-apple-darwin.tar.xz"
      sha256 "11ab0b2e0112b6be1a74d9d52df8a3af4467b3435d0a593c3f0e1ec8630b68f8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hulryung/serial-tether/releases/download/v0.4.0/serial-tether-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "29704d18f4fb8985f4d8f6fdc567844c8820f64460fb37de8a6cec3a8d6b35d9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hulryung/serial-tether/releases/download/v0.4.0/serial-tether-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9a96297bb45582684c87cc85dd67e2fd60cf7a66b3d1c03174901c4ea01ec5f7"
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
