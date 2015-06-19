# JSZVCR

## Description
This is a simple testing framework for recording and replaying network calls for automated integration testing. In order to reduce stubbing, it records live network requests and responses and then replays them in subsequent runs, stubbing the network requests (thanks to the fabulous https://github.com/AliSoftware/OHHTTPStubs) so that your software can run in peace.

[![CI Status](http://img.shields.io/travis/Jordan Zucker/JSZVCR.svg?style=flat)](https://travis-ci.org/Jordan Zucker/JSZVCR)
[![Version](https://img.shields.io/cocoapods/v/JSZVCR.svg?style=flat)](http://cocoapods.org/pods/JSZVCR)
[![License](https://img.shields.io/cocoapods/l/JSZVCR.svg?style=flat)](http://cocoapods.org/pods/JSZVCR)
[![Platform](https://img.shields.io/cocoapods/p/JSZVCR.svg?style=flat)](http://cocoapods.org/pods/JSZVCR)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

JSZVCR is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "JSZVCR"
```

## 

## Author

Jordan Zucker, jordan.zucker@gmail.com

## License

JSZVCR is available under the MIT license. See the LICENSE file for more info.

## Release criteria
* script to move responses into project
* clean up responses logging
* add logging in general
* separate out xctest dependency (separate subspec, categories for all the extra methods)
* separate out recorder (separate subspec)
* change name? (Be kind rewind)
* return obj instead of dict for responses
* handle multiple responses
* Separate class for matching requests with responses (used by JSZPlayer)
* get fuzzy for request matching
* don't save file unless something was recorded
* fail tests if too many or too few requests, (level option for this)
* better tests!
* speed tests
* add CI!!
