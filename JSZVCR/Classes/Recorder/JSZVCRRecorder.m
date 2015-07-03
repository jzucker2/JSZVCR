//
//  JSZVCRRecorder.m
//  Pods
//
//  Created by Jordan Zucker on 6/11/15.
//
//

#import "JSZVCRRecorder.h"
#import "JSZVCRRecording.h"
#import "JSZVCRNSURLSessionConnection.h"
#import "JSZVCRRequest.h"
#import "JSZVCRData.h"
#import "JSZVCRResponse.h"
#import "JSZVCRError.h"

#import "NSURLSessionTask+JSZVCRAdditions.h"

@interface JSZVCRRecorder ()
@property (nonatomic) NSMutableDictionary *recordings;
@property (nonatomic) dispatch_queue_t recordingQueue;
@end

@implementation JSZVCRRecorder

@synthesize recordings = _recordings;
@synthesize enabled = _enabled;

+ (instancetype)sharedInstance {
    static JSZVCRRecorder *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[JSZVCRRecorder alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _recordingQueue = dispatch_queue_create("com.JSZ.recordingQueue", DISPATCH_QUEUE_CONCURRENT);
        _recordings = [NSMutableDictionary dictionary];
        _enabled = YES;
    }
    return self;
}

- (void)reset {
    [self.recordings removeAllObjects];
}

#pragma mark - NSURLSession recording

- (void)recordTask:(NSURLSessionTask *)task redirectRequest:(NSURLRequest *)arg1 redirectResponse:(NSURLResponse *)arg2 {
    if (!self.enabled) {
        return;
    }
    
}

- (void)recordTask:(NSURLSessionTask *)task didReceiveData:(NSData *)data {
    if (!self.enabled) {
        return;
    }
    JSZVCRRecording *recording = [self storedRecordingFromTask:task];
    if (recording.data) {
        NSLog(@"already had data: %@", recording.data);
    }
    recording.data = [JSZVCRData dataWithData:data];
}

- (void)recordTask:(NSURLSessionTask *)task didReceiveResponse:(NSURLResponse *)response {
    if (!self.enabled) {
        return;
    }
    JSZVCRRecording *recording = [self storedRecordingFromTask:task];
    if (recording.response) {
        NSLog(@"already had response: %@", recording.response);
    }
    recording.response = [JSZVCRResponse responseWithResponse:response];
}

- (void)recordTask:(NSURLSessionTask *)task didFinishWithError:(NSError *)error {
    if (!self.enabled) {
        return;
    }
    JSZVCRRecording *recording = [self storedRecordingFromTask:task];
    if (error) {
        recording.error = [JSZVCRError errorWithError:error];
    }
}

- (void)recordTaskCancellation:(NSURLSessionTask *)task {
    if (!self.enabled) {
        return;
    }
    JSZVCRRecording *recording = [self storedRecordingFromTask:task];
    recording.cancelled = YES;
}

//- (id)cacheObjectForKey: (id)key
//{
//    __block obj;
//    dispatch_sync(_queue, ^{
//        obj = [[_cache objectForKey: key] retain];
//    });
//    return [obj autorelease];
//}

- (JSZVCRRecording *)storedRecordingFromTask:(NSURLSessionTask *)task {
//    NSString *globallyUniqueIdentifier = task.globallyUniqueIdentifier;
//    JSZVCRRecording *recordingToReturn = nil;
//    if (!self.recordings[globallyUniqueIdentifier]) {
//        recordingToReturn = [JSZVCRRecording recordingWithTask:task];
//        self.recordings[globallyUniqueIdentifier] = recordingToReturn;
//    } else {
//        recordingToReturn = self.recordings[globallyUniqueIdentifier];
//    }
//    return recordingToReturn;
    NSString *globallyUniqueIdentifier = task.globallyUniqueIdentifier;
    JSZVCRRecording *recordingToReturn = [self recordingForKey:globallyUniqueIdentifier];
    if (!recordingToReturn) {
        recordingToReturn = [JSZVCRRecording recordingWithTask:task];
        [self setRecording:recordingToReturn forKey:globallyUniqueIdentifier];
    } else {
        recordingToReturn = [self recordingForKey:globallyUniqueIdentifier];
    }
    return recordingToReturn;
}

- (NSArray *)allRecordings {
    return [self.recordings allValues];
}

- (NSArray *)allRecordingsForPlist {
    NSMutableArray *dumpArray = [NSMutableArray array];
    for (JSZVCRRecording *recording in self.allRecordings) {
        [dumpArray addObject:recording.dictionaryRepresentation];
    }
    return [dumpArray copy];
}

#pragma mark - Recordings race handling

// https://www.mikeash.com/pyblog/friday-qa-2011-10-14-whats-new-in-gcd.html

//- (id)cacheObjectForKey: (id)key
//{
//    __block obj;
//    dispatch_sync(_queue, ^{
//        obj = [[_cache objectForKey: key] retain];
//    });
//    return [obj autorelease];
//}
- (JSZVCRRecording *)recordingForKey:(NSString *)key {
    __block id obj;
    dispatch_sync(self.recordingQueue, ^{
        obj = [_recordings objectForKey:key];
    });
    return obj;
}

//- (void)setCacheObject: (id)obj forKey: (id)key
//{
//    dispatch_barrier_async(_queue, ^{
//        [_cache setObject: obj forKey: key];
//    });
//}
- (void)setRecording:(JSZVCRRecording *)recording forKey:(NSString *)key {
    dispatch_barrier_async(self.recordingQueue, ^{
        [_recordings setObject:recording forKey:key];
    });
}

@end
