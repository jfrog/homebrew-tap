### Homebrew external tap for JFrog formulas


How to use:
 0. Install [Homebrew](http://brew.sh/)
 1. Add this repository as a [tap](https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/How-to-Create-and-Maintain-a-Tap.md): `brew tap JFrogDev/tap`
 2. Install:  
  * [Artifactory Pro](https://www.jfrog.com/artifactory/): `brew install artifactory-pro`
  * [Artifactory Command Line Interace](https://github.com/JFrogDev/artifactory-cli-go): `brew install artifactory-cli`

P.S. Both [Artifactory OSS](https://www.jfrog.com/open-source/) and Artifactory Command Line Interace are avaible directly from Homebrew [here](https://github.com/Homebrew/homebrew/blob/master/Library/Formula/artifactory.rb) and [here](https://github.com/Homebrew/homebrew/blob/master/Library/Formula/artifactory-cli-go.rb), so no external tap needed. Just run `brew install artifactory` or `brew install artifactory-cli`.
