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

- (void)setEnabled:(BOOL)enabled {
    _enabled = enabled;
    [OHHTTPStubs removeAllStubs];
    if (_enabled) {
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            return [self hasResponseForRequest:request];
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
            // Stub it with our "wsresponse.json" stub file (which is in same bundle as self)
            NSDictionary *responseDict = [self responseForRequest:request];
            return [OHHTTPStubsResponse responseWithData:responseDict[@"data"]
                                              statusCode:[responseDict[@"statusCode"] intValue]
                                                 headers:responseDict[@"httpHeaders"]];
        }];
    } else {
        [OHHTTPStubs removeAllStubs];
    }
}

- (BOOL)hasResponseForRequest:(NSURLRequest *)request {
    NSDictionary *info = [self infoForRequest:request];
    return (info != nil);
}

- (NSDictionary *)infoForRequest:(NSURLRequest *)request {
    for (NSDictionary *info in self.networkResponses) {
        NSString *currentRequestURLString = info[@"request"][@"currentRequest"][@"URL"];
        NSString *originalRequestURLString = info[@"request"][@"originalRequest"][@"URL"];
        if ([request.URL.absoluteString isEqualToString:currentRequestURLString] ||
            [request.URL.absoluteString isEqualToString:originalRequestURLString]) {
            return info;
        }
    }
    return nil;
}

- (NSDictionary *)responseForRequest:(NSURLRequest *)request {
    NSDictionary *info = [self infoForRequest:request];
    if (!info) {
        return nil;
    }
    NSDictionary *responseDictionary = info[@"response"][@"response"];
    NSNumber *responseCode = responseDictionary[@"statusCode"];
    NSDictionary *headersDict = responseDictionary[@"allHeaderFields"];
    NSData *data = info[@"data"][@"data"];
    return @{
             @"statusCode" : responseCode,
             @"httpHeaders" : headersDict,
             @"data" : data
             };
}

- (NSArray *)networkResponses {
    return [JSZVCRResourceManager networkResponsesForTest:self.currentTestCase];
}

- (void)removeAllNetworkResponses {
    [OHHTTPStubs removeAllStubs];
}

@end
