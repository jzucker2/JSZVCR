//
//  JSZVCRResponse.h
//  Pods
//
//  Created by Jordan Zucker on 6/9/15.
//
//

#import <Foundation/Foundation.h>
#import "JSZVCRSerializer.h"

@interface JSZVCRResponse : NSObject <JSZVCRSerializer>

- (instancetype)initWithResponse:(NSURLResponse *)response;
+ (instancetype)responseWithResponse:(NSURLResponse *)response;

@property (nonatomic, copy) NSURLResponse *response;

@end
