class SerialTether < Formula
  desc "Daemon and CLI that lets AI agents and humans share a single serial device. Ships `tetherd` (daemon) and `tether` (non-interactive client) with JSON-RPC over NDJSON, UDS and TCP transports, and agent-friendly defaults."
  homepage "https://github.com/hulryung/serial-tether"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hulryung/serial-tether/releases/download/v0.7.0/serial-tether-aarch64-apple-darwin.tar.xz"
      sha256 "6556450f590e9162de6e92724986b3ef4756e1c65a04816f5fa250bc635f8033"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hulryung/serial-tether/releases/download/v0.7.0/serial-tether-x86_64-apple-darwin.tar.xz"
      sha256 "e7f153b158ff145ea594a89a7a6121cad03c968090e0587c5d3e3764c2e33799"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hulryung/serial-tether/releases/download/v0.7.0/serial-tether-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e5b03626c11929756b40815dae3b913a67076963dc9138693d10dac60c1be8ab"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hulryung/serial-tether/releases/download/v0.7.0/serial-tether-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "92a4049f33a08f7f0494bbe9ca64428a2557a2217616b5b9679589382c2b72f6"
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
