//
//  XCTestCase+XCTestCase_JSZVCRAdditions.m
//  JSZVCR
//
//  Created by Jordan Zucker on 6/12/15.
//  Copyright (c) 2015 Jordan Zucker. All rights reserved.
//

#import "XCTestCase+XCTestCase_JSZVCRAdditions.h"

@implementation XCTestCase (XCTestCase_JSZVCRAdditions)

- (NSURLSessionTask *)taskForNetworkRequest:(NSURLRequest *)request withVerification:(void (^)(NSData *, NSURLResponse *, NSError *))verifications {
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *basicGetTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (verifications) {
            verifications(data, response, error);
        }
    }];
    return basicGetTask;
}

- (NSURLRequest *)performSimpleVerifiedNetworkCall:(void (^)(NSData *, NSURLResponse *, NSError *))extraVerifications {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://httpbin.org/get?test=test"]];
    [self performNetworkRequest:request withVerification:^(NSData *data, NSURLResponse *response, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(response);
        XCTAssertNotNil(data);
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        XCTAssertNil(error);
        XCTAssertEqualObjects(dataDict[@"args"], @{@"test" : @"test"});
        if (extraVerifications) {
            extraVerifications(data, response, error);
        }
    }];
    return request;
}

- (NSURLRequest *)performUniqueVerifiedNetworkCall:(void (^)(NSURLRequest *request, NSData *, NSURLResponse *, NSError *))extraVerifications {
    NSString *UUIDString = [NSUUID UUID].UUIDString;
    NSString *uniqueRequest = [NSString stringWithFormat:@"https://httpbin.org/get?%@", UUIDString];
    __block NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:uniqueRequest]];
    [self performNetworkRequest:request withVerification:^(NSData *data, NSURLResponse *response, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(response);
        XCTAssertNotNil(data);
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        XCTAssertNil(error);
        XCTAssertNotNil(dataDict);
        XCTAssertNotNil(dataDict[@"args"]);
        XCTAssertEqualObjects(dataDict[@"args"], @{ UUIDString : @"" });
        if (extraVerifications) {
            extraVerifications(request, data, response, error);
        }
    }];
    return request;
}

- (void)performNetworkRequest:(NSURLRequest *)request withVerification:(void (^)(NSData *, NSURLResponse *, NSError *))verifications {
    XCTestExpectation *networkExpectation = [self expectationWithDescription:@"network"];
    NSURLSessionTask *basicGetTask = [self taskForNetworkRequest:request withVerification:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (verifications) {
            verifications(data, response, error);
        }
        [networkExpectation fulfill];
    }];
    [basicGetTask resume];
    [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
        if (error) {
            XCTAssertNil(error);
        }
    }];
}

- (void)removeExpectedTestCasePlist {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *expectedFilePathForTestCasePlist = [self filePathForTestCasePlist];
    if ([fileManager fileExistsAtPath:expectedFilePathForTestCasePlist]) {
        NSError *removeTestRunCodeError;
        [fileManager removeItemAtPath:expectedFilePathForTestCasePlist error:&removeTestRunCodeError];
        XCTAssertNil(removeTestRunCodeError);
    }
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
