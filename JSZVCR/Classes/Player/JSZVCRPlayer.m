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
