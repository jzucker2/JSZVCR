//
//  JSZVCRRecorderTestCase.m
//  JSZVCR
//
//  Created by Jordan Zucker on 6/15/15.
//  Copyright (c) 2015 Jordan Zucker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JSZVCR/JSZVCR.h>
#import <JSZVCR/JSZVCRRecorder.h>

#import "XCTestCase+XCTestCase_JSZVCRAdditions.h"

@interface JSZVCRRecorderTestCase : JSZVCRTestCase
@property (nonatomic) NSData *lastData;
@property (nonatomic) NSURLResponse *lastResponse;
@end

@implementation JSZVCRRecorderTestCase

- (BOOL)isRecording {
    return YES;
}

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
    // Copy recordings serialization before we save (save causes a reset)
    NSArray *allRecordingsAtEndOfRun = [[JSZVCRRecorder sharedInstance].allRecordingsForPlist copy];
    [super tearDown];
    // verify save caused a reset on recordings
    XCTAssertFalse([JSZVCRRecorder sharedInstance].allRecordings.count);
    // Call file verification after super teardown to ensure file has been saved as expected.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *expectedFilePathForTestCasePlist = [self filePathForTestCasePlist];
    XCTAssertTrue([fileManager fileExistsAtPath:expectedFilePathForTestCasePlist]);
    // Now verify contents
    NSArray *networkResponses = [[NSArray alloc] initWithContentsOfFile:expectedFilePathForTestCasePlist];
    XCTAssertNotNil(networkResponses);
    XCTAssertEqualObjects(allRecordingsAtEndOfRun, networkResponses);
}

- (void)testRecordingNetworkCall {
    __weak typeof (self) wself = self;
    [self performSimpleVerifiedNetworkCall:^(NSData *data, NSURLResponse *response, NSError *error) {
        __strong typeof (wself) sself = wself;
        if (!sself) {
            return;
        }
        sself.lastData = data;
        sself.lastResponse = response;
    }];
}

- (NSString *)filePathForTestSuiteBundle {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *bundleName = [NSString stringWithFormat:@"%@.bundle", NSStringFromClass(self.class)];
    return [documentsPath stringByAppendingPathComponent:bundleName];
}

- (NSString *)filePathForTestCasePlist {
    NSString *currentTestCaseMethod = NSStringFromSelector(self.invocation.selector);
    NSString *plistFileName = [NSString stringWithFormat:@"%@.plist", currentTestCaseMethod];
    return [[self filePathForTestSuiteBundle] stringByAppendingPathComponent:plistFileName];
}

@end
