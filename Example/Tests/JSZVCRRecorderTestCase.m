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
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *expectedFilePathForTestCasePlist = [self filePathForTestCasePlist];
    if ([fileManager fileExistsAtPath:expectedFilePathForTestCasePlist]) {
        NSError *removeTestRunCodeError;
        [fileManager removeItemAtPath:expectedFilePathForTestCasePlist error:&removeTestRunCodeError];
        XCTAssertNil(removeTestRunCodeError);
    }
    [super tearDown];
}

- (void)testRecordedNetworkCall {
    [self performSimpleVerifiedNetworkCall:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *expectedFilePathForTestCasePlist = [self filePathForTestCasePlist];
        NSLog(@"expectedFilePathForTestCasePlist: %@", expectedFilePathForTestCasePlist);
        XCTAssertTrue([fileManager fileExistsAtPath:expectedFilePathForTestCasePlist]);
        // TODO: check file contents
    }];
}

- (void)testPerformanceRecordedNetworkCall {
    __weak typeof(self) wself = self;
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        __weak typeof(wself) sself = wself;
        if (!sself) {
            return;
        }
        [sself performSimpleVerifiedNetworkCall:^(NSData *data, NSURLResponse *response, NSError *error) {
            // TODO: same as above!
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *expectedFilePathForTestCasePlist = [self filePathForTestCasePlist];
            NSLog(@"expectedFilePathForTestCasePlist: %@", expectedFilePathForTestCasePlist);
            XCTAssertTrue([fileManager fileExistsAtPath:expectedFilePathForTestCasePlist]);
        }];
    }];
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
