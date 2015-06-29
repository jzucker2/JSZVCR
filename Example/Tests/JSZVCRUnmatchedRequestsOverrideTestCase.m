//
//  JSZVCRUnmatchedRequestsOverrideTestCase.m
//  JSZVCR
//
//  Created by Jordan Zucker on 6/29/15.
//  Copyright (c) 2015 Jordan Zucker. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <JSZVCR/JSZVCR.h>
#import <JSZVCR/JSZVCRPlayer.h>

#import "XCTestCase+XCTestCase_JSZVCRAdditions.h"

static NSString * const kJSZVCRWhitelistedURLString = @"https://httpbin.org/get?unmatched";

@interface JSZVCRAllowSpecificLiveRequestMatcher : JSZVCRUnorderedQueryMatcher
@end

@implementation JSZVCRAllowSpecificLiveRequestMatcher

- (BOOL)shouldAllowUnmatchedRequest:(NSURLRequest *)request {
    if ([request.URL.absoluteString isEqualToString:kJSZVCRWhitelistedURLString]) {
        return YES;
    }
    return NO;
}

@end

@interface JSZVCRUnmatchedRequestsOverrideTestCase : XCTestCase <JSZVCRPlayerDelegate>
@property (nonatomic) JSZVCR *vcr;
@property (nonatomic) NSURLRequest *currentRequest;
@property (nonatomic) BOOL isSettingUp;
@property (nonatomic) BOOL isTearingDown;
@property (nonatomic) NSURLRequest *setUpRequest;
@end

@implementation JSZVCRUnmatchedRequestsOverrideTestCase

- (void)setUp {
    self.isSettingUp = YES;
    self.isTearingDown = NO;
    // this makes sure that we are not checking recorded calls that happen outside of a test (not recording in set up or tear down)
    [self performUniqueVerifiedNetworkCall:nil];
    // everything that happens after this is part of a normal test case (code should be cleaned up and consolidated)
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.vcr = [JSZVCR vcrWithMatcherClass:[JSZVCRSimpleURLMatcher class]];
    self.vcr.playerDelegate = self;
    self.vcr.currentTestCase = self;
    self.vcr.matchFailStrictness = JSZVCRTestingStrictnessFailWhenNoMatch;
//    [self.vcr swizzleNSURLSessionClasses];
    self.vcr.recording = NO;
    self.isSettingUp = NO;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.isTearingDown = YES;
    [self.vcr removeAllNetworkResponses];
    if (self.vcr.isRecording) {
        [self.vcr saveTestRecordings];
    }
    self.vcr.playerDelegate = nil;
    self.vcr = nil;
    self.currentRequest = nil;
    // everything up until here happens during a normal JSZVCRTestCase
    [super tearDown];
    // make sure that anything that happens after teardown is not checked by performing unique network call
    [self performUniqueVerifiedNetworkCall:nil];
    self.isTearingDown = NO;
}

- (void)testSucceedsWhenMatchAndJSZVCRTestingStrictnessFailWhenNoMatch {
    self.vcr.matchFailStrictness = JSZVCRTestingStrictnessFailWhenNoMatch;
    self.currentRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://httpbin.org/get?strictness"]];
    [self performNetworkRequest:self.currentRequest withVerification:^(NSData *data, NSURLResponse *response, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(response);
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        XCTAssertNotNil(httpResponse.allHeaderFields);
        XCTAssertEqualObjects(httpResponse.allHeaderFields[@"Date"], @"Mon, 29 Jun 2015 19:22:20 GMT", @"Date is does not match recording");
        XCTAssertNotNil(data);
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        XCTAssertNil(error);
        XCTAssertNotNil(dataDict);
        XCTAssertNotNil(dataDict[@"args"]);
        XCTAssertEqualObjects(dataDict[@"args"], @{ @"strictness" : @"" });
    }];
}

- (void)testFailsWhenNoMatchAndJSZVCRTestingStrictnessFailWhenNoMatch {
    self.vcr.matchFailStrictness = JSZVCRTestingStrictnessFailWhenNoMatch;
    self.currentRequest = [self performUniqueVerifiedNetworkCall:nil];
}

- (void)testSucceedsWhenNoMatchWithWhitelistedRequestAndJSZVCRTestingStrictnessFailWhenNoMatch {
    self.vcr.matchFailStrictness = JSZVCRTestingStrictnessFailWhenNoMatch;
    self.currentRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:kJSZVCRWhitelistedURLString]];
    [self performNetworkRequest:self.currentRequest withVerification:^(NSData *data, NSURLResponse *response, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(response);
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        XCTAssertNotNil(httpResponse.allHeaderFields);
        XCTAssertEqualObjects(httpResponse.allHeaderFields[@"Date"], @"Mon, 29 Jun 2015 19:22:21 GMT", @"Date is does not match recording");
        XCTAssertNotNil(data);
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        XCTAssertNil(error);
        XCTAssertNotNil(dataDict);
        XCTAssertNotNil(dataDict[@"args"]);
        XCTAssertEqualObjects(dataDict[@"args"], @{ @"unmatched" : @"" });
    }];
}

- (void)testSucceedsWhenMatchAndJSZVCRTestingStrictnessNone {
    self.vcr.matchFailStrictness = JSZVCRTestingStrictnessNone;
    self.currentRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://httpbin.org/get?strictness"]];
    [self performNetworkRequest:self.currentRequest withVerification:^(NSData *data, NSURLResponse *response, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(response);
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        XCTAssertNotNil(httpResponse.allHeaderFields);
        XCTAssertEqualObjects(httpResponse.allHeaderFields[@"Date"], @"Mon, 29 Jun 2015 19:22:20 GMT", @"Date is does not match recording");
        XCTAssertNotNil(data);
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        XCTAssertNil(error);
        XCTAssertNotNil(dataDict);
        XCTAssertNotNil(dataDict[@"args"]);
        XCTAssertEqualObjects(dataDict[@"args"], @{ @"strictness" : @"" });
    }];
}

- (void)testSucceedsWhenNoMatchAndJSZVCRTestingStrictnessNone {
    self.vcr.matchFailStrictness = JSZVCRTestingStrictnessNone;
    self.currentRequest = [self performUniqueVerifiedNetworkCall:nil];
}

- (void)testSucceedsWhenNoMatchWithWhitelistedRequestAndJSZVCRTestingStrictnessNone {
    self.vcr.matchFailStrictness = JSZVCRTestingStrictnessNone;
    self.currentRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:kJSZVCRWhitelistedURLString]];
    [self performNetworkRequest:self.currentRequest withVerification:^(NSData *data, NSURLResponse *response, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(response);
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        XCTAssertNotNil(httpResponse.allHeaderFields);
        XCTAssertEqualObjects(httpResponse.allHeaderFields[@"Date"], @"Mon, 29 Jun 2015 19:22:21 GMT", @"Date is does not match recording");
        XCTAssertNotNil(data);
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        XCTAssertNil(error);
        XCTAssertNotNil(dataDict);
        XCTAssertNotNil(dataDict[@"args"]);
        XCTAssertEqualObjects(dataDict[@"args"], @{ @"unmatched" : @"" });
    }];
}

#pragma mark - JSZVCRPlayerDelegate

- (void)testCase:(XCTestCase *)testCase withUnmatchedRequest:(NSURLRequest *)request shouldFail:(BOOL)shouldFail {
    XCTAssertFalse(self.isSettingUp);
    XCTAssertFalse(self.isTearingDown);
    XCTAssertEqualObjects(self, testCase);
    if (self.invocation.selector == @selector(testSucceedsWhenMatchAndJSZVCRTestingStrictnessFailWhenNoMatch)) {
        XCTAssertFalse(shouldFail);
        XCTAssertEqualObjects(self.currentRequest, request);
    }
    if (self.invocation.selector == @selector(testFailsWhenNoMatchAndJSZVCRTestingStrictnessFailWhenNoMatch)) {
        XCTAssertTrue(shouldFail);
    }
    if (self.invocation.selector == @selector(testSucceedsWhenNoMatchWithWhitelistedRequestAndJSZVCRTestingStrictnessFailWhenNoMatch)) {
        XCTAssertFalse(shouldFail);
    }
    
    if (self.invocation.selector == @selector(testSucceedsWhenMatchAndJSZVCRTestingStrictnessNone)) {
        XCTAssertFalse(shouldFail);
        XCTAssertEqualObjects(self.currentRequest, request);
    }
    if (self.invocation.selector == @selector(testSucceedsWhenNoMatchAndJSZVCRTestingStrictnessNone)) {
        XCTAssertFalse(shouldFail);
    }
    if (self.invocation.selector == @selector(testSucceedsWhenNoMatchWithWhitelistedRequestAndJSZVCRTestingStrictnessNone)) {
        XCTAssertFalse(shouldFail);
    }
}

@end
