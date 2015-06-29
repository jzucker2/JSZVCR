//
//  JSZUnorderedMatcherTestCase.m
//  JSZVCR
//
//  Created by Jordan Zucker on 6/20/15.
//  Copyright (c) 2015 Jordan Zucker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <JSZVCR/JSZVCR.h>
#import <JSZVCR/JSZVCRPlayer.h>

#import "XCTestCase+XCTestCase_JSZVCRAdditions.h"

typedef void (^UnorderedAssertions)(NSString *headerDate, NSDictionary *args);

@interface JSZUnorderedMatcherTestCase : JSZVCRTestCase

@end

@implementation JSZUnorderedMatcherTestCase

- (BOOL)isRecording {
    return NO;
}

- (Class<JSZVCRMatching>)matcherClass {
    return [JSZVCRUnorderedQueryMatcher class];
}

- (JSZVCRTestingStrictness)matchingFailStrictness {
    if (self.invocation.selector == @selector(testUniqueNetworkCallToProveNotAlwaysMatching)) {
        return JSZVCRTestingStrictnessNone;
    }
    return JSZVCRTestingStrictnessFailWhenNoMatch;
}

- (void)testSimpleUnorderedQueryNetworkCallWithQueryParameters {
    // ensure there is only one recording
    XCTAssertNotNil(self.recordings);
    XCTAssertEqual(self.recordings.count, 1);
    UnorderedAssertions assertions = ^void(NSString *headerDate, NSDictionary *args) {
        XCTAssertEqualObjects(headerDate, @"Mon, 29 Jun 2015 20:44:35 GMT");
        NSDictionary *expectedArgsDict = @{
                                           @"bar" : @"bar",
                                           @"foo" : @"foo"
                                           };
        XCTAssertEqualObjects(args, expectedArgsDict);
    };
    [self verifiedSimpleNetworkCallWithURLString:@"https://httpbin.org/get?foo=foo&bar=bar" withAssertions:assertions];
    [self verifiedSimpleNetworkCallWithURLString:@"https://httpbin.org/get?bar=bar&foo=foo" withAssertions:assertions];
}

- (void)testUnorderedQueryNetworkCallWithThreeQueryParameters {
    // ensure there is only one recording
    XCTAssertNotNil(self.recordings);
    XCTAssertEqual(self.recordings.count, 1);
    UnorderedAssertions assertions = ^void(NSString *headerDate, NSDictionary *args) {
        XCTAssertEqualObjects(headerDate, @"Mon, 29 Jun 2015 20:44:36 GMT");
        NSDictionary *expectedArgsDict = @{
                                           @"bar" : @"bar",
                                           @"foo" : @"foo",
                                           @"baz" : @"baz"
                                           };
        XCTAssertEqualObjects(args, expectedArgsDict);
    };
    [self verifiedSimpleNetworkCallWithURLString:@"https://httpbin.org/get?foo=foo&bar=bar&baz=baz" withAssertions:assertions];
    [self verifiedSimpleNetworkCallWithURLString:@"https://httpbin.org/get?foo=foo&baz=baz&bar=bar" withAssertions:assertions];
    [self verifiedSimpleNetworkCallWithURLString:@"https://httpbin.org/get?bar=bar&baz=baz&foo=foo" withAssertions:assertions];
    [self verifiedSimpleNetworkCallWithURLString:@"https://httpbin.org/get?bar=bar&foo=foo&baz=baz" withAssertions:assertions];
    [self verifiedSimpleNetworkCallWithURLString:@"https://httpbin.org/get?baz=baz&bar=bar&foo=foo" withAssertions:assertions];
    [self verifiedSimpleNetworkCallWithURLString:@"https://httpbin.org/get?baz=baz&foo=foo&bar=bar" withAssertions:assertions];
}

- (void)testAlternateUnorderedQueryNetworkCallWithNoQueryParameters {
    // ensure there is only one recording
    XCTAssertNotNil(self.recordings);
    XCTAssertEqual(self.recordings.count, 1);
    UnorderedAssertions assertions = ^void(NSString *headerDate, NSDictionary *args) {
        XCTAssertEqualObjects(headerDate, @"Mon, 29 Jun 2015 20:44:34 GMT");
        NSDictionary *expectedArgsDict = @{
                             @"bar" : @"",
                             @"foo" : @""
                             };
        XCTAssertEqualObjects(args, expectedArgsDict);
    };
    [self verifiedSimpleNetworkCallWithURLString:@"https://httpbin.org/get?foo&bar" withAssertions:assertions];
    [self verifiedSimpleNetworkCallWithURLString:@"https://httpbin.org/get?bar&foo" withAssertions:assertions];
}

- (void)testSimpleNetworkCallWithNoQuery {
    // ensure there is only one recording
    XCTAssertNotNil(self.recordings);
    XCTAssertEqual(self.recordings.count, 1);
    UnorderedAssertions assertions = ^void(NSString *headerDate, NSDictionary *args) {
        XCTAssertEqualObjects(headerDate, @"Mon, 29 Jun 2015 20:44:35 GMT");
        NSDictionary *expectedArgsDict = @{
                                           };
        XCTAssertEqualObjects(args, expectedArgsDict);
    };
    [self verifiedSimpleNetworkCallWithURLString:@"https://httpbin.org/get" withAssertions:assertions];
}

- (void)testUniqueNetworkCallToProveNotAlwaysMatching {
    [self performUniqueVerifiedNetworkCall:nil];
}

- (void)verifiedSimpleNetworkCallWithURLString:(NSString *)URLString withAssertions:(UnorderedAssertions)assertions {
    NSParameterAssert(URLString);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:URLString]];
    [self performNetworkRequest:request withVerification:^(NSData *data, NSURLResponse *response, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(response);
        XCTAssertNotNil(data);
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        XCTAssertNil(error);
        NSLog(@"dataDict: %@", dataDict);
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (assertions) {
            assertions(httpResponse.allHeaderFields[@"Date"], dataDict[@"args"]);
        }
    }];
}

@end
