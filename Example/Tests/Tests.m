//
//  JSZVCRTests.m
//  JSZVCRTests
//
//  Created by Jordan Zucker on 06/08/2015.
//  Copyright (c) 2015 Jordan Zucker. All rights reserved.
//

#import <JSZVCR/JSZVCRResourceLoader.h>

@import XCTest;

@interface Tests : XCTestCase

@end

@implementation Tests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
//    id responses = [JSZVCRResourceLoader pathForFile:@"testSimpleSubscribe" bundleForClass:self.class];
//    NSLog(@"responses: %@", responses);
    
    [[JSZVCRResourceLoader sharedInstance] setResourceBundle:@"NetworkResponses" containingClass:self.class];
    [[JSZVCRResourceLoader sharedInstance] setTest:self];
    
    [[JSZVCRResourceLoader sharedInstance] hasResponseForRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"test"]]];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

- (void)testSimpleSubscribe {
    NSLog(@"testing!");
}

@end
