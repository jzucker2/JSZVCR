//
//  JSZVCR.m
//  Pods
//
//  Created by Jordan Zucker on 6/8/15.
//
//

#import <objc/runtime.h>
#import <objc/message.h>
#import <dispatch/queue.h>

#import "JSZVCR.h"
#import "JSZVCRRecording.h"
#import "JSZVCRNSURLSessionConnection.h"
#import "JSZVCRRequest.h"
#import "JSZVCRData.h"
#import "JSZVCRResponse.h"

#import "NSURLSessionTask+JSZVCRAdditions.h"

@interface JSZVCR ()
@property (nonatomic) NSMutableDictionary *recordings;
@end

@implementation JSZVCR

@synthesize enabled = _enabled;

+ (instancetype)sharedInstance {
    static JSZVCR *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[JSZVCR alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _recordings = [NSMutableDictionary dictionary];
        _enabled = YES;
    }
    return self;
}

//- (void)setEnabled:(BOOL)enabled {
//    _enabled = enabled;
//}
//
//- (BOOL)isEnabled {
//    return _enabled;
//}

+ (void)swizzleNSURLSessionClasses
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self _swizzleNSURLSessionClasses];
    });
}

+ (void)_swizzleNSURLSessionClasses;
{
    Class cfURLSessionConnectionClass = NSClassFromString(@"__NSCFURLSessionConnection");
    if (!cfURLSessionConnectionClass) {
        NSLog(@"Could not find __NSCFURLSessionConnection");
        return;
    }
    
    unsigned int outCount = 0;
    Method *methods = class_copyMethodList([JSZVCRNSURLSessionConnection class], &outCount);
//    Method *methods = class_copyMethodList(cfURLSessionConnectionClass, &outCount);
    
    for (int i = 0; i < outCount; i++) {
        Method m = methods[i];
        SEL sourceMethod = method_getName(m);
        const char *encoding = method_getTypeEncoding(m);
        NSString *sourceMethodName = NSStringFromSelector(sourceMethod);
//        NSLog(@"%@", sourceMethodName);
        NSAssert([sourceMethodName hasPrefix:@"JSZ_"], @"Expecting swizzle methods only");
        NSString *originalMethodName = [sourceMethodName substringFromIndex:4];
        SEL originalMethod = NSSelectorFromString(originalMethodName);
        NSAssert(originalMethod, @"Must find selector");
        
        IMP sourceImp = method_getImplementation(m);
        
        IMP originalImp = class_getMethodImplementation(cfURLSessionConnectionClass, originalMethod);
        
        NSAssert(originalImp, @"Must find imp");
        
        __unused BOOL success = class_addMethod(cfURLSessionConnectionClass, sourceMethod, originalImp, encoding);
        NSAssert(success, @"Should be successful");
        __unused IMP replacedImp = class_replaceMethod(cfURLSessionConnectionClass, originalMethod, sourceImp, encoding);
        NSAssert(replacedImp, @"Expected original method to have been replaced");
    }
    
    if (methods) {
        free(methods);
    }
}

#pragma mark - NSURLSession recording

- (void)recordTask:(NSURLSessionTask *)task redirectRequest:(NSURLRequest *)arg1 redirectResponse:(NSURLResponse *)arg2 {
    if (!_enabled) {
        return;
    }
    
}

- (void)recordTask:(NSURLSessionTask *)task didReceiveData:(NSData *)data {
    if (!_enabled) {
        return;
    }
    JSZVCRRecording *recording = [self storedRecordingFromTask:task];
    if (recording.data) {
        NSLog(@"already had data: %@", recording.data);
    }
    recording.data = [JSZVCRData dataWithData:data];
}

- (void)recordTask:(NSURLSessionTask *)task didReceiveResponse:(NSURLResponse *)response {
    if (!_enabled) {
        return;
    }
    JSZVCRRecording *recording = [self storedRecordingFromTask:task];
    if (recording.response) {
        NSLog(@"already had response: %@", recording.response);
    }
    recording.response = [JSZVCRResponse responseWithResponse:response];
    
}

- (void)recordTask:(NSURLSessionTask *)task didFinishWithError:(NSError *)error {
    if (!_enabled) {
        return;
    }
    JSZVCRRecording *recording = [self storedRecordingFromTask:task];
    recording.error = error;
}

- (JSZVCRRecording *)storedRecordingFromTask:(NSURLSessionTask *)task {
    NSString *globallyUniqueIdentifier = task.globallyUniqueIdentifier;
    JSZVCRRecording *recordingToReturn = nil;
    if (!self.recordings[globallyUniqueIdentifier]) {
        recordingToReturn = [JSZVCRRecording recordingWithTask:task];
        self.recordings[globallyUniqueIdentifier] = recordingToReturn;
    } else {
        recordingToReturn = self.recordings[globallyUniqueIdentifier];
    }
    return recordingToReturn;
}

- (NSArray *)allRecordings {
    return [self.recordings allValues];
}

- (void)dumpRecordingsToFile:(NSString *)aPathFile {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *filePathComponent = [NSString stringWithFormat:@"%@.plist", [NSUUID UUID].UUIDString];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:filePathComponent];
    NSLog(@"filePath = %@", filePath);
    NSMutableArray *dumpArray = [NSMutableArray array];
    for (JSZVCRRecording *recording in self.recordings.allValues) {
        [dumpArray addObject:recording.dictionaryRepresentation];
    }
    [dumpArray writeToFile:filePath atomically:YES];
}

@end

