//
//  JSZVCRNSURLSessionConnection.m
//  Pods
//
//  Created by Jordan Zucker on 6/8/15.
//
//
#import "JSZVCR.h"

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

- (void)JSZ_setTask:(NSURLSessionTask *)task {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"task: %@", task);
    [self JSZ_setTask:task];
}

- (instancetype)JSZ_initWithTask:(NSURLSessionTask *)task delegate:(id <NSURLSessionDelegate>)delegate delegateQueue:(NSOperationQueue *)queue {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if (!task.globallyUniqueIdentifier) {
        task.globallyUniqueIdentifier = [NSUUID UUID].UUIDString;
    }
    return [self JSZ_initWithTask:task delegate:delegate delegateQueue:queue];
}

- (void)JSZ__redirectRequest:(NSURLRequest *)arg1 redirectResponse:(NSURLResponse *)arg2 completion:(id)arg3;
{
    [[JSZVCR sharedInstance] recordTask:self.task redirectRequest:arg1 redirectResponse:arg2];
    [self JSZ__redirectRequest:arg1 redirectResponse:arg2 completion:arg3];
}

- (void)JSZ__didReceiveData:(id)arg1;
{
    [[JSZVCR sharedInstance] recordTask:self.task didReceiveData:arg1];
    [self JSZ__didReceiveData:arg1];
}

- (void)JSZ__didReceiveResponse:(NSURLResponse *)response sniff:(BOOL)sniff;
{
    // This can be called multiple times for the same request. Make sure it doesn't
    [[JSZVCR sharedInstance] recordTask:self.task didReceiveResponse:response];
    [self JSZ__didReceiveResponse:response sniff:sniff];
}

- (void)JSZ__didFinishWithError:(NSError *)arg1;
{
    [[JSZVCR sharedInstance] recordTask:self.task didFinishWithError:arg1];
    [self JSZ__didFinishWithError:arg1];
}
@end
