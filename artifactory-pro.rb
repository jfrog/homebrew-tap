class ArtifactoryPro < Formula
  desc "The Univeral Binary Repository"
  homepage "https://www.jfrog.com/artifactory/"
  url "https://dl.bintray.com/jfrog/artifactory-pro/org/artifactory/pro/jfrog-artifactory-pro/4.4.2/jfrog-artifactory-pro-4.4.2.zip"
  sha256 "d5e7bcd4131483f07d245eff872a56f5b6ca6ecaf3bda3e7ddfe6f5027a89771"

  bottle do
    root_url "https://jfrog.bintray.com/tap/homebrew-tap"
	sha256 "f8e2204105cf8e505d92dea14cdb7daac03f7ddf85c81a0b15c2895f26d8f379" => :el_capitan
	sha256 "bcfd8351efc4517f50a50d2fbd5bc3b8718385c91b7605e2a3250372aaa3c344" => :yosemite
  end
  option "with-low-heap", "Run artifactory with low Java memory options. Useful for development machines. Do not use in production."

  depends_on :java => "1.8+"

  def install
    # Remove Windows binaries
    rm_f Dir["bin/*.bat"]
    rm_f Dir["bin/*.exe"]

    # Set correct working directory
    inreplace "bin/artifactory.sh",
              'export ARTIFACTORY_HOME="$(cd "$(dirname "${artBinDir}")" && pwd)"',
              "export ARTIFACTORY_HOME=#{libexec}"

    # manages binaries Reduce memory consumption for non production use
    inreplace "bin/artifactory.default",
              "-server -Xms512m -Xmx2g",
              "-Xms128m -Xmx768m" if build.with? "low-heap"

    libexec.install Dir["*"]

    # Launch Script
    bin.install_symlink libexec/"bin/artifactory.sh"
    # Memory Options
    bin.install_symlink libexec/"bin/artifactory.default"
  end

  def post_install
    # Create persistent data directory. Artifactory heavily relies on the data
    # directory being directly under ARTIFACTORY_HOME.
    # Therefore, we symlink the data dir to var.
    data = var/"artifactory"
    data.mkpath

    libexec.install_symlink data => "data"
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/artifactory/libexec/bin/artifactory.sh"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>com.jfrog.artifactory</string>
        <key>WorkingDirectory</key>
        <string>#{libexec}</string>
        <key>Program</key>
        <string>bin/artifactory.sh</string>
        <key>KeepAlive</key>
        <true/>
      </dict>
    </plist>
  EOS
  end

  test do
    assert_match /Checking arguments to Artifactory/, pipe_output("#{bin}/artifactory.sh check")
  end
end
