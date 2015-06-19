//
//  JSZVCRPlayer.m
//  Pods
//
//  Created by Jordan Zucker on 6/11/15.
//
//
#import <XCTest/XCTest.h>
#import <OHHTTPStubs/OHHTTPStubs.h>

#import "JSZVCRPlayer.h"
#import "JSZVCRResourceManager.h"
#import "JSZVCRMatcher.h"

@interface JSZVCRPlayer ()
@end

@implementation JSZVCRPlayer

+ (instancetype)playerWithMatcher:(id<JSZVCRMatching>)matcher {
    return [[self alloc] initWithMatcher:matcher];
}

- (instancetype)initWithMatcher:(id<JSZVCRMatching>)matcher {
    self = [super init];
    if (self) {
        _matcher = matcher;
    }
    return self;
}

- (void)setEnabled:(BOOL)enabled {
    _enabled = enabled;
    [OHHTTPStubs removeAllStubs];
    if (_enabled) {
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            return [self.matcher hasResponseForRequest:request inRecordings:self.networkResponses];
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
            NSDictionary *responseDict = [self.matcher responseForRequest:request inRecordings:self.networkResponses];
            return [OHHTTPStubsResponse responseWithData:responseDict[@"data"]
                                              statusCode:[responseDict[@"statusCode"] intValue]
                                                 headers:responseDict[@"httpHeaders"]];
        }];
    } else {
        [OHHTTPStubs removeAllStubs];
    }
}

- (NSArray *)networkResponses {
    return [JSZVCRResourceManager networkResponsesForTest:self.currentTestCase];
}

- (void)removeAllNetworkResponses {
    [OHHTTPStubs removeAllStubs];
}

@end
