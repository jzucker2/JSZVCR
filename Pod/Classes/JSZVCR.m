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

//// For reference from the private class dump
////@interface __NSCFURLSessionConnection : NSObject
////
////- (void)_redirectRequest:(id)arg1 redirectResponse:(id)arg2 completion:(void (^)(id arg))arg3;
////- (void)_conditionalRequirementsChanged:(BOOL)arg1;
////- (void)_connectionIsWaiting;
////- (void)_willSendRequestForEstablishedConnection:(id)arg1 completion:(void (^)(NSURLRequest *arg3))arg2;
////- (void)_didReceiveConnectionCacheKey:(struct HTTPConnectionCacheKey *)arg1;
////- (void)_didFinishWithError:(id)arg1;
////- (void)_didSendBodyData:(struct UploadProgressInfo)arg1;
////- (void)_didReceiveData:(id)arg1;
////- (void)_didReceiveResponse:(id)arg1 sniff:(BOOL)arg2;
////
////@end
//
//@interface __NSCFURLSessionConnection_Swizzles : NSObject
//
//@property(copy) NSURLSessionTask *task; // @synthesize task=_task;
//
//@end
//
//@implementation __NSCFURLSessionConnection_Swizzles
//
//@dynamic task;
//
//- (void)JSZ__redirectRequest:(NSURLRequest *)arg1 redirectResponse:(NSURLResponse *)arg2 completion:(id)arg3;
//{
//    //    [[PDNetworkDomainController defaultInstance] URLSession:[self.task valueForKey:@"session"] task:self.task willPerformHTTPRedirection:(id)arg2 newRequest:arg1];
//    
//    [self JSZ__redirectRequest:arg1 redirectResponse:arg2 completion:arg3];
//}
//
//- (void)JSZ__didReceiveData:(id)arg1;
//{
//    //    [[PDNetworkDomainController defaultInstance] URLSession:[self.task valueForKey:@"session"] dataTask:(id)self.task didReceiveData:arg1];
//    
//    [self JSZ__didReceiveData:arg1];
//}
//
//- (void)JSZ__didReceiveResponse:(NSURLResponse *)response sniff:(BOOL)sniff;
//{
//    // This can be called multiple times for the same request. Make sure it doesn't
//    //    [[PDNetworkDomainController defaultInstance] URLSession:[self.task valueForKey:@"session"] dataTask:(id)self.task didReceiveResponse:response];
//    
//    [self JSZ__didReceiveResponse:response sniff:sniff];
//}
//
//- (void)JSZ__didFinishWithError:(NSError *)arg1;
//{
//    //    [[PDNetworkDomainController defaultInstance] URLSession:[self.task valueForKey:@"session"] task:self.task didCompleteWithError:arg1];
//    [self JSZ__didFinishWithError:arg1];
//}
//
//@end

@interface JSZVCR ()
//- (void)recordTask:(NSURLSessionTask *)task redirectRequest:(NSURLRequest *)arg1 redirectResponse:(NSURLResponse *)arg2;
//- (void)recordTask:(NSURLSessionTask *)task didReceiveData:(NSData *)data;
//- (void)recordTask:(NSURLSessionTask *)task didReceiveResponse:(NSURLResponse *)response;
//- (void)recordTask:(NSURLSessionTask *)task didFinishWithError:(NSError *)arg1;
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
    
    for (int i = 0; i < outCount; i++) {
        Method m = methods[i];
        SEL sourceMethod = method_getName(m);
        const char *encoding = method_getTypeEncoding(m);
        NSString *sourceMethodName = NSStringFromSelector(sourceMethod);
        NSAssert([sourceMethodName hasPrefix:@"JSZ_"], @"Expecting swizzle methods only");
        NSString *originalMethodName = [sourceMethodName substringFromIndex:4];
        SEL originalMethod = NSSelectorFromString(originalMethodName);
        NSAssert(originalMethod, @"Must find selector");
        
        IMP sourceImp = method_getImplementation(m);
        
        IMP originalImp = class_getMethodImplementation(cfURLSessionConnectionClass, originalMethod);
        
        NSAssert(originalImp, @"Must find imp");
        
        BOOL success = class_addMethod(cfURLSessionConnectionClass, sourceMethod, originalImp, encoding);
        NSAssert(success, @"Should be successful");
        IMP replacedImp = class_replaceMethod(cfURLSessionConnectionClass, originalMethod, sourceImp, encoding);
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
    NSString *pointerString = [JSZVCR uniqueStringFromObject:task];
    JSZVCRRecording *recording = self.recordings[pointerString];
    if (recording.data) {
        NSLog(@"already had a response: %@", recording.data);
    }
    recording.data = data;
}

- (void)recordTask:(NSURLSessionTask *)task didReceiveResponse:(NSURLResponse *)response {
    if (!_enabled) {
        return;
    }
    NSString *pointerString = [JSZVCR uniqueStringFromObject:task];
    if (!self.recordings[pointerString]) {
        self.recordings[pointerString] = [JSZVCRRecording recordingWithTask:task];
    }
    JSZVCRRecording *recording = self.recordings[pointerString];
    if (recording.response) {
        NSLog(@"already had a response: %@", recording.response);
    }
    recording.response = response;
    
}

- (void)recordTask:(NSURLSessionTask *)task didFinishWithError:(NSError *)arg1 {
    if (!_enabled) {
        return;
    }
    NSString *pointerString = [JSZVCR uniqueStringFromObject:task];
    JSZVCRRecording *recording = self.recordings[pointerString];
    if (recording.error) {
        NSLog(@"already had a response: %@", recording.error);
    }
    recording.error = arg1;
}

+ (NSString *)uniqueStringFromObject:(id)object {
    uintptr_t pointer_as_integer = (uintptr_t)object;
    return [@(pointer_as_integer) stringValue];
}

- (NSArray *)allRecordings {
    return [self.recordings allValues];
}

- (void)dumpRecordingsToFile:(NSString *)aPathFile {
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"recordings.plist"];
//    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
//    {
//        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"recordings" ofType:@"plist"];
//        [[NSFileManager defaultManager] copyItemAtPath:bundle toPath:plistPath error:&error];
//    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"file.plist"];
    NSLog(@"filePath = %@", filePath);
    NSMutableArray *dumpArray = [NSMutableArray array];
    for (JSZVCRRecording *recording in self.recordings.allValues) {
        [dumpArray addObject:recording.dictionaryRepresentation];
    }
    [dumpArray writeToFile:filePath atomically:YES];
}

@end

// For reference from the private class dump
//@interface __NSCFURLSessionConnection : NSObject
//
//- (void)_redirectRequest:(id)arg1 redirectResponse:(id)arg2 completion:(void (^)(id arg))arg3;
//- (void)_conditionalRequirementsChanged:(BOOL)arg1;
//- (void)_connectionIsWaiting;
//- (void)_willSendRequestForEstablishedConnection:(id)arg1 completion:(void (^)(NSURLRequest *arg3))arg2;
//- (void)_didReceiveConnectionCacheKey:(struct HTTPConnectionCacheKey *)arg1;
//- (void)_didFinishWithError:(id)arg1;
//- (void)_didSendBodyData:(struct UploadProgressInfo)arg1;
//- (void)_didReceiveData:(id)arg1;
//- (void)_didReceiveResponse:(id)arg1 sniff:(BOOL)arg2;
//
//@end

//@interface __NSCFURLSessionConnection_Swizzles : NSObject
//
//@property(copy) NSURLSessionTask *task; // @synthesize task=_task;
//
//@end
//
//@implementation __NSCFURLSessionConnection_Swizzles
//
//@dynamic task;
//
//- (void)JSZ__redirectRequest:(NSURLRequest *)arg1 redirectResponse:(NSURLResponse *)arg2 completion:(id)arg3;
//{
//    [[JSZVCR sharedInstance] recordTask:self.task redirectRequest:arg1 redirectResponse:arg2];
//    [self JSZ__redirectRequest:arg1 redirectResponse:arg2 completion:arg3];
//}
//
//- (void)JSZ__didReceiveData:(id)arg1;
//{
//    [[JSZVCR sharedInstance] recordTask:self.task didReceiveData:arg1];
//    [self JSZ__didReceiveData:arg1];
//}
//
//- (void)JSZ__didReceiveResponse:(NSURLResponse *)response sniff:(BOOL)sniff;
//{
//    // This can be called multiple times for the same request. Make sure it doesn't
//    [[JSZVCR sharedInstance] recordTask:self.task didReceiveResponse:response];
//    [self JSZ__didReceiveResponse:response sniff:sniff];
//}
//
//- (void)JSZ__didFinishWithError:(NSError *)arg1;
//{
//    [[JSZVCR sharedInstance] recordTask:self.task didFinishWithError:arg1];
//    [self JSZ__didFinishWithError:arg1];
//}
//
//@end
