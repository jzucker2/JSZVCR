//
//  JSZVCRNSURLSessionConnection.h
//  Pods
//
//  Created by Jordan Zucker on 6/8/15.
//
//

#import <Foundation/Foundation.h>

/**
 *  Represents the private NSURLSessionConnection object that is responsible for performing a NSURLSessionTask
 */
@interface JSZVCRNSURLSessionConnection : NSObject

/**
 *  All private NSURLSessionConnection objects have a strong reference to a task
 */
@property(copy) NSURLSessionTask *task; // @synthesize task=_task;
/**
 *  This method overrides all network calls with our custom recorder
 */
+ (void)swizzleNSURLSessionClasses;

@end
