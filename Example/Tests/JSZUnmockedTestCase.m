//
//  JSZUnmockedTestCase.m
//  JSZVCR
//
//  Created by Jordan Zucker on 6/11/15.
//  Copyright (c) 2015 Jordan Zucker. All rights reserved.
//

#import "XCTestCase+XCTestCase_JSZVCRAdditions.h"

@import XCTest;

@interface JSZUnmockedTestCase : XCTestCase

@end

@implementation JSZUnmockedTestCase

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
    [self performSimpleVerifiedNetworkCall:nil];
}

- (void)testSimpleNoMockingPerformanceNetworkCall {
    __weak typeof(self) wself = self;
    [self measureBlock:^{
        __strong typeof(wself) sself = wself;
        if (!sself) {
            return;
        }
        [sself performSimpleVerifiedNetworkCall:nil];
    }];
}

@end
