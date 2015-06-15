//
//  JSZVCRPlayer.m
//  Pods
//
//  Created by Jordan Zucker on 6/11/15.
//
//

#import "JSZVCRPlayer.h"
#import "JSZVCRResourceManager.h"

@interface JSZVCRPlayer ()
@property (nonatomic, readwrite) JSZVCRResourceManager *resourceManager;
@end

@implementation JSZVCRPlayer

- (instancetype)initWithResourceManager:(JSZVCRResourceManager *)resourceManager {
    self = [super init];
    if (self) {
        _resourceManager = resourceManager;
    }
    return self;
}

- (BOOL)hasResponseForRequest:(NSURLRequest *)request {
    NSDictionary *info = [self infoForRequest:request];
    return (info != nil);
}

- (NSDictionary *)infoForRequest:(NSURLRequest *)request {
    for (NSDictionary *info in self.resourceManager.networkInfo) {
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
    return self.resourceManager.networkInfo;
}

@end
