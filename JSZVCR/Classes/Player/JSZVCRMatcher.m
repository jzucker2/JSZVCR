//
//  JSZVCRMatcher.m
//  Pods
//
//  Created by Jordan Zucker on 6/19/15.
//
//

#import "JSZVCRMatcher.h"

@implementation JSZVCRMatcher

+ (instancetype)matcher {
    return [[self alloc] init];
}

- (BOOL)hasResponseForRequest:(NSURLRequest *)request inRecordings:(NSArray *)recordings {
    NSDictionary *info = [self infoForRequest:request inRecordings:recordings];
    return (info != nil);
}

- (NSDictionary *)infoForRequest:(NSURLRequest *)request inRecordings:(NSArray *)recordings {
    for (NSDictionary *info in recordings) {
        NSString *currentRequestURLString = info[@"request"][@"currentRequest"][@"URL"];
        NSString *originalRequestURLString = info[@"request"][@"originalRequest"][@"URL"];
        if ([request.URL.absoluteString isEqualToString:currentRequestURLString] ||
            [request.URL.absoluteString isEqualToString:originalRequestURLString]) {
            return info;
        }
    }
    return nil;
}

- (NSDictionary *)responseForRequest:(NSURLRequest *)request inRecordings:(NSArray *)recordings {
    NSDictionary *info = [self infoForRequest:request inRecordings:recordings];
    if (!info) {
        return nil;
    }
    // TODO: should handle better than just returning nil for cancelled requests
    if ([info[@"cancelled"] boolValue] == YES) {
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

@end
