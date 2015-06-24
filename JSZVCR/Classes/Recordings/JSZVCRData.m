//
//  JSZVCRData.m
//  Pods
//
//  Created by Jordan Zucker on 6/9/15.
//
//

#import "JSZVCRData.h"

@implementation JSZVCRData

- (instancetype)initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        _data = data;
    }
    return self;
}

+ (instancetype)dataWithData:(NSData *)data {
    return [[self alloc] initWithData:data];
}

- (id)JSONConvertedObject {
    NSError *jsonSerializingError = nil;
    id jsonData = [NSJSONSerialization JSONObjectWithData:self.data options:kNilOptions error:&jsonSerializingError];
    if (jsonSerializingError) {
        return nil;
    } else {
        return jsonData;
    }
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dict = [@{
                                   @"data" : self.data
                                   } mutableCopy];
    id JSON = [self JSONConvertedObject];
    if (JSON) {
        dict[@"json"] = JSON;
    }
    return [dict copy];
}

@end
