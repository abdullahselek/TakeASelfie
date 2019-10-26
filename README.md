[![Build Status](https://travis-ci.org/abdullahselek/TakeASelfie.svg?branch=master)](https://travis-ci.org/abdullahselek/TakeASelfie)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/TakeASelfie.svg)](http://cocoapods.org/pods/TakeASelfie)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
![License](https://img.shields.io/dub/l/vibe-d.svg)

# TakeASelfie

An iOS framework that uses the front camera, detects your face and takes a selfie. This api opens the front camera and draws an green oval overlay on the center of the screen. When a single face has been included in the overlay, selfie automatically will be taken and saved in photo album.

## Screenshot

<p align="center">
  <img src="https://github.com/abdullahselek/TakeASelfie/blob/master/Resources/selfie_screen.png"/>
</p>

## Requirements

| TakeASelfie Version | Minimum iOS Target  | Swift Version |
|:-------------------:|:-------------------:|:-------------------:|
| 0.1.3.1 | 11.0| 5.0 |
| 0.1.3 | 11.0| 4.2 |
| 0.1.2 | 11.0| 4.1 |


Don't forget to add permissions to your application.

- Privacy - Camera Usage Description (`For using camera`)
- Privacy - Photo Library Additions Usage Description (`To save captured selfies`)
- Privacy - Photo Library Usage Description - Optional (`To display saved selfies from photo album`)

## CocoaPods

CocoaPods is a dependency manager for Cocoa projects. You can install it with the following command:
```
$ gem install cocoapods
```

To integrate TakeASelfie into your Xcode project using CocoaPods, specify it in your Podfile:
```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '11.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'TakeASelfie', '~>0.1.3.1'
end
```

## Carthage

Carthage is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with Homebrew using the following command:

```
brew update
brew install carthage
```

To integrate TakeASelfie into your Xcode project using Carthage, specify it in your Cartfile:

```
github "abdullahselek/TakeASelfie" ~> 0.1.3.1
```

## Swift Package Manager

Modify your `Package.swift` file to include the following dependency:

```
.package(url: "https://github.com/abdullahselek/TakeASelfie.git", from: "0.1.3.1")
```

Run `swift package resolve`

## Usage

First import library by

`import TakeASelfie`.

Extend your viewcontroller from `SelfieViewDelegate` than you can get the event that selfieviewcontroller dismessed.

```
extension MainViewController: SelfieViewDelegate {

    func selfieViewControllerDismissed() {

    }

}
```

Instantiate `SelfieViewController` and present as modal view controller.

```
let selfieViewController = SelfieViewController(withDelegate: self)
present(selfieViewController, animated: true, completion: nil)
```

## Notes

**TakeASelfie** uses [swiftlint](https://github.com/realm/SwiftLint) as a linter to check the coding styles and to use a regular style. A script running whnen you build the framework target which invokes the `swiftlint` with a configuration file located on the root folder.
