
//
//  JSZVCRError.m
//  Pods
//
//  Created by Jordan Zucker on 6/29/15.
//
//

#import "JSZVCRError.h"

@interface JSZVCRError ()
@property (nonatomic, readwrite) NSString *domain;
@property (nonatomic, readwrite) NSNumber *code;
@property (nonatomic, readwrite) NSDictionary *userInfo;
@property (nonatomic, readwrite) NSString *errorDescription;

@end

@implementation JSZVCRError

- (instancetype)initWithError:(NSError *)error {
    NSParameterAssert(error);
    self = [super init];
    if (self) {
        _domain = error.domain;
        _code = @(error.code);
        _userInfo = error.userInfo;
        _errorDescription = error.localizedDescription;
    }
    return self;
}

+ (instancetype)errorWithError:(NSError *)error {
    return [[self alloc] initWithError:error];
}

- (instancetype)initWithDictionary:(NSDictionary *)errorDictionary {
    NSParameterAssert(errorDictionary);
    self = [super init];
    if (self) {
        _domain = errorDictionary[@"domain"];
        _code = errorDictionary[@"code"];
        _userInfo = errorDictionary[@"userInfo"];
        _errorDescription = errorDictionary[@"description"];
    }
    return self;
}

+ (instancetype)errorWithDictionary:(NSDictionary *)errorDictionary {
    return [[self alloc] initWithDictionary:errorDictionary];
}

- (NSDictionary *)dictionaryRepresentation {
    return @{
             @"domain" : self.domain,
             @"code" : self.code,
             @"userInfo" : self.userInfo,
             @"description" : self.errorDescription
             };
}

- (NSError *)networkError {
    return [NSError errorWithDomain:self.domain code:self.code.integerValue userInfo:self.userInfo];
}

@end
