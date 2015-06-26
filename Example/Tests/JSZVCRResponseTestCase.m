//
//  JSZVCRResponseTestCase.m
//  JSZVCR
//
//  Created by Jordan Zucker on 6/26/15.
//  Copyright (c) 2015 Jordan Zucker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>
#import <JSZVCR/JSZVCRResponse.h>

@interface JSZVCRResponseTestCase : XCTestCase

@end

@implementation JSZVCRResponseTestCase

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testTextEncodingResponse {
    NSURLResponse *response = [[NSURLResponse alloc] initWithURL:[NSURL URLWithString:@"https://httpbin.org/get?test=test"] MIMEType:@"application/json" expectedContentLength:339 textEncodingName:@"UTF-8"];
    XCTAssertNotNil(response);
    JSZVCRResponse *recordingResponse = [JSZVCRResponse responseWithResponse:response];
    XCTAssertNotNil(recordingResponse);
    NSDictionary *recordingDict = recordingResponse.dictionaryRepresentation;
    XCTAssertNotNil(recordingDict);
    NSDictionary *responseDict = recordingDict[@"response"];
    XCTAssertNotNil(responseDict);
    XCTAssertEqualObjects(responseDict[@"URL"], response.URL.absoluteString);
    XCTAssertEqualObjects(responseDict[@"MIMEType"], response.MIMEType);
    XCTAssertEqual([responseDict[@"expectedContentLength"] integerValue], 339);
    XCTAssertEqualObjects(responseDict[@"textEncodingName"], response.textEncodingName);
}

@end
