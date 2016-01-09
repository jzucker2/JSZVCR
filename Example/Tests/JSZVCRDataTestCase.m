//
//  JSZVCRDataTestCase.m
//  JSZVCR
//
//  Created by Jordan Zucker on 6/26/15.
//  Copyright (c) 2015 Jordan Zucker. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <JSZVCR/JSZVCRData.h>

@interface JSZVCRDataTestCase : XCTestCase

@end

@implementation JSZVCRDataTestCase

- (void)testJSONSerializableData {
    NSArray *jsonArray = @[@"foo"];
    NSError *JSONSerializationError;
    NSData *data = [NSJSONSerialization dataWithJSONObject:jsonArray options:NSJSONWritingPrettyPrinted error:&JSONSerializationError];
    XCTAssertNil(JSONSerializationError);
    XCTAssertNotNil(data);
    JSZVCRData *recording = [JSZVCRData dataWithData:data];
    XCTAssertNotNil(recording);
    XCTAssertEqualObjects(recording.data, data);
    NSDictionary *dataDict = recording.dictionaryRepresentation;
    XCTAssertNotNil(dataDict);
    XCTAssertNotNil(dataDict[@"data"]);
    XCTAssertEqualObjects(dataDict[@"data"], data);
    XCTAssertNotNil(dataDict[@"json"]);
    XCTAssertEqualObjects(dataDict[@"json"], jsonArray);
}

- (void)testNonJSONSerializableData {
    NSData *randomData = [self randomData];
    XCTAssertFalse([NSJSONSerialization isValidJSONObject:randomData]);
    JSZVCRData *recording = [JSZVCRData dataWithData:randomData];
    XCTAssertNotNil(recording);
    XCTAssertEqualObjects(recording.data, randomData);
    NSDictionary *dataDict = recording.dictionaryRepresentation;
    XCTAssertNotNil(dataDict);
    XCTAssertNotNil(dataDict[@"data"]);
    XCTAssertEqualObjects(dataDict[@"data"], randomData);
    XCTAssertNil(dataDict[@"json"]);
}

- (NSData *)randomData {
    void * bytes = malloc(1000);
    NSData * data = [NSData dataWithBytes:bytes length:1000];
    free(bytes);
    return data;
}

@end
