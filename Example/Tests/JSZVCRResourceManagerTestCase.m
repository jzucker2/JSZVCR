//
//  JSZVCRResourceManagerTestCase.m
//  JSZVCR
//
//  Created by Jordan Zucker on 6/25/15.
//  Copyright (c) 2015 Jordan Zucker. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <JSZVCR/JSZVCRResourceManager.h>

@interface JSZVCRResourceManagerTestCase : XCTestCase

@end

@implementation JSZVCRResourceManagerTestCase

- (void)testResourceManagerFindsResource {
    // This is an example of a functional test case.
    NSString *expectedFileName = [NSStringFromClass(self.class) stringByAppendingPathExtension:@"txt"];
    NSString *filePath = [JSZVCRResourceManager pathForFile:expectedFileName inBundleForClass:self.class];
    XCTAssertNotNil(filePath);
}

@end
