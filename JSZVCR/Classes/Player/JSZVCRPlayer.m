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

@interface JSZVCRPlayer ()
@end

@implementation JSZVCRPlayer

+ (instancetype)playerWithMatcherClass:(Class<JSZVCRMatching>)matcherClass {
    return [[self alloc] initWithMatcherClass:matcherClass];
}

- (instancetype)initWithMatcherClass:(Class<JSZVCRMatching>)matcherClass {
    self = [super init];
    if (self) {
        _matcher = [matcherClass matcher];
        _matchFailStrictness = JSZVCRTestingStrictnessNone;
    }
    return self;
}

- (void)setEnabled:(BOOL)enabled {
    _enabled = enabled;
    [OHHTTPStubs removeAllStubs];
    if (_enabled) {
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            BOOL matched = [self.matcher hasResponseForRequest:request inRecordings:self.networkResponses];
            if (matched) {
                return matched;
            }
            if (
                [self.matcher respondsToSelector:@selector(shouldAllowUnmatchedRequest:)] &&
                [self.matcher shouldAllowUnmatchedRequest:request]
                ) {
                return matched;
            }
            switch (self.matchFailStrictness) {
                case JSZVCRTestingStrictnessNone:
                {
                    [self.delegate testCase:self.currentTestCase withUnmatchedRequest:request shouldFail:NO];
                }
                    break;
                case JSZVCRTestingStrictnessFailWhenNoMatch:
                {
                    [self.delegate testCase:self.currentTestCase withUnmatchedRequest:request shouldFail:YES];
                }
                    break;
            }
            return matched;
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
