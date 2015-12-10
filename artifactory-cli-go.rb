class ArtifactoryCliGo < Formula
    desc "Artifactory CLI provides a command line interface for uploading and downloading artifacts to and from Artifactory."
    homepage "https://www.jfrog.com/"
    url "https://github.com/JFrogDev/artifactory-cli-go/archive/1.2.0.zip"
    version "1.2.0"
    sha256 "805888fb3d61e4558aa47ec5cbd39d89004f2130ec3fa5252260eb34782f10e6"
    
    depends_on "go"
    def install
        ENV["GOPATH"] = buildpath
        ENV["GOBIN"] = buildpath
        ENV["GO15VENDOREXPERIMENT"] = "1"
        (buildpath/"src/github.com/JFrogDev/artifactory-cli-go/").install Dir["*"]
        system "go", "build", "-v", "github.com/JFrogDev/artifactory-cli-go/art/"
        bin.install "art"
    end
    
    test do
        system "#{bin}/art"
    end
end
