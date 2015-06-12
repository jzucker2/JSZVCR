//
//  JSZVCRNSURLSessionConnection.h
//  Pods
//
//  Created by Jordan Zucker on 6/8/15.
//
//

#import <Foundation/Foundation.h>

@interface JSZVCRNSURLSessionConnection : NSObject
+ (void)swizzleNSURLSessionClasses;
@property(copy) NSURLSessionTask *task; // @synthesize task=_task;
@end
