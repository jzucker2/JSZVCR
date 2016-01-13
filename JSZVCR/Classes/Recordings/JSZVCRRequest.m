//
//  JSZVCRRequest.m
//  Pods
//
//  Created by Jordan Zucker on 6/9/15.
//
//

#import "JSZVCRRequest.h"

@implementation JSZVCRRequest

- (instancetype)initWithTask:(NSURLSessionTask *)task {
    self = [super init];
    if (self) {
        _currentRequest = task.currentRequest;
        _originalRequest = task.originalRequest;
    }
    return self;
}

+ (instancetype)requestWithTask:(NSURLSessionTask *)task {
    return [[self alloc] initWithTask:task];
}

- (NSDictionary *)dictionaryForRequest:(NSURLRequest *)request {
    NSMutableDictionary *dict = [@{
                                  @"URL" : request.URL.absoluteString,
                                  @"timeoutInterval" : @(request.timeoutInterval),
                                  @"allowsCellularAccess" : @(request.allowsCellularAccess)
                                  } mutableCopy];
    if (request.HTTPMethod) {
        dict[@"HTTPMethod"] = request.HTTPMethod;
    }
    if (request.HTTPBody) {
        dict[@"HTTPBody"] = request.HTTPBody;
    }
    if (request.HTTPShouldHandleCookies) {
        dict[@"HTTPShouldHandleCookies"] = @(request.HTTPShouldHandleCookies);
    }
    if (request.HTTPShouldUsePipelining) {
        dict[@"HTTPShouldUsePipelining"] = @(request.HTTPShouldUsePipelining);
    }
    if (request.allHTTPHeaderFields) {
        dict[@"allHTTPHeaderFields"] = request.allHTTPHeaderFields;
    }
    return [dict copy];
}

- (instancetype)initWithDictionary:(NSDictionary *)info {
    NSParameterAssert(info);
    self = [super init];
    if (self) {
        if (info[kJSZVCRCurrentRequestKey]) {
            id currentRequest = info[kJSZVCRCurrentRequestKey];
            if ([currentRequest isKindOfClass:[NSURLRequest class]]) {
                _currentRequest = currentRequest;
            } else if ([currentRequest isKindOfClass:[NSDictionary class]]) {
                _currentRequest = [self dictionaryForRequest:<#(NSURLRequest *)#>]
            }
        }
    }
}

- (NSDictionary *)dictionaryRepresentation {
    return @{
             kJSZVCRCurrentRequestKey : [self dictionaryForRequest:self.currentRequest],
             kJSZVCROriginalRequestKey : [self dictionaryForRequest:self.originalRequest]
             };
}

@end
