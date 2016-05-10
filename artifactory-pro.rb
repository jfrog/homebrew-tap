class ArtifactoryPro < Formula
  desc "The Univeral Binary Repository"
  homepage "https://www.jfrog.com/artifactory/"
  url "https://dl.bintray.com/jfrog/artifactory-pro/org/artifactory/pro/jfrog-artifactory-pro/4.7.6/jfrog-artifactory-pro-4.7.6.zip"
  sha256 "08b3f9ecb46cb462f7cb6955c366b74734ddf3b4d56f3e347b490bbbe31e0884"

  bottle do
    root_url "https://jfrog.bintray.com/tap/homebrew-tap"
	sha256 "b5c8072fa530ac7c02ed86fc7ee59a16708d73b59c16f949ed3608cf1734618e" => :el_capitan
	sha256 "f681129407a9a44fa2bba854ea2003041642c6876dd26a057963f4446e878333" => :yosemite
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
