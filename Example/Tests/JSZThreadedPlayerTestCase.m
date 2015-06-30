//
//  JSZThreadedPlayerTestCase.m
//  JSZVCR
//
//  Created by Jordan Zucker on 6/29/15.
//  Copyright (c) 2015 Jordan Zucker. All rights reserved.
//
#include <stdlib.h>
#import <JSZVCR/JSZVCR.h>

#import "XCTestCase+XCTestCase_JSZVCRAdditions.h"

@interface JSZThreadedPlayerTestCase : JSZVCRTestCase

@end

@implementation JSZThreadedPlayerTestCase

- (BOOL)isRecording {
    return YES;
}

- (void)testRecordedNetworkCall {
    dispatch_queue_t concurrentTestQueue = dispatch_queue_create("com.concurrentTestQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t concurrentGroup = dispatch_group_create();
    XCTestExpectation *concurrentAsync = [self expectationWithDescription:@"concurrent"];
    __weak typeof(self) wself = self;
    for (int i = 0; i < 10; i++) {
        dispatch_group_async(concurrentGroup, concurrentTestQueue, ^{
            __weak typeof(wself) sself = wself;
            if (!sself) {
                return;
            }
            NSNumber *randomDelay = @(arc4random_uniform(10));
            NSLog(@"random: %@", randomDelay);
            NSString *URLString = [NSString stringWithFormat:@"https://httpbin.org/delay/%@", randomDelay];
            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:URLString]];
            NSURLSessionTask *basicGetTask = [sself taskForNetworkRequest:request withVerification:^(NSData *data, NSURLResponse *response, NSError *error) {
                NSLog(@"data: %@", data);
            }];
            [basicGetTask resume];
        });
    }
//    dispatch_group_notify(concurrentGroup, concurrentTestQueue, ^{
//        [concurrentAsync fulfill];
//    });
    [self waitForExpectationsWithTimeout:20 handler:^(NSError *error) {
        if (error) {
            XCTAssertNil(error);
        }
    }];
    
//    dispatch_group_notify(concurrentGroup, concurrentTestQueue, ^{
//        [concurrentAsync fulfill];
//    });
    
//    dispatch_group_wait(concurrentGroup, DISPATCH_TIME_FOREVER);
//    [concurrentAsync fulfill];
}

@end
