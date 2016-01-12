//
//  JSZVCRRecordingCancelledTask.m
//  JSZVCR
//
//  Created by Jordan Zucker on 6/25/15.
//  Copyright (c) 2015 Jordan Zucker. All rights reserved.
//

#import <JSZVCR/JSZVCR.h>
#import <JSZVCR/JSZVCRRecorder.h>
#import <JSZVCR/JSZVCRRecording.h>
#import <JSZVCR/NSURLSessionTask+JSZVCRAdditions.h>

#import "XCTestCase+XCTestCase_JSZVCRAdditions.h"

// Cancelled tasks shouldn't have a cancel BOOL but should just save to error iVar properly

@interface JSZVCRRecordingCancelledTask : JSZVCRTestCase
@property (nonatomic, copy) NSString *cancelledTaskUniqueIdentifier;
@end

@implementation JSZVCRRecordingCancelledTask

- (BOOL)isRecording {
    return YES;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [self removeExpectedTestCasePlist];
}

- (void)tearDown {
    JSZVCRRecording *recording = (JSZVCRRecording *)[JSZVCRRecorder sharedInstance].allRecordings.firstObject;
    XCTAssertNotNil(recording);
    XCTAssertTrue(recording.cancelled);
    XCTAssertNotNil(recording.uniqueIdentifier);
    XCTAssertEqualObjects(recording.uniqueIdentifier, self.cancelledTaskUniqueIdentifier, @"The uuid from the recording should match the cancelled task just recorded.");
    [super tearDown];
}

- (void)testCancelledTask {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://httpbin.org/delay/10"]];
    XCTestExpectation *cancelExpectation = [self expectationWithDescription:@"cancel"];
    NSURLSessionTask *cancelTask = [self taskForNetworkRequest:request withVerification:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"cancelTask verification: %@", [NSDate date]);
        NSLog(@"response: %@", response);
        XCTAssertEqual(data.length, 0);
        XCTAssertNil(response);
        XCTAssertNotNil(error);
        XCTAssertEqualObjects(error.domain, NSURLErrorDomain);
        XCTAssertEqual(error.code, -999);
        XCTAssertEqualObjects(error.localizedDescription, @"cancelled");
        XCTAssertNotNil(error.userInfo);
        [cancelExpectation fulfill];
    }];
    XCTAssertNotNil(cancelTask);
    XCTAssertEqual(cancelTask.state, NSURLSessionTaskStateSuspended);
    [cancelTask resume];
    NSLog(@"resumed at: %@", [NSDate date]);
    XCTAssertEqual(cancelTask.state, NSURLSessionTaskStateRunning);
    __weak typeof (self) wself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof (wself) sself = wself;
        NSLog(@"timed cancel: %@", [NSDate date]);
        XCTAssertNotNil(cancelTask);
        [cancelTask cancel];
        sself.cancelledTaskUniqueIdentifier = cancelTask.globallyUniqueIdentifier;
        XCTAssertNotNil(cancelTask.globallyUniqueIdentifier);
        XCTAssertNotEqualObjects(cancelTask.globallyUniqueIdentifier, @"");
        XCTAssertEqual(cancelTask.state, NSURLSessionTaskStateCanceling);
    });
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        if (error) {
            NSLog(@"what error: %@", error);
            XCTFail(@"failed!");
        }
    }];
}

@end
