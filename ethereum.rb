require 'formula'

class Ethereum < Formula
  version '1.4.3'

  homepage 'https://github.com/ethereum/go-ethereum'
  url 'https://github.com/ethereum/go-ethereum.git', :branch => 'master'

  bottle do
    revision 16
    root_url 'https://build.ethdev.com/builds/bottles'
    sha256 'f8d42484b2d09885ce9b5a7155385b7d6bfb49604508c851e3d96853ac7d68d1' => :yosemite
    sha256 '7c83599b03dcf3350957ab6f49ae7b9e69c9413ecbd2b37a919cc27c5b95d8f2' => :el_capitan
  end

  devel do
    bottle do
      revision 188
      root_url 'https://build.ethdev.com/builds/bottles-dev'
      sha256 '1b9cc7f5c20a5ec2fe7bfc911f8cfd7e032c7faba6ab70f2149866317912191d' => :yosemite
      sha256 'e1492295bbc5affccc8df87becc0d6d6013bc8a25c6e91f060587e29b8a069e0' => :el_capitan
    end

    version '1.5.0'
    url 'https://github.com/ethereum/go-ethereum.git', :branch => 'develop'
  end

  depends_on 'go' => :build

  def install
    ENV["GOROOT"] = "#{HOMEBREW_PREFIX}/opt/go/libexec"
    system "go", "env" # Debug env
    system "make", "all"
    bin.install 'build/bin/evm'
    bin.install 'build/bin/geth'
    bin.install 'build/bin/rlpdump'
  end

  test do
    system "make", "test"
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>ThrottleInterval</key>
        <integer>300</integer>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_bin}/geth</string>
            <string>-datadir=#{prefix}/.ethereum</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
      </dict>
    </plist>
    EOS
  end
end
