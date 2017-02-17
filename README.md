# BlindWays iOS

This app [helps blind users find bus stops](http://www.perkins.org/solutions/featured-products/blindways). The open source app requires you to also set up your own [BlindWays Server](https://github.com/perkinsvision/BlindWays-web) to access bus stop data.

## Placeholders

The app contains placeholders for several private settings. All of these placeholders have a comment that starts with // PLACEHOLDER above them, and an explanation of what data needs to be placed there.

## Getting Started

After cloning the repository and navigating to it's root directory, you'll need to:

```sh
# Install the correct version of required pods via http://bundler.io:
bundle install
# Move into the directory the Xcode project is in:
cd app
# Install all of the Pods for the project using the bundled version of CocoaPods:
bundle exec pod install
# Open the project
open BlindWays.xcworkspace
```
