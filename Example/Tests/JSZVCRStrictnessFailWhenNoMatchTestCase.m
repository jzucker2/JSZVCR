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
@end

@implementation JSZVCRStrictnessFailWhenNoMatchTestCase

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.vcr = [JSZVCR vcrWithMatcherClass:[JSZVCRSimpleURLMatcher class]];
    self.vcr.playerDelegate = self;
    self.vcr.currentTestCase = self;
    self.vcr.matchFailStrictness = JSZVCRTestingStrictnessFailWhenNoMatch;
//    [self.vcr swizzleNSURLSessionClasses];
    self.vcr.recording = NO;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [self.vcr removeAllNetworkResponses];
    if (self.vcr.isRecording) {
        [self.vcr saveTestRecordings];
    }
    self.vcr.playerDelegate = nil;
    self.vcr = nil;
    self.currentRequest = nil;
    [super tearDown];
}

- (void)testSucceedsWhenMatch {
    self.currentRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://httpbin.org/get?strictness"]];
    [self performNetworkRequest:self.currentRequest withVerification:^(NSData *data, NSURLResponse *response, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(response);
        XCTAssertNotNil(data);
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        XCTAssertNil(error);
        XCTAssertNotNil(dataDict);
        XCTAssertNotNil(dataDict[@"args"]);
        XCTAssertEqualObjects(dataDict[@"args"], @{ @"strictness" : @"" });
    }];
}

- (void)testFailsWhenNoMatch {
    [self performUniqueVerifiedNetworkCall:nil];
}

#pragma mark - JSZVCRPlayerDelegate

- (void)testCase:(XCTestCase *)testCase withUnmatchedRequest:(NSURLRequest *)request shouldFail:(BOOL)shouldFail {
    XCTAssertEqualObjects(self.currentRequest, request);
    XCTAssertEqualObjects(self, testCase);
    if (self.invocation.selector == @selector(testSucceedsWhenMatch)) {
        XCTAssertFalse(shouldFail);
    }
    if (self.invocation.selector == @selector(testFailsWhenNoMatch)) {
        XCTAssertTrue(shouldFail);
    }
}

@end
