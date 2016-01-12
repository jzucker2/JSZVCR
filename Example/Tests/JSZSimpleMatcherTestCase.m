//
//  JSZSimpleMatcherTestCase.m
//  JSZVCR
//
//  Created by Jordan Zucker on 6/25/15.
//  Copyright (c) 2015 Jordan Zucker. All rights reserved.
//

#import <JSZVCR/JSZVCR.h>

#import "XCTestCase+XCTestCase_JSZVCRAdditions.h"

@interface JSZSimpleMatcherTestCase : JSZVCRTestCase
@property (nonatomic) NSString *UUIDString;
@end

@implementation JSZSimpleMatcherTestCase

- (BOOL)isRecording {
    return NO;
}

- (Class<JSZVCRMatching>)matcherClass {
    return [JSZVCRSimpleURLMatcher class];
}

- (JSZVCRMatchingStrictness)matchingFailStrictness {
    return JSZVCRMatchingStrictnessNone;
}

- (void)testRecordedNetworkCall {
    [self performSimpleVerifiedNetworkCall:nil];
    [self performUniqueVerifiedNetworkCall:nil];
}

@end
