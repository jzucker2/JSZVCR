//
//  JSZMatchStrictnessNoneTestCase.m
//  JSZVCR
//
//  Created by Jordan Zucker on 6/24/15.
//  Copyright (c) 2015 Jordan Zucker. All rights reserved.
//

#import <JSZVCR/JSZVCR.h>

#import "XCTestCase+XCTestCase_JSZVCRAdditions.h"

// Just in case the default strictness level changes, make sure there's an explicit test for strictness level none
@interface JSZMatchStrictnessNoneTestCase : JSZVCRTestCase
@end

@implementation JSZMatchStrictnessNoneTestCase

- (BOOL)isRecording {
    return NO;
}

- (JSZVCRMatchingStrictness)matchingFailStrictness {
    return JSZVCRMatchingStrictnessNone;
}

- (void)testMatchingFailStrictnessNone {
    // This is an example of a functional test case.
    [self performSimpleVerifiedNetworkCall:nil];
    // Unique network call is guaranteed to not match and then this method verifies live expected network results
    [self performUniqueVerifiedNetworkCall:nil];
}

@end
