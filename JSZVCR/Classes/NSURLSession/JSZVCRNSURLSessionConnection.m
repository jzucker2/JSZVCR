//
//  JSZVCRNSURLSessionConnection.m
//  Pods
//
//  Created by Jordan Zucker on 6/8/15.
//
//
#if TARGET_OS_IPHONE
    #import <UIKit/UIKit.h>
#endif
#import <objc/runtime.h>

#import "JSZVCRRecorder.h"
#import "JSZVCRNSURLSessionConnection.h"
#import "NSURLSessionTask+JSZVCRAdditions.h"

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

@implementation JSZVCRNSURLSessionConnection
@dynamic task;

+ (void)swizzleNSURLSessionClasses
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self _swizzleNSURLSessionClasses];
    });
}

+ (void)_swizzleNSURLSessionClasses;
{
    NSString *overrideSessionConnectionClassString = nil;
#if TARGET_OS_IOS
    if ([[[UIDevice currentDevice] systemVersion] hasPrefix:@"8"]) {
        overrideSessionConnectionClassString = @"__NSCFURLSessionConnection";
    } else {
        overrideSessionConnectionClassString = @"__NSCFURLLocalSessionConnection";
    }
#else
    overrideSessionConnectionClassString = @"__NSCFURLLocalSessionConnection";
#endif
    Class cfURLSessionConnectionClass = NSClassFromString(overrideSessionConnectionClassString);
    if (!cfURLSessionConnectionClass) {
        NSLog(@"Could not find __NSCFURLSessionConnection. It is possible that JSZVCR cannot yet record in this configuration. Please try another platform, system version, or device type.");
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

- (void)JSZ_cancel {
    [self.task uniqueify];
    [[JSZVCRRecorder sharedInstance] recordTaskCancellation:self.task];
    [self JSZ_cancel];
}

- (instancetype)JSZ_initWithTask:(NSURLSessionTask *)task delegate:(id <NSURLSessionDelegate>)delegate delegateQueue:(NSOperationQueue *)queue {
    [task uniqueify];
    return [self JSZ_initWithTask:task delegate:delegate delegateQueue:queue];
}

- (void)JSZ__redirectRequest:(NSURLRequest *)arg1 redirectResponse:(NSURLResponse *)arg2 completion:(id)arg3;
{
    [self.task uniqueify];
    [[JSZVCRRecorder sharedInstance] recordTask:self.task redirectRequest:arg1 redirectResponse:arg2];
    [self JSZ__redirectRequest:arg1 redirectResponse:arg2 completion:arg3];
}

- (void)JSZ__didReceiveData:(id)data;
{
    [self.task uniqueify];
    [[JSZVCRRecorder sharedInstance] recordTask:self.task didReceiveData:data];
    [self JSZ__didReceiveData:data];
}

- (void)JSZ__didReceiveResponse:(NSURLResponse *)response sniff:(BOOL)sniff;
{
    [self.task uniqueify];
    // This can be called multiple times for the same request. Make sure it doesn't
    [[JSZVCRRecorder sharedInstance] recordTask:self.task didReceiveResponse:response];
    [self JSZ__didReceiveResponse:response sniff:sniff];
}

- (void)JSZ__didFinishWithError:(NSError *)error;
{
    [self.task uniqueify];
    [[JSZVCRRecorder sharedInstance] recordTask:self.task didFinishWithError:error];
    [self JSZ__didFinishWithError:error];
}

@end
