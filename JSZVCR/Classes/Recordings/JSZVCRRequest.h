//
//  JSZVCRRequest.h
//  Pods
//
//  Created by Jordan Zucker on 6/9/15.
//
//

#import <Foundation/Foundation.h>
#import "JSZVCRSerializer.h"

/**
 * Represents everything that can happen to a request over the course of a 
 * network request's lifetime (including NSURLSessionTask)
 */
@interface JSZVCRRequest : NSObject <JSZVCRSerializer>

/**
 *  Designated initializer representing every that can happen to a request over its lit
 *
 *  @param task network task
 *
 *  @return newly initialized request instance
 */
- (instancetype)initWithTask:(NSURLSessionTask *)task;

/**
 *
 */
- (instancetype)initWithDictionary:(NSDictionary *)info;

/**
 *  Convenience method for abstract class representing all requests around a URL Loading request
 *
 *  @param task network task
 *
 *  @return newly initialized request instance
 */
+ (instancetype)requestWithTask:(NSURLSessionTask *)task;

/**
 *  originalRequest corresponds to (NSURLSessionTask *)task.originalRequest
 */
@property (nonatomic, copy) NSURLRequest *originalRequest;

/**
 *  currentRequest corresponds to (NSURLSessionTask *)task.currentRequest
 */
@property (nonatomic, copy) NSURLRequest *currentRequest;

@end
