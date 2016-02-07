# JSZVCR
[![Build Status](https://travis-ci.org/jzucker2/JSZVCR.svg?branch=master)](https://travis-ci.org/jzucker2/JSZVCR)
[![Coverage Status](https://coveralls.io/repos/jzucker2/JSZVCR/badge.svg?branch=master)](https://coveralls.io/r/jzucker2/JSZVCR?branch=master)
[![Version](https://img.shields.io/cocoapods/v/JSZVCR.svg?style=flat)](http://cocoapods.org/pods/JSZVCR)
[![License](https://img.shields.io/cocoapods/l/JSZVCR.svg?style=flat)](http://cocoapods.org/pods/JSZVCR)
[![Platform](https://img.shields.io/cocoapods/p/JSZVCR.svg?style=flat)](http://cocoapods.org/pods/JSZVCR)

**This project has been discontinued, and is no longer being maintained. Use [BeKindRewind](https://github.com/jzucker2/BeKindRewind) instead.**

Simple XCTest subclass for recording and replaying network events for integration testing

## Features

* Easy recording and replaying
* Easy to fail tests when network requests don't match recorded requests (can set level easily)
* Can create custom matchers for matching recorded responses to requests
* Provides everything in an XCTest subclass

## Description
This is a simple testing framework for recording and replaying network calls for automated integration testing. In order to reduce stubbing, it records live network requests and responses and then replays them in subsequent runs, stubbing the network requests (thanks to the fabulous https://github.com/AliSoftware/OHHTTPStubs) so that your software can run in peace.

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

JSZVCR is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "JSZVCR"
```

## Example

```objective-c
#import <JSZVCR/JSZVCR.h>

@interface JSZVCRExampleTestCase : JSZVCRTestCase
@end

@implementation JSZVCRExampleTestCase

- (BOOL)isRecording {
    return YES;
}

- (Class<JSZVCRMatching>)matcherClass {
    return [JSZVCRSimpleURLMatcher class];
}

- (JSZVCRMatchingStrictness)matchingFailStrictness {
    return JSZVCRMatchingStrictnessNone;
}

- (void)testSimpleNetworkCall {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://httpbin.org/get?test=test"]];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration]];
    
    // don't forget to create a test expectation
    XCTestExpectation *networkExpectation = [self expectationWithDescription:@"network"];
    NSURLSessionDataTask *basicGetTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(response);
        XCTAssertNotNil(data);
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        XCTAssertNil(error);
        XCTAssertEqualObjects(dataDict[@"args"], @{@"test" : @"test"});
        // fulfill the expectation
        [networkExpectation fulfill];
    }];
    [basicGetTask resume];
    // explicitly wait for the expectation
    [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
        if (error) {
        	 // Assert fail if timeout encounters an error
        	 XCTAssertNil(error);
        }
    }];
}

```

After running this test, files will be outputted to the console with a log similar to this:

```bash
2015-06-25 20:48:47.968 xctest[97164:1809740] filePath = /Users/jzucker/Library/Developer/CoreSimulator/Devices/F9C2D4BE-9022-48E9-9A27-C89B8E615571/data/Documents/JSZVCRExampleTestCase.bundle/testSimpleNetworkCall.plist
```

Drag this into your project as a bundle named after your test case (it is named automatically).

Then flip the `isRecording` value to NO:

```objective-c
- (BOOL)isRecording {
	return NO;
}
```

Then on subsequent runs, the tests will use the recorded files to respond to matched network requests.

## JSZVCRTestCase Defaults

These are set automatically. Feel free to override with appropriate values but it is not necessary if these will suffice. It is possible these defaults will change until version 1.0 lands. A note about recording and playback, they are only valid during test run, not during set up and tear down.

```objective-c
- (BOOL)isRecording {
    return YES;
}

- (JSZVCRMatchingStrictness)matchingFailStrictness {
    return JSZVCRMatchingStrictnessNone;
}

- (Class<JSZVCRMatching>)matcherClass {
    return [JSZVCRSimpleURLMatcher class];
}
```

## Basic Testing Strategy

Try to avoid writing a test that is dependent upon state. Instead, ensure that when `isRecording == YES` that the test can be fully recorded for playback, including setUp and tearDown. This eases development and ensures that the test isn't written on a condition that wouldn't be recreated when another developer tries to update your test with a new recording.

## Support for iOS 7

Use version 0.6.x or lower if you want to test against iOS 7 or lower.

## Author

Jordan Zucker, jordan.zucker@gmail.com

## License

JSZVCR is available under the MIT license. See the LICENSE file for more info.

## Release criteria
* script to move responses into project
* clean up responses logging
* add logging in general
* separate out recorder (separate subspec)
* change name? (Be kind rewind)
* return obj instead of dict for responses
* handle multiple responses
* don't save file unless something was recorded
* speed tests
* better support for cancelling and errored network connects
* proper support for redirects
* Add Swift tests and Swift testing target
