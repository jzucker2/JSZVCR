//
//  JSZVCRTestCase.h
//  Pods
//
//  Created by Jordan Zucker on 6/11/15.
//
//

#import <Foundation/Foundation.h>
//#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

//@class XCTestCase;

typedef NS_ENUM(NSInteger, JSZVCRTestingStrictness) {
    JSZVCRTestingStrictnessNone = 0,
    JSZVCRTestingStrictnessFailOnInconsistency
};

@interface JSZVCRTestCase : XCTestCase

- (BOOL)recording;
+ (NSString *)bundleNameContainingResponses;
- (JSZVCRTestingStrictness)testingStrictnessForSelector:(SEL)testCaseSelector;
//- (NSDictionary *)responseForRequest:(NSURLRequest *)request;
//- (NSArray *)responsesForSelector:(SEL)testCaseSelector;


@end
