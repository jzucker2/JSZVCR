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

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSimpleUnorderedQueryNetworkCallWithQueryParameters {
    // ensure there is only one recording
    XCTAssertNotNil(self.recordings);
    XCTAssertEqual(self.recordings.count, 1);
    [self verifiedSimpleNetworkCallWithURLString:@"https://httpbin.org/get?foo=foo&bar=bar"];
    [self verifiedSimpleNetworkCallWithURLString:@"https://httpbin.org/get?bar=bar&foo=foo"];
}

- (void)testAlternateUnorderedQueryNetworkCallWithNoQueryParameters {
    // ensure there is only one recording
    XCTAssertNotNil(self.recordings);
    XCTAssertEqual(self.recordings.count, 1);
    [self verifiedSimpleNetworkCallWithURLString:@"https://httpbin.org/get?foo&bar"];
    [self verifiedSimpleNetworkCallWithURLString:@"https://httpbin.org/get?bar&foo"];
}

- (void)testSimpleNetworkCallWithNoQuery {
    // ensure there is only one recording
    XCTAssertNotNil(self.recordings);
    XCTAssertEqual(self.recordings.count, 1);
    [self verifiedSimpleNetworkCallWithURLString:@"https://httpbin.org/get"];
}

- (void)testUniqueNetworkCallToProveNotAlwaysMatching {
    [self performUniqueVerifiedNetworkCall:nil];
}

- (void)verifiedSimpleNetworkCallWithURLString:(NSString *)URLString {
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
        NSDictionary *expectedArgsDict;
        NSString *headerFieldsDate;
        if (self.invocation.selector == @selector(testSimpleUnorderedQueryNetworkCallWithQueryParameters)) {
            headerFieldsDate = @"Fri, 26 Jun 2015 09:43:02 GMT";
            expectedArgsDict = @{
                                 @"bar" : @"bar",
                                 @"foo" : @"foo"
                                 };
        } else if (self.invocation.selector == @selector(testAlternateUnorderedQueryNetworkCallWithNoQueryParameters)) {
            headerFieldsDate = @"Fri, 26 Jun 2015 09:43:01 GMT";
            expectedArgsDict = @{
                                 @"bar" : @"",
                                 @"foo" : @""
                                 };
        } else if (self.invocation.selector == @selector(testSimpleNetworkCallWithNoQuery)) {
            headerFieldsDate = @"Fri, 26 Jun 2015 09:43:02 GMT";
            expectedArgsDict = @{
                                 };
        }

        XCTAssertEqualObjects(httpResponse.allHeaderFields[@"Date"], headerFieldsDate);
        XCTAssertEqualObjects(dataDict[@"args"], expectedArgsDict);
    }];
}

@end
