//
//  NSURLSessionTask+JSZVCRAdditions.h
//  Pods
//
//  Created by Jordan Zucker on 6/9/15.
//
//

#import <Foundation/Foundation.h>

//@class JSZVCRRecorder;

@interface NSURLSessionTask (JSZVCRAdditions)

@property (nonatomic, copy) NSString *globallyUniqueIdentifier;
//@property (nonatomic, weak) JSZVCRRecorder *recorder;

@end
