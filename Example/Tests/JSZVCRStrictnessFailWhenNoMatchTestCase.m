//
//  JSZVCRStrictnessFailWhenNoMatchTestCase.m
//  JSZVCR
//
//  Created by Jordan Zucker on 6/24/15.
//  Copyright (c) 2015 Jordan Zucker. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <JSZVCR/JSZVCR.h>
#import <JSZVCR/JSZVCRPlayer.h>

#import "XCTestCase+XCTestCase_JSZVCRAdditions.h"

@interface JSZVCRStrictnessFailWhenNoMatchTestCase : XCTestCase <JSZVCRPlayerDelegate>
@property (nonatomic) JSZVCR *vcr;
@property (nonatomic) NSURLRequest *currentRequest;
@property (nonatomic) BOOL isSettingUp;
@property (nonatomic) BOOL isTearingDown;
@property (nonatomic) NSURLRequest *setUpRequest;
@end

@implementation JSZVCRStrictnessFailWhenNoMatchTestCase

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

- (void)testSucceedsWhenMatch {
    self.currentRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://httpbin.org/get?strictness"]];
    [self performNetworkRequest:self.currentRequest withVerification:^(NSData *data, NSURLResponse *response, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(response);
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        XCTAssertNotNil(httpResponse.allHeaderFields);
        XCTAssertEqualObjects(httpResponse.allHeaderFields[@"Date"], @"Fri, 26 Jun 2015 20:26:29 GMT", @"Date is does not match recording");
        XCTAssertNotNil(data);
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        XCTAssertNil(error);
        XCTAssertNotNil(dataDict);
        XCTAssertNotNil(dataDict[@"args"]);
        XCTAssertEqualObjects(dataDict[@"args"], @{ @"strictness" : @"" });
    }];
}

- (void)testFailsWhenNoMatch {
    self.currentRequest = [self performUniqueVerifiedNetworkCall:nil];
}

#pragma mark - JSZVCRPlayerDelegate

- (void)testCase:(XCTestCase *)testCase withUnmatchedRequest:(NSURLRequest *)request shouldFail:(BOOL)shouldFail {
    XCTAssertFalse(self.isSettingUp);
    XCTAssertFalse(self.isTearingDown);
    if (self.invocation.selector == @selector(testSucceedsWhenMatch)) {
        XCTAssertEqualObjects(self.currentRequest, request);
    }
    XCTAssertEqualObjects(self, testCase);
    if (self.invocation.selector == @selector(testSucceedsWhenMatch)) {
        XCTAssertFalse(shouldFail);
    }
    if (self.invocation.selector == @selector(testFailsWhenNoMatch)) {
        XCTAssertTrue(shouldFail);
    }
}

@end
