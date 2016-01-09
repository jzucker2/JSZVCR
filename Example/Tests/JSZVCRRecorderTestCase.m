//
//  JSZVCRRecorderTestCase.m
//  JSZVCR
//
//  Created by Jordan Zucker on 6/15/15.
//  Copyright (c) 2015 Jordan Zucker. All rights reserved.
//

#import <JSZVCR/JSZVCR.h>
#import <JSZVCR/JSZVCRRecorder.h>

#import "XCTestCase+XCTestCase_JSZVCRAdditions.h"

@interface JSZVCRRecorderTestCase : JSZVCRTestCase
@end

@implementation JSZVCRRecorderTestCase

#if TARGET_OS_IPHONE
- (BOOL)isRecording {
    return YES;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    // Stubbing tests until I figure out a way to record on iOS 7 or 9
    if (![[[UIDevice currentDevice] systemVersion] hasPrefix:@"8"]) {
        return;
    }
    [self removeExpectedTestCasePlist];
}

- (void)tearDown {
    // Stubbing tests until I figure out a way to record on iOS 7 or 9
    if (![[[UIDevice currentDevice] systemVersion] hasPrefix:@"8"]) {
        return;
    }
    // Copy recordings serialization before we save (save causes a reset)
    NSArray *allRecordingsAtEndOfRun = [[JSZVCRRecorder sharedInstance].allRecordingsForPlist copy];
    XCTAssertEqual(allRecordingsAtEndOfRun.count, 1);
    [super tearDown];
    // verify save caused a reset on recordings
    XCTAssertFalse([JSZVCRRecorder sharedInstance].allRecordings.count);
    // Call file verification after super teardown to ensure file has been saved as expected.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *expectedFilePathForTestCasePlist = [self filePathForTestCasePlist];
    XCTAssertTrue([fileManager fileExistsAtPath:expectedFilePathForTestCasePlist]);
    // Now verify contents
    NSArray *networkResponses = [[NSArray alloc] initWithContentsOfFile:expectedFilePathForTestCasePlist];
    XCTAssertEqual(networkResponses.count, 1);
    XCTAssertEqualObjects(allRecordingsAtEndOfRun, networkResponses);
}

- (void)testRecordingNetworkCall {
    // Stubbing tests until I figure out a way to record on iOS 7 or 9
    if (![[[UIDevice currentDevice] systemVersion] hasPrefix:@"8"]) {
        return;
    }
    [self performSimpleVerifiedNetworkCall:nil];
}

#endif

@end
