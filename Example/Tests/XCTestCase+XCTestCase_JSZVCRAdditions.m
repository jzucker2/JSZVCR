//
//  XCTestCase+XCTestCase_JSZVCRAdditions.m
//  JSZVCR
//
//  Created by Jordan Zucker on 6/12/15.
//  Copyright (c) 2015 Jordan Zucker. All rights reserved.
//

#import "XCTestCase+XCTestCase_JSZVCRAdditions.h"

@implementation XCTestCase (XCTestCase_JSZVCRAdditions)

- (void)performVerifiedNetworkCall {
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://httpbin.org/get?test=test"]];
    
    XCTestExpectation *networkExpectation = [self expectationWithDescription:@"network"];
    NSURLSessionDataTask *basicGetTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(response);
        XCTAssertNotNil(data);
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        XCTAssertNil(error);
        XCTAssertEqualObjects(dataDict[@"args"], @{@"test" : @"test"});
        [networkExpectation fulfill];
    }];
    [basicGetTask resume];
    [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
        if (error) {
            XCTAssertNil(error);
            [networkExpectation fulfill];
        }
    }];
}

@end
