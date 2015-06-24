//
//  JSZVCRNSURLSessionConnection.m
//  Pods
//
//  Created by Jordan Zucker on 6/8/15.
//
//
#import <objc/runtime.h>

#import "JSZVCRRecorder.h"
#import "JSZVCRNSURLSessionConnection.h"
#import "NSURLSessionTask+JSZVCRAdditions.h"

// for further looking in the future
//https://github.com/nst/iOS-Runtime-Headers/blob/7ef0330f961248b9021e59e12aa3182440194817/Frameworks/CFNetwork.framework/__NSCFLocalSessionBridge.h
//https://github.com/nst/iOS-Runtime-Headers/blob/7ef0330f961248b9021e59e12aa3182440194817/Frameworks/CFNetwork.framework/__NSCFURLSessionTask.h
//https://github.com/nst/iOS-Runtime-Headers/blob/7ef0330f961248b9021e59e12aa3182440194817/Frameworks/CFNetwork.framework/__NSCFLocalSessionTask.h

// For reference from the private class dump for iOS 7
//dealloc
//replaceTask:withDownloadTask:
//taskTerminating:
//_onqueue_invokeInvalidateCallback
//copyTasks
//initWithConfiguration:session:queue:
//invalidateSession:withQueue:completion:
//dataTaskForRequest:completion:
//uploadTaskForRequest:uploadFile:bodyData:completion:
//downloadTaskForRequest:resumeData:completion:
//flushStorageWithCompletionHandler:
//resetStorageWithCompletionHandler:
//classicConnectionSession
//statusMessage:
//bridgeInvalidated:
//operationCompleted:
//connToTask:
//taskCreated:
//task:wasRedirected:newRequest:responseCallback:
//task:didReceiveResponse:
//task:willCacheResponse:responseCallback:
//task:didFinishLoadingWithError:
//task:request:needsNewBodyStreamCallback:
//task:challenged:authCallback:
//task:didReceiveData:
//task:sentBodyBytes:totalBytes:expectedBytes:
//demuxv:args:
//_onqueue_connectUploadTask:strippedRequest:bodyStream:bodyParts:
//taskForClass:request:uploadFile:bodyData:completion:
//_onqueue_withDataTaskForSession:perform:
//_onqueue_checkForCompletion
//_onqueue_withDownloadTaskForSession:perform:
//taskDidFinishLoading:

// https://github.com/nst/iOS-Runtime-Headers/blob/master/Frameworks/CFNetwork.framework/__NSCFURLSessionConnection.h
//- (void)task:(id)arg1 challenged:(struct _CFURLAuthChallenge { }*)arg2 authCallback:(id)arg3;
//- (void)task:(id)arg1 didFinishLoadingWithError:(struct __CFError { }*)arg2;
//- (void)task:(id)arg1 didReceiveData:(id)arg2;
//- (void)task:(id)arg1 didReceiveResponse:(struct _CFURLResponse { }*)arg2;
//- (void)task:(id)arg1 request:(struct _CFURLRequest { }*)arg2 needsNewBodyStreamCallback:(id)arg3;
//- (void)task:(id)arg1 sentBodyBytes:(id)arg2 totalBytes:(id)arg3 expectedBytes:(id)arg4;
//- (void)task:(id)arg1 wasRedirected:(struct _CFURLResponse { }*)arg2 newRequest:(struct _CFURLRequest { }*)arg3 responseCallback:(id)arg4;
//- (void)task:(id)arg1 willCacheResponse:(struct _CFCachedURLResponse { }*)arg2 responseCallback:(id)arg3;
//- (void)taskCreated:(id)arg1;
//- (void)taskDidFinishLoading:(id)arg1;
//- (id)taskForClass:(Class)arg1 request:(id)arg2 uploadFile:(id)arg3 bodyData:(id)arg4 completion:(id)arg5;
//- (void)taskTerminating:(id)arg1;

// For reference from the private class dump for iOS 8
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

@implementation JSZVCRNSURLSessionConnection
@dynamic task;

+ (void)swizzleNSURLSessionClasses
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
        if ([systemVersion hasPrefix:@"7"]) {
            [self _swizzleNSURLSessionClassesForIOS7];
        } else {
            [self _swizzleNSURLSessionClassesForIOS8];
        }
    });
}

+ (void)_swizzleNSURLSessionClassesForIOS8 {
    Class cfURLSessionConnectionClass = NSClassFromString(@"__NSCFURLSessionConnection");
    if (!cfURLSessionConnectionClass) {
        NSLog(@"Could not find __NSCFURLSessionConnection");
        return;
    }
    
    unsigned int outCount = 0;
    Method *methods = class_copyMethodList([self class], &outCount);
    //    Method *methods = class_copyMethodList(cfURLSessionConnectionClass, &outCount);
    
    for (int i = 0; i < outCount; i++) {
        Method m = methods[i];
        SEL sourceMethod = method_getName(m);
        const char *encoding = method_getTypeEncoding(m);
        NSString *sourceMethodName = NSStringFromSelector(sourceMethod);
        //        NSLog(@"%@", sourceMethodName);
//        NSAssert([sourceMethodName hasPrefix:@"JSZ_iOS8_"], @"Expecting swizzle methods only");
        if (![sourceMethodName hasPrefix:@"JSZ_iOS8_"]) {
            continue;
        }
        NSString *originalMethodName = [sourceMethodName substringFromIndex:9];
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

+ (void)_swizzleNSURLSessionClassesForIOS7 {
    Class cfURLLocalSessionBridge = NSClassFromString(@"__NSCFLocalSessionBridge");
    if (!cfURLLocalSessionBridge) {
        NSLog(@"could not find __NSCURLocalSessionBridge");
        return;
    }
    
    unsigned int outCount = 0;
    Method *methods = class_copyMethodList([self class], &outCount);
//    Method *methods = class_copyMethodList(cfURLLocalSessionBridge, &outCount);
    
    for (int i = 0; i < outCount; i++) {
        Method m = methods[i];
        SEL sourceMethod = method_getName(m);
        const char *encoding = method_getTypeEncoding(m);
        NSString *sourceMethodName = NSStringFromSelector(sourceMethod);
        NSLog(@"%@", sourceMethodName);
//        NSAssert([sourceMethodName hasPrefix:@"JSZ_iOS7_"], @"Expecting swizzle methods only");
        if (![sourceMethodName hasPrefix:@"JSZ_iOS7_"]) {
            continue;
        }
        NSString *originalMethodName = [sourceMethodName substringFromIndex:9];
        SEL originalMethod = NSSelectorFromString(originalMethodName);
        NSAssert(originalMethod, @"Must find selector");
        
        IMP sourceImp = method_getImplementation(m);
        
        IMP originalImp = class_getMethodImplementation(cfURLLocalSessionBridge, originalMethod);
        
        NSAssert(originalImp, @"Must find imp");
        
        __unused BOOL success = class_addMethod(cfURLLocalSessionBridge, sourceMethod, originalImp, encoding);
        NSAssert(success, @"Should be successful");
        __unused IMP replacedImp = class_replaceMethod(cfURLLocalSessionBridge, originalMethod, sourceImp, encoding);
        NSAssert(replacedImp, @"Expected original method to have been replaced");
    }
    
    if (methods) {
        free(methods);
    }
}

#pragma mark - iOS 7 Internal NSURLSession

- (void)JSZ_iOS7_task:(id)arg1 challenged:(struct _CFURLAuthChallenge { }*)arg2 authCallback:(id)arg3 {
    [self JSZ_iOS7_task:arg1 challenged:arg2 authCallback:arg3];
}

- (void)JSZ_iOS7_task:(id)arg1 didFinishLoadingWithError:(struct __CFError { }*)arg2 {
    [self JSZ_iOS7_task:arg1 didFinishLoadingWithError:arg2];
}

- (void)JSZ_iOS7_task:(id)arg1 didReceiveData:(id)arg2 {
    [self JSZ_iOS7_task:arg1 didReceiveData:arg2];
}

- (void)JSZ_iOS7_task:(id)arg1 didReceiveResponse:(struct _CFURLResponse { }*)arg2 {
    [self JSZ_iOS7_task:arg1 didReceiveResponse:arg2];
}

- (void)JSZ_iOS7_task:(id)arg1 request:(struct _CFURLRequest { }*)arg2 needsNewBodyStreamCallback:(id)arg3 {
    [self JSZ_iOS7_task:arg1 request:arg2 needsNewBodyStreamCallback:arg3];
}

- (void)JSZ_iOS7_task:(id)arg1 sentBodyBytes:(id)arg2 totalBytes:(id)arg3 expectedBytes:(id)arg4 {
    [self JSZ_iOS7_task:arg1 sentBodyBytes:arg2 totalBytes:arg3 expectedBytes:arg4];
}

- (void)JSZ_iOS7_task:(id)arg1 wasRedirected:(struct _CFURLResponse { }*)arg2 newRequest:(struct _CFURLRequest { }*)arg3 responseCallback:(id)arg4 {
    [self JSZ_iOS7_task:arg1 wasRedirected:arg2 newRequest:arg3 responseCallback:arg4];
}

- (void)JSZ_iOS7_task:(id)arg1 willCacheResponse:(struct _CFCachedURLResponse { }*)arg2 responseCallback:(id)arg3 {
    [self JSZ_iOS7_task:arg1 willCacheResponse:arg2 responseCallback:arg3];
}

- (void)JSZ_iOS7_taskCreated:(id)arg1 {
    if (![arg1 isKindOfClass:NSClassFromString(@"__NSCFLocalDataTask")]) {
        return;
    }
    NSURLSessionTask *task = (NSURLSessionTask *)arg1;
//    if (!task.globallyUniqueIdentifier) {
//        task.globallyUniqueIdentifier = [NSUUID UUID].UUIDString;
//    }
    [self JSZ_iOS7_taskCreated:task];
}

- (void)JSZ_iOS7_taskDidFinishLoading:(id)arg1 {
    [self JSZ_iOS7_taskDidFinishLoading:arg1];
}

- (void)JSZ_iOS7_taskTerminating:(id)arg1 {
    [self JSZ_iOS7_taskTerminating:arg1];
}

#pragma mark - iOS 8 Internal NSURLSession

- (void)JSZ_iOS8_setTask:(NSURLSessionTask *)task {
    if (!task.globallyUniqueIdentifier) {
        task.globallyUniqueIdentifier = [NSUUID UUID].UUIDString;
    }
    [self JSZ_iOS8_setTask:task];
}

- (void)JSZ_iOS8_cancel {
    if (!self.task.globallyUniqueIdentifier) {
        self.task.globallyUniqueIdentifier = [NSUUID UUID].UUIDString;
    }
    [[JSZVCRRecorder sharedInstance] recordTaskCancellation:self.task];
    [self JSZ_iOS8_cancel];
}

- (instancetype)JSZ_iOS8_initWithTask:(NSURLSessionTask *)task delegate:(id <NSURLSessionDelegate>)delegate delegateQueue:(NSOperationQueue *)queue {
    if (!task.globallyUniqueIdentifier) {
        task.globallyUniqueIdentifier = [NSUUID UUID].UUIDString;
    }
    return [self JSZ_iOS8_initWithTask:task delegate:delegate delegateQueue:queue];
}

- (void)JSZ_iOS8__redirectRequest:(NSURLRequest *)arg1 redirectResponse:(NSURLResponse *)arg2 completion:(id)arg3;
{
    if (!self.task.globallyUniqueIdentifier) {
        self.task.globallyUniqueIdentifier = [NSUUID UUID].UUIDString;
    }
    [[JSZVCRRecorder sharedInstance] recordTask:self.task redirectRequest:arg1 redirectResponse:arg2];
    [self JSZ_iOS8__redirectRequest:arg1 redirectResponse:arg2 completion:arg3];
}

- (void)JSZ_iOS8__didReceiveData:(id)data;
{
    if (!self.task.globallyUniqueIdentifier) {
        self.task.globallyUniqueIdentifier = [NSUUID UUID].UUIDString;
    }
    [[JSZVCRRecorder sharedInstance] recordTask:self.task didReceiveData:data];
    [self JSZ_iOS8__didReceiveData:data];
}

- (void)JSZ_iOS8__didReceiveResponse:(NSURLResponse *)response sniff:(BOOL)sniff;
{
    if (!self.task.globallyUniqueIdentifier) {
        self.task.globallyUniqueIdentifier = [NSUUID UUID].UUIDString;
    }
    // This can be called multiple times for the same request. Make sure it doesn't
    [[JSZVCRRecorder sharedInstance] recordTask:self.task didReceiveResponse:response];
    [self JSZ_iOS8__didReceiveResponse:response sniff:sniff];
}

- (void)JSZ_iOS8__didFinishWithError:(NSError *)error;
{
    if (!self.task.globallyUniqueIdentifier) {
        self.task.globallyUniqueIdentifier = [NSUUID UUID].UUIDString;
    }
    [[JSZVCRRecorder sharedInstance] recordTask:self.task didFinishWithError:error];
    [self JSZ_iOS8__didFinishWithError:error];
}

@end
