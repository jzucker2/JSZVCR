//
//  JSZVCRTests.m
//  JSZVCRTests
//
//  Created by Jordan Zucker on 06/11/2015.
//  Copyright (c) 2015 Jordan Zucker. All rights reserved.
//

@import XCTest;

@interface Tests : XCTestCase

@end

@implementation Tests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSimpleNoMockingNetworkCall {
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://pubsub.pubnub.com/publish/demo/demo/0/hello_world/0/%22Hello%20World%22"]];
    
    XCTestExpectation *networkExpectation = [self expectationWithDescription:@"network"];
    NSURLSessionDataTask *basicGetTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"data: %@", data);
        NSLog(@"response: %@", response);
        NSLog(@"error: %@", error);
        [networkExpectation fulfill];
        XCTAssertNil(error);
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
