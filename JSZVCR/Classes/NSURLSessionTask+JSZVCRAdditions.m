//
//  NSURLSessionTask+JSZVCRAdditions.m
//  Pods
//
//  Created by Jordan Zucker on 6/9/15.
//
//

#import <objc/runtime.h>

#import "NSURLSessionTask+JSZVCRAdditions.h"

static const void *JSZVCRTaskUniqueIDKey = &JSZVCRTaskUniqueIDKey;
//static const void *JSZVCRRecorderUniqueIDKey = &JSZVCRRecorderUniqueIDKey;

@implementation NSURLSessionTask (JSZVCRAdditions)

@dynamic globallyUniqueIdentifier;
//@dynamic recorder;

- (void)setGloballyUniqueIdentifier:(NSString *)globallyUniqueIdentifier {
    objc_setAssociatedObject(self, JSZVCRTaskUniqueIDKey, globallyUniqueIdentifier, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)globallyUniqueIdentifier {
    return objc_getAssociatedObject(self, JSZVCRTaskUniqueIDKey);
}

//- (void)setRecorder:(JSZVCRRecorder *)recorder {
//    return objc_setAssociatedObject(self, JSZVCRRecorderUniqueIDKey, recorder, OBJC_ASSOCIATION_ASSIGN);
//}

@end
