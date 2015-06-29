//
//  JSZPlayerTestCase.m
//  JSZVCR
//
//  Created by Jordan Zucker on 6/15/15.
//  Copyright (c) 2015 Jordan Zucker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JSZVCR/JSZVCR.h>

#import "XCTestCase+XCTestCase_JSZVCRAdditions.h"

@interface JSZPlayerTestCase : JSZVCRTestCase
@end

@implementation JSZPlayerTestCase

- (BOOL)isRecording {
    return NO;
}

- (void)setUp {
    [super setUp];
    XCTAssertNotNil(self.recordings);
    XCTAssertNotEqual(self.recordings.count, 0);
}

- (void)tearDown {
    XCTAssertNotEqual(self.recordings.count, 0);
    [super tearDown];
}

- (void)testRecordedNetworkCall {
    // We should ALWAYS have recordings loaded at the beginning of a test
    XCTAssertNotEqual(self.recordings.count, 0);
    [self performSimpleVerifiedNetworkCall:nil];
}

- (void)DISABLED_testRedirectedRecordedNetworkCall {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://httpbin.org/redirect/6"]];
    [self performNetworkRequest:request withVerification:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"");
    }];
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

@end
