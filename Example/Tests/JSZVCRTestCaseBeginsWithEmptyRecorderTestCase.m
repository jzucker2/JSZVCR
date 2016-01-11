//
//  JSZVCRTestCaseBeginsWithEmptyRecorderTestCase.m
//  JSZVCR
//
//  Created by Jordan Zucker on 6/26/15.
//  Copyright (c) 2015 Jordan Zucker. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <JSZVCR/JSZVCR.h>
#import <JSZVCR/JSZVCRRecorder.h>

#import "XCTestCase+XCTestCase_JSZVCRAdditions.h"

@interface JSZVCRTestCaseBeginsWithEmptyRecorderTestCase : JSZVCRTestCase

@end

@implementation JSZVCRTestCaseBeginsWithEmptyRecorderTestCase

- (void)setUp {
    [JSZVCRRecorder sharedInstance].enabled = YES;
    [self performUniqueVerifiedNetworkCall:nil];
    XCTAssertTrue([JSZVCRRecorder sharedInstance].allRecordings.count > 0);
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    // after setup, we should always have 0 recordings in JSZVCRRecorder memory
    // This should always be 0, in iOS 7 and iOS 8
    XCTAssertEqual([JSZVCRRecorder sharedInstance].allRecordings.count, 0);
}

- (void)testNothing {
    // The real test is in the setUp, just perform a true assert so this class runs and shows in CI logs
    XCTAssert(YES, @"Pass");
}

@end
