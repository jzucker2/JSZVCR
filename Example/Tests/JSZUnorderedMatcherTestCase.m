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
    [self performVerifiedNetworkCall];
}

- (void)testPerformanceRecordedNetworkCall {
    __weak typeof(self) wself = self;
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        __weak typeof(wself) sself = wself;
        if (!sself) {
            return;
        }
        [sself performVerifiedNetworkCall];
    }];
}

@end
