//
//  JSZVCRAFNetworkingRecorderTestCase.m
//  JSZVCR
//
//  Created by Jordan Zucker on 6/25/15.
//  Copyright (c) 2015 Jordan Zucker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <JSZVCR/JSZVCR.h>
#import <JSZVCR/JSZVCRRecorder.h>
#import <AFNetworking/AFNetworking.h>

#import "XCTestCase+XCTestCase_JSZVCRAdditions.h"

@interface JSZVCRAFNetworkingRecorderTestCase : JSZVCRTestCase

@end

@implementation JSZVCRAFNetworkingRecorderTestCase

- (BOOL)isRecording {
    return YES;
}

- (void)setUp {
    // Stubbing tests until I figure out a way to record on iOS 7
    if (![[[UIDevice currentDevice] systemVersion] hasPrefix:@"8"]) {
        return;
    }
    [[NSURLSession sharedSession] invalidateAndCancel];
    [[NSURLSession sharedSession] getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        NSLog(@"dataTasks: %@", dataTasks);
    }];
    [super setUp];
    [self removeExpectedTestCasePlist];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Stubbing tests until I figure out a way to record on iOS 7
    if (![[[UIDevice currentDevice] systemVersion] hasPrefix:@"8"]) {
        return;
    }
    // Copy recordings serialization before we save (save causes a reset)
    NSArray *allRecordingsAtEndOfRun = [[JSZVCRRecorder sharedInstance].allRecordingsForPlist copy];
    XCTAssertEqual(allRecordingsAtEndOfRun.count, 2);
    [super tearDown];
    // verify save caused a reset on recordings
    XCTAssertFalse([JSZVCRRecorder sharedInstance].allRecordings.count);
    // Call file verification after super teardown to ensure file has been saved as expected.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *expectedFilePathForTestCasePlist = [self filePathForTestCasePlist];
    XCTAssertTrue([fileManager fileExistsAtPath:expectedFilePathForTestCasePlist]);
    // Now verify contents
    NSArray *networkResponses = [[NSArray alloc] initWithContentsOfFile:expectedFilePathForTestCasePlist];
    XCTAssertEqual(networkResponses.count, 2);
    XCTAssertEqualObjects(allRecordingsAtEndOfRun, networkResponses);
    [self assertIsEqualFirstRecording:allRecordingsAtEndOfRun[0] secondRecording:allRecordingsAtEndOfRun[1]];
    [self assertIsEqualFirstRecording:networkResponses[0] secondRecording:networkResponses[1]];
    [self assertIsEqualFirstRecording:allRecordingsAtEndOfRun[0] secondRecording:networkResponses[0]];
}

// just check data and requests outside of response date
- (void)assertIsEqualFirstRecording:(NSDictionary *)firstRecording secondRecording:(NSDictionary *)secondRecording {
    // first compare data
    XCTAssertNotNil(firstRecording[@"data"][@"json"]);
    NSDictionary *firstJSON = firstRecording[@"data"][@"json"];
    XCTAssertNotNil(secondRecording[@"data"][@"json"]);
    NSDictionary *secondJSON = secondRecording[@"data"][@"json"];
    // contents were already verified in test, just confirming these are equivalent
    XCTAssertNotNil(firstJSON[@"args"]);
    XCTAssertEqualObjects(firstJSON[@"args"], secondJSON[@"args"]);
    XCTAssertNotNil(firstJSON[@"headers"]);
    XCTAssertNotNil(secondJSON[@"headers"]);
    XCTAssertNotEqual([firstJSON[@"headers"] count], 0);
    XCTAssertNotEqual([secondJSON[@"headers"] count], 0);
    XCTAssertEqualObjects(firstJSON[@"origin"], secondJSON[@"origin"]);
    XCTAssertEqualObjects(firstJSON[@"url"], secondJSON[@"url"]);
    
    // now compare requests
    XCTAssertNotNil(firstRecording[@"request"][@"currentRequest"]);
    XCTAssertNotNil(firstRecording[@"request"][@"originalRequest"]);
    XCTAssertNotNil(secondRecording[@"request"][@"currentRequest"]);
    XCTAssertNotNil(secondRecording[@"request"][@"originalRequest"]);
    NSDictionary *firstCurrentRequest = firstRecording[@"request"][@"currentRequest"];
    NSDictionary *firstOriginalRequest = firstRecording[@"request"][@"originalRequest"];
    NSDictionary *secondCurrentRequest = secondRecording[@"request"][@"currentRequest"];
    NSDictionary *secondOriginalRequest = secondRecording[@"request"][@"originalRequest"];
    XCTAssertEqualObjects(firstCurrentRequest[@"HTTPMethod"], secondCurrentRequest[@"HTTPMethod"]);
    XCTAssertEqualObjects(firstCurrentRequest[@"HTTPShouldHandleCookies"], secondCurrentRequest[@"HTTPShouldHandleCookies"]);
    XCTAssertEqualObjects(firstCurrentRequest[@"URL"], secondCurrentRequest[@"URL"]);
    XCTAssertEqualObjects(firstCurrentRequest[@"allowsCellularAccess"], secondCurrentRequest[@"allowsCellularAccess"]);
    XCTAssertEqualObjects(firstCurrentRequest[@"timeoutInterval"], secondCurrentRequest[@"timeoutInterval"]);
    XCTAssertNotNil(firstCurrentRequest[@"allHTTPHeaderFields"]);
    XCTAssertNotNil(secondCurrentRequest[@"allHTTPHeaderFields"]);
    XCTAssertNotEqual([firstCurrentRequest[@"allHTTPHeaderFields"] count], 0);
    XCTAssertNotEqual([secondCurrentRequest[@"allHTTPHeaderFields"] count], 0);
    XCTAssertEqualObjects(firstOriginalRequest[@"HTTPMethod"], secondOriginalRequest[@"HTTPMethod"]);
    XCTAssertEqualObjects(firstOriginalRequest[@"HTTPShouldHandleCookies"], secondOriginalRequest[@"HTTPShouldHandleCookies"]);
    XCTAssertEqualObjects(firstOriginalRequest[@"URL"], secondOriginalRequest[@"URL"]);
    XCTAssertEqualObjects(firstOriginalRequest[@"allowsCellularAccess"], secondOriginalRequest[@"allowsCellularAccess"]);
    XCTAssertEqualObjects(firstOriginalRequest[@"timeoutInterval"], secondOriginalRequest[@"timeoutInterval"]);
    
    // now verify response
    XCTAssertNotNil(firstRecording[@"response"][@"response"]);
    XCTAssertNotNil(secondRecording[@"response"][@"response"]);
    NSDictionary *firstResponse = firstRecording[@"response"][@"response"];
    NSDictionary *secondResponse = secondRecording[@"response"][@"response"];
    XCTAssertEqualObjects(firstResponse[@"MIMEType"], secondResponse[@"MIMEType"]);
    XCTAssertEqualObjects(firstResponse[@"URL"], secondResponse[@"URL"]);
    XCTAssertEqualWithAccuracy([firstResponse[@"expectedContentLength"] integerValue], [secondResponse[@"expectedContentLength"] integerValue], 75);
    XCTAssertEqualObjects(firstResponse[@"statusCode"], secondResponse[@"statusCode"]);
    XCTAssertEqualObjects(firstResponse[@"suggestedFileName"], secondResponse[@"suggestedFileName"]);
    XCTAssertNotNil(firstResponse[@"allHeaderFields"]);
    XCTAssertNotNil(secondResponse[@"allHeaderFields"]);
    XCTAssertNotEqual([firstResponse[@"allHeaderFields"] count], 0);
    XCTAssertNotEqual([secondResponse[@"allHeaderFields"] count], 0);
    
}

- (void)testAFNetworkingRecordingNetworkCall {
    // Stubbing tests until I figure out a way to record on iOS 7
    if (![[[UIDevice currentDevice] systemVersion] hasPrefix:@"8"]) {
        return;
    }
    [self performSimpleVerifiedNetworkCall:nil];
    XCTestExpectation *afGetExpectation = [self expectationWithDescription:@"af get"];
    NSString *requestString = @"https://httpbin.org/get";
    NSDictionary *parameters = @{
                                 @"test" : @"test"
                                 };
    [[AFHTTPSessionManager manager] GET:requestString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        XCTAssertNotNil(task);
        XCTAssertNotNil(responseObject);
        XCTAssertNotNil(responseObject[@"args"]);
        XCTAssertEqualObjects(responseObject[@"args"], parameters);
        XCTAssertNotNil(responseObject[@"headers"]);
        XCTAssertNotEqual([responseObject[@"headers"] count], 0);
        XCTAssertNotNil(responseObject[@"origin"]);
        XCTAssertEqualObjects(responseObject[@"url"], @"https://httpbin.org/get?test=test");
        XCTAssertNotNil(task.response);
        XCTAssertNotNil(task.currentRequest);
        XCTAssertNotNil(task.originalRequest);
        [afGetExpectation fulfill];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        XCTAssertNil(error);
        [afGetExpectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
}

@end
