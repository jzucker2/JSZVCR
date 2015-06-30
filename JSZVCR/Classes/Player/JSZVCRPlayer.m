//
//  JSZVCRPlayer.m
//  Pods
//
//  Created by Jordan Zucker on 6/11/15.
//
//
#import <libkern/OSAtomic.h>
#import <XCTest/XCTest.h>
#import <OHHTTPStubs/OHHTTPStubs.h>

#import "JSZVCRPlayer.h"
#import "JSZVCRResourceManager.h"

@interface JSZVCRPlayer ()
@end

@implementation JSZVCRPlayer
@synthesize networkResponses = _networkResponses;

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
        NSAssert(self.networkResponses, @"Network responses must be a valid object for playback to be enabled: %@", self.networkResponses);
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
            NSData *data = responseDict[@"data"];
            int statusCode = [responseDict[@"statusCode"] intValue];
            NSDictionary *headers = responseDict[@"httpHeaders"];
            NSAssert(self.networkResponses, @"Network responses do not exist");
            NSAssert(data, @"Data was not loaded: %@", data);
            NSAssert(statusCode, @"Status code was not loaded: %d", statusCode);
            NSAssert(headers, @"Headers were not loaded: %@", headers);
            return [OHHTTPStubsResponse responseWithData:data
                                              statusCode:statusCode
                                                 headers:headers];
        }];
    } else {
        [OHHTTPStubs removeAllStubs];
    }
}

- (NSArray *)networkResponses {
//    if (_networkResponses == nil) {
//        static OSSpinLock lock = OS_SPINLOCK_INIT;
//        OSSpinLockLock(&lock);
//        if (_networkResponses == nil) {
//            NSArray *responses = [JSZVCRResourceManager networkResponsesForTest:self.currentTestCase];
//            _networkResponses = [responses copy];
//        }
//        OSSpinLockUnlock(&lock);
//    }
//    return _networkResponses;
    @synchronized(_networkResponses) {
        if (!_networkResponses) {
            _networkResponses = [JSZVCRResourceManager networkResponsesForTest:self.currentTestCase];
        }
        return _networkResponses;
    }
}

- (void)tearDown {
    _enabled = NO;
    [OHHTTPStubs removeAllStubs];
}

@end
