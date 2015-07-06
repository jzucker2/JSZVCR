//
//  JSZVCRRecorder.m
//  Pods
//
//  Created by Jordan Zucker on 6/11/15.
//
//
#import <XCTest/XCTest.h>

#import "JSZVCRRecorder.h"
#import "JSZVCRRecording.h"
#import "JSZVCRNSURLSessionConnection.h"
#import "JSZVCRRequest.h"
#import "JSZVCRData.h"
#import "JSZVCRResponse.h"
#import "JSZVCRError.h"
#import "JSZVCRResourceManager.h"

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

//- (void)reset {
//    [self.recordings removeAllObjects];
//}

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
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"try to add error");
    if (error) {
        NSLog(@"begin adding error");
        recording.error = [JSZVCRError errorWithError:error];
        NSLog(@"added error");
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

- (NSArray *)allRecordingsForPlist {
    NSMutableArray *dumpArray = [NSMutableArray array];
    for (JSZVCRRecording *recording in self.allRecordings) {
        [dumpArray addObject:recording.dictionaryRepresentation];
    }
    return [dumpArray copy];
}

#pragma mark - Recordings race handling

- (NSArray *)allRecordings {
    __block NSArray *cachedRecordings;
    dispatch_sync(self.recordingQueue, ^{
        NSLog(@"%s", __PRETTY_FUNCTION__);
        cachedRecordings = _recordings.allValues;
    });
    return cachedRecordings;
}

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
        NSLog(@"%s", __PRETTY_FUNCTION__);
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
        NSLog(@"%s", __PRETTY_FUNCTION__);
        [_recordings setObject:recording forKey:key];
    });
}

- (void)reset {
    dispatch_barrier_async(self.recordingQueue, ^{
        NSLog(@"%s", __PRETTY_FUNCTION__);
        [_recordings removeAllObjects];
    });
}

#pragma mark - Saving

//+ (BOOL)saveToDisk:(JSZVCRRecorder *)recorder withFilePath:(NSString *)filePath {
//    // should assert that documents directory isn't automatically appended!
//    NSParameterAssert(filePath);
//    NSAssert([filePath.pathExtension isEqualToString:@"plist"], @"filePath extension must be .plist not %@", filePath.pathExtension);
//    NSLog(@"filePath = %@", filePath);
//    NSArray *dumpArray = recorder.allRecordingsForPlist;
//    return [dumpArray writeToFile:filePath atomically:YES];
//}
//
//+ (BOOL)saveToDisk:(JSZVCRRecorder *)recorder forTest:(XCTestCase *)testCase {
//    NSBundle *documentsBundle = [self bundleForTestInDocumentsDirectory:testCase];
//    NSString *currentTestCaseMethod = NSStringFromSelector(testCase.invocation.selector);
//    NSString *fileName = [NSString stringWithFormat:@"%@.plist", currentTestCaseMethod];
//    NSString *filePath = [documentsBundle.bundlePath stringByAppendingPathComponent:fileName];
//    return [self saveToDisk:recorder withFilePath:filePath];
//}
- (BOOL)saveToDiskWithFilePath:(NSString *)filePath {
    // should assert that documents directory isn't automatically appended!
    NSParameterAssert(filePath);
    NSAssert([filePath.pathExtension isEqualToString:@"plist"], @"filePath extension must be .plist not %@", filePath.pathExtension);
    NSLog(@"filePath = %@", filePath);
    NSArray *dumpArray = self.allRecordingsForPlist;
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return [dumpArray writeToFile:filePath atomically:YES];
}

- (BOOL)saveToDiskForTest:(XCTestCase *)testCase {
    NSBundle *documentsBundle = [JSZVCRResourceManager bundleForTestInDocumentsDirectory:testCase];
    NSString *currentTestCaseMethod = NSStringFromSelector(testCase.invocation.selector);
    NSString *fileName = [NSString stringWithFormat:@"%@.plist", currentTestCaseMethod];
    NSString *filePath = [documentsBundle.bundlePath stringByAppendingPathComponent:fileName];
    return [self saveToDiskWithFilePath:filePath];
}


@end
