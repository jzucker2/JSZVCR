# JSZVCR
[![Build Status](https://travis-ci.org/jzucker2/JSZVCR.svg?branch=master)](https://travis-ci.org/jzucker2/JSZVCR)
[![Coverage Status](https://coveralls.io/repos/jzucker2/JSZVCR/badge.svg?branch=master)](https://coveralls.io/r/jzucker2/JSZVCR?branch=master)
[![Version](https://img.shields.io/cocoapods/v/JSZVCR.svg?style=flat)](http://cocoapods.org/pods/JSZVCR)
[![License](https://img.shields.io/cocoapods/l/JSZVCR.svg?style=flat)](http://cocoapods.org/pods/JSZVCR)
[![Platform](https://img.shields.io/cocoapods/p/JSZVCR.svg?style=flat)](http://cocoapods.org/pods/JSZVCR)

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
#import <XCTest/XCTest.h>
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

- (JSZVCRTestingStrictness)matchingFailStrictness {
    return JSZVCRTestingStrictnessNone;
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

These are set automatically. Feel free to override with appropriate values but it is not necessary if these will suffice. It is possible these defaults will change until version 1.0 lands.

```objective-c
- (BOOL)isRecording {
    return YES;
}

- (JSZVCRTestingStrictness)matchingFailStrictness {
    return JSZVCRTestingStrictnessNone;
}

- (Class<JSZVCRMatching>)matcherClass {
    return [JSZVCRSimpleURLMatcher class];
}
```

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
* don't save file unless something was recorded
* speed tests
* add recording for NSURLConnection, NSURLSessionDelegate, NSURLSession on iOS 7
* add tests for AFNetworking
* better support for cancelling and errored network connects
* proper support for redirects
