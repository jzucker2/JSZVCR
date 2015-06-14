//
//  JSZVCRRequest.h
//  Pods
//
//  Created by Jordan Zucker on 6/9/15.
//
//

#import <Foundation/Foundation.h>
#import "JSZVCRSerializer.h"

@interface JSZVCRRequest : NSObject <JSZVCRSerializer>

- (instancetype)initWithTask:(NSURLSessionTask *)task;
+ (instancetype)requestWithTask:(NSURLSessionTask *)task;

@property (nonatomic, copy) NSURLRequest *originalRequest;
@property (nonatomic, copy) NSURLRequest *currentRequest;

@end
