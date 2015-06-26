//
//  JSZVCRRequestTestCase.m
//  JSZVCR
//
//  Created by Jordan Zucker on 6/26/15.
//  Copyright (c) 2015 Jordan Zucker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <JSZVCR/JSZVCRRequest.h>

#import "XCTestCase+XCTestCase_JSZVCRAdditions.h"

@interface JSZVCRRequestTestCase : XCTestCase

@end

@implementation JSZVCRRequestTestCase

- (void)testBasicRequestGeneration {
    // This is an example of a functional test case.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://httpbin.org/get"]];
    NSError *JSONSerializationError;
    NSData *httpBodyData = [NSJSONSerialization dataWithJSONObject:@[@"test"] options:NSJSONWritingPrettyPrinted error:&JSONSerializationError];
    XCTAssertNil(JSONSerializationError);
    request.HTTPBody = httpBodyData;
    request.HTTPShouldUsePipelining = YES;
    NSURLSessionTask *sampleTask = [self taskForNetworkRequest:request withVerification:nil];
    XCTAssertNotNil(sampleTask);
    
    JSZVCRRequest *recordingRequest = [JSZVCRRequest requestWithTask:sampleTask];
    XCTAssertNotNil(recordingRequest);
    NSDictionary *recordingDict = recordingRequest.dictionaryRepresentation;
    XCTAssertNotNil(recordingDict);
    NSDictionary *currentRequestDict = recordingDict[@"currentRequest"];
    XCTAssertNotNil(currentRequestDict);
    [self validateRequestDictionary:currentRequestDict against:request];
    NSDictionary *originalRequestDict = recordingDict[@"originalRequest"];
    XCTAssertNotNil(originalRequestDict);
    [self validateRequestDictionary:originalRequestDict against:request];
    
    
}

- (void)validateRequestDictionary:(NSDictionary *)requestDictionary against:(NSURLRequest *)request {
    XCTAssertNotNil(requestDictionary);
    XCTAssertEqualObjects(requestDictionary[@"HTTPShouldUsePipelining"], @(request.HTTPShouldUsePipelining));
    XCTAssertEqualObjects(requestDictionary[@"URL"], request.URL.absoluteString);
    if ([[[UIDevice currentDevice] systemVersion] hasPrefix:@"7"]) {
        return;
    }
    // this is flakey on iOS 7, I think iOS 7 strips the HTTPBody from the originalRequest when it becomes the currentRequest
    XCTAssertEqualObjects(requestDictionary[@"HTTPBody"], request.HTTPBody);
}

@end
