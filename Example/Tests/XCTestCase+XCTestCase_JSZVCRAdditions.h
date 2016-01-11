//
//  XCTestCase+XCTestCase_JSZVCRAdditions.h
//  JSZVCR
//
//  Created by Jordan Zucker on 6/12/15.
//  Copyright (c) 2015 Jordan Zucker. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface XCTestCase (XCTestCase_JSZVCRAdditions)

- (NSURLSessionTask *)taskForNetworkRequest:(NSURLRequest *)request withVerification:(void (^)(NSData *data, NSURLResponse *response, NSError *error))verifications;

- (NSURLRequest *)performSimpleVerifiedNetworkCall:(void (^)(NSData *data, NSURLResponse *response, NSError *error))extraVerifications;

- (NSURLRequest *)performUniqueVerifiedNetworkCall:(void (^)(NSURLRequest *request, NSData *data, NSURLResponse *response, NSError *error))extraVerifications;

- (NSURLRequest *)performUniqueDataVerifiedNetworkCall:(void (^)(NSURLRequest *request, NSData *data, NSURLResponse *response, NSError *error))extraVerifications;

- (void)performNetworkRequest:(NSURLRequest *)request withVerification:(void (^)(NSData *data, NSURLResponse *response, NSError *error))verifications;

- (void)removeExpectedTestCasePlist;

- (NSString *)filePathForTestSuiteBundle;

- (NSString *)filePathForTestCasePlist;

@end
