//
//  JSZDefaultTestCase.m
//  JSZVCR
//
//  Created by Jordan Zucker on 6/24/15.
//  Copyright (c) 2015 Jordan Zucker. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <JSZVCR/JSZVCR.h>
#import <JSZVCR/JSZVCRRecorder.h>

#import "XCTestCase+XCTestCase_JSZVCRAdditions.h"

@interface JSZDefaultTestCase : JSZVCRTestCase
@end

@implementation JSZDefaultTestCase

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *expectedFilePathForTestCasePlist = [self filePathForTestCasePlist];
    if ([fileManager fileExistsAtPath:expectedFilePathForTestCasePlist]) {
        NSError *removeTestRunCodeError;
        [fileManager removeItemAtPath:expectedFilePathForTestCasePlist error:&removeTestRunCodeError];
        XCTAssertNil(removeTestRunCodeError);
    }
}

- (void)tearDown {
    // Make sure nothing was recorded
    XCTAssertEqual([JSZVCRRecorder sharedInstance].allRecordings.count, 1);
    [super tearDown];
    // Call file verification after super teardown to ensure file was not saved
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *expectedFilePathForTestCasePlist = [self filePathForTestCasePlist];
    XCTAssertTrue([fileManager fileExistsAtPath:expectedFilePathForTestCasePlist]);
}

- (void)testNormalTest {
    XCTAssertEqual([self matchingFailStrictness], JSZVCRTestingStrictnessNone);
    XCTAssertEqual([self isRecording], YES);
    XCTAssertEqualObjects([self matcherClass], [JSZVCRSimpleURLMatcher class]);
    [self performSimpleVerifiedNetworkCall:nil];
}

@end
