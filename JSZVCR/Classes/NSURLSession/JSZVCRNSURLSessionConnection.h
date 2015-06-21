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

@property(copy) NSURLSessionTask *task; // @synthesize task=_task;
+ (void)swizzleNSURLSessionClasses;

@end
