//
//  JSZVCRResponse.m
//  Pods
//
//  Created by Jordan Zucker on 6/9/15.
//
//

#import "JSZVCRResponse.h"

@implementation JSZVCRResponse

- (instancetype)initWithResponse:(NSURLResponse *)response {
    self = [super init];
    if (self) {
        _response = response;
    }
    return self;
}

+ (instancetype)responseWithResponse:(NSURLResponse *)response {
    return [[self alloc] initWithResponse:response];
}

- (NSDictionary *)dictionaryForResponse:(NSURLResponse *)response {
    NSMutableDictionary *dict = [@{
                                   @"URL" : response.URL.absoluteString,
                                   @"MIMEType" : response.MIMEType,
                                   @"expectedContentLength" : @(response.expectedContentLength),
                                   @"textEncodingName" : response.textEncodingName,
                                   @"suggestedFileName" : response.suggestedFilename,
                                   } mutableCopy];
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        dict[@"statusCode"] = @(httpResponse.statusCode);
        dict[@"allHeaderFields"] = httpResponse.allHeaderFields;
    }
    return [dict copy];
}

- (NSDictionary *)dictionaryRepresentation {
    return @{
             @"response" : [self dictionaryForResponse:self.response]
             };
}

@end
