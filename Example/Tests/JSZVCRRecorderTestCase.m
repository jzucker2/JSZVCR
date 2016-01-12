//
//  JSZVCRRecorderTestCase.m
//  JSZVCR
//
//  Created by Jordan Zucker on 6/15/15.
//  Copyright (c) 2015 Jordan Zucker. All rights reserved.
//

#import <JSZVCR/JSZVCR.h>
#import <JSZVCR/JSZVCRRecorder.h>
#import <JSZVCR/JSZVCRRecording.h>
#import <JSZVCR/NSURLSessionTask+JSZVCRAdditions.h>

#import "XCTestCase+XCTestCase_JSZVCRAdditions.h"

@interface JSZVCRRecorderTestCase : JSZVCRTestCase
@property (nonatomic, copy) NSString *recordingNetworkCallUniqueIdentifier;
@end

@implementation JSZVCRRecorderTestCase

- (BOOL)isRecording {
    return YES;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [self removeExpectedTestCasePlist];
}

- (void)tearDown {
    // Copy recordings serialization before we save (save causes a reset)
    NSArray *allRecordingsAtEndOfRun = [[JSZVCRRecorder sharedInstance].allRecordingsForPlist copy];
    XCTAssertEqual(allRecordingsAtEndOfRun.count, 1);
    // Check that NSURLSessionTask has the same globally unique identifier for task, recording, and plist
    XCTAssertEqualObjects(allRecordingsAtEndOfRun[0][@"uniqueIdentifier"], self.recordingNetworkCallUniqueIdentifier);
    JSZVCRRecording *recording = [JSZVCRRecorder sharedInstance].allRecordings.firstObject;
    XCTAssertNotNil(recording);
    // Ensure recording has the proper unique identifier
    XCTAssertEqualObjects(recording.uniqueIdentifier, self.recordingNetworkCallUniqueIdentifier);
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
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://httpbin.org/get?test=test"]];
    __block XCTestExpectation *recordingExpectation = [self expectationWithDescription:@"recordingExpectation"];
    __block NSURLSessionTask *recordingTask = [self taskForNetworkRequest:request withVerification:^(NSData *data, NSURLResponse *response, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(response);
        XCTAssertNotNil(data);
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        XCTAssertNil(error);
        XCTAssertEqualObjects(dataDict[@"args"], @{@"test" : @"test"});
        [recordingExpectation fulfill];
    }];
    XCTAssertNotNil(recordingTask);
    XCTAssertEqual(recordingTask.state, NSURLSessionTaskStateSuspended);
    [recordingTask resume];
    NSLog(@"resumed at: %@", [NSDate date]);
    XCTAssertEqual(recordingTask.state, NSURLSessionTaskStateRunning);
    __weak typeof(self) wself = self;
    [self waitForExpectationsWithTimeout:5 handler:^(NSError * _Nullable error) {
        XCTAssertNil(error);
        __weak typeof(wself) sself = wself;
        sself.recordingNetworkCallUniqueIdentifier = recordingTask.globallyUniqueIdentifier;
    }];
}

@end
