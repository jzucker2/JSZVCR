//
//  JSZVCRRecordingCancelledTask.m
//  JSZVCR
//
//  Created by Jordan Zucker on 6/25/15.
//  Copyright (c) 2015 Jordan Zucker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <JSZVCR/JSZVCR.h>
#import <JSZVCR/JSZVCRRecorder.h>
#import <JSZVCR/JSZVCRRecording.h>
#import <JSZVCR/JSZVCRError.h>
#import <JSZVCR/JSZVCRResourceManager.h>

#import "XCTestCase+XCTestCase_JSZVCRAdditions.h"

// Cancelled tasks shouldn't have a cancel BOOL but should just save to error iVar properly

@interface JSZVCRRecordingCancelledTask : JSZVCRTestCase

@end

@implementation JSZVCRRecordingCancelledTask

- (BOOL)isRecording {
    return YES;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    // Stubbing tests until I figure out a way to record on iOS 7
    if ([[[UIDevice currentDevice] systemVersion] hasPrefix:@"7"]) {
        return;
    }
    [self removeExpectedTestCasePlist];
}

- (void)tearDown {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    // Stubbing tests until I figure out a way to record on iOS 7
//    if (![[[UIDevice currentDevice] systemVersion] hasPrefix:@"7"]) {
//        JSZVCRRecording *recording = (JSZVCRRecording *)[JSZVCRRecorder sharedInstance].allRecordings.firstObject;
//        XCTAssertNotNil(recording);
//        XCTAssertTrue(recording.cancelled);
//        XCTAssertNotNil(recording.error);
//        XCTAssertEqualObjects(recording.error.domain, @"NSURLErrorDomain");
//        XCTAssertEqualObjects(recording.error.code, @(-999));
//        XCTAssertEqualObjects(recording.error.userInfo, @{});
//        XCTAssertEqualObjects(recording.error.errorDescription, @"The operation couldn’t be completed. (NSURLErrorDomain error -999.)");
//    }
    [super tearDown];
    NSArray *networkResponses = [JSZVCRResourceManager networkResponsesForTest:self];
    JSZVCRRecording *recording = (JSZVCRRecording *)networkResponses.firstObject;
    XCTAssertNotNil(recording);
    XCTAssertTrue(recording.cancelled);
    XCTAssertNotNil(recording.error);
    XCTAssertEqualObjects(recording.error.domain, @"NSURLErrorDomain");
    XCTAssertEqualObjects(recording.error.code, @(-999));
    XCTAssertEqualObjects(recording.error.userInfo, @{});
    XCTAssertEqualObjects(recording.error.errorDescription, @"The operation couldn’t be completed. (NSURLErrorDomain error -999.)");
    
}

- (void)testCancelledTask {
    // Stubbing tests until I figure out a way to record on iOS 7
    if ([[[UIDevice currentDevice] systemVersion] hasPrefix:@"7"]) {
        return;
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://httpbin.org/delay/10"]];
//    XCTestExpectation *cancelExpectation = [self expectationWithDescription:@"cancel"];
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
        NSLog(@"%@", cancelTask);
//        [cancelExpectation fulfill];
    }];
    XCTAssertNotNil(cancelTask);
    XCTAssertEqual(cancelTask.state, NSURLSessionTaskStateSuspended);
    [cancelTask resume];
    NSLog(@"resume: %@", [NSDate date]);
    XCTAssertEqual(cancelTask.state, NSURLSessionTaskStateRunning);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"timed cancel: %@", [NSDate date]);
        XCTAssertNotNil(cancelTask);
        [cancelTask cancel];
        XCTAssertEqual(cancelTask.state, NSURLSessionTaskStateCanceling);
    });
//    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
//        if (error) {
//            NSLog(@"what error: %@", error);
//            XCTFail(@"failed!");
//        }
//    }];
    [self keyValueObservingExpectationForObject:cancelTask keyPath:@"state" handler:^BOOL(id observedObject, NSDictionary *change) {
        NSLog(@"observedObject: %@", observedObject);
        NSURLSessionDataTask *task = (NSURLSessionDataTask *)observedObject;
        NSLog(@"change: %@", change);
        return (task.state == NSURLSessionTaskStateCompleted);
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        if (error) {
            NSLog(@"what error: %@", error);
            XCTFail(@"failed!");
        }
    }];
}

@end
