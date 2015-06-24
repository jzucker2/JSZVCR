//
//  JSZVCRRecorderTestCase.m
//  JSZVCR
//
//  Created by Jordan Zucker on 6/15/15.
//  Copyright (c) 2015 Jordan Zucker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JSZVCR/JSZVCR.h>

#import "XCTestCase+XCTestCase_JSZVCRAdditions.h"

@interface JSZVCRRecorderTestCase : JSZVCRTestCase
@end

@implementation JSZVCRRecorderTestCase

- (BOOL)isRecording {
    return YES;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *expectedFilePathForTestCasePlist = [self filePathForTestCasePlist];
    if ([fileManager fileExistsAtPath:expectedFilePathForTestCasePlist]) {
        NSError *removeTestRunCodeError;
        [fileManager removeItemAtPath:expectedFilePathForTestCasePlist error:&removeTestRunCodeError];
        XCTAssertNil(removeTestRunCodeError);
    }
}

- (void)tearDown {
    [super tearDown];
    // Call file verification after super teardown to ensure file has been saved as expected.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *expectedFilePathForTestCasePlist = [self filePathForTestCasePlist];
    NSLog(@"expectedFilePathForTestCasePlist: %@", expectedFilePathForTestCasePlist);
    XCTAssertTrue([fileManager fileExistsAtPath:expectedFilePathForTestCasePlist]);
}

- (void)testRecordingNetworkCall {
    [self performSimpleVerifiedNetworkCall:nil];
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
