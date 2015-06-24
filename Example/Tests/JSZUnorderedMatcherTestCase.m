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

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testRecordedNetworkCall {
    [self verifiedSimpleNetworkCallWithURLString:@"https://httpbin.org/get?foo=foo&bar=bar"];
    [self verifiedSimpleNetworkCallWithURLString:@"https://httpbin.org/get?bar=bar&foo=foo"];
}

- (void)testPerformanceRecordedNetworkCall {
    __weak typeof(self) wself = self;
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        __weak typeof(wself) sself = wself;
        if (!sself) {
            return;
        }
        [sself performSimpleVerifiedNetworkCall:nil];
    }];
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
        XCTAssertEqualObjects(httpResponse.allHeaderFields[@"Date"], @"Wed, 24 Jun 2015 06:16:59 GMT");
        NSDictionary *expectedArgsDict = @{
                                           @"bar" : @"bar",
                                           @"foo" : @"foo"
                                           };
        XCTAssertEqualObjects(dataDict[@"args"], expectedArgsDict);
    }];
}

@end
