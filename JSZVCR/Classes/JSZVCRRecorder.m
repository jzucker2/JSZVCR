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

#import "NSURLSessionTask+JSZVCRAdditions.h"

@interface JSZVCRRecorder ()
@property (nonatomic) NSMutableDictionary *recordings;
@property (nonatomic) dispatch_queue_t recordingQueue;
@end

@implementation JSZVCRRecorder

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
        _recordingQueue = dispatch_queue_create("com.JSZ.recordingQueue", DISPATCH_QUEUE_SERIAL);
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
    __typeof (self) wself = self;
    dispatch_async(self.recordingQueue, ^{
        __typeof (wself) sself = wself;
        if (!sself) {
            return;
        }
        JSZVCRRecording *recording = [sself storedRecordingFromTask:task];
        if (recording.data) {
            NSLog(@"already had data: %@", recording.data);
        }
        recording.data = [JSZVCRData dataWithData:data];
    });
}

- (void)recordTask:(NSURLSessionTask *)task didReceiveResponse:(NSURLResponse *)response {
    if (!self.enabled) {
        return;
    }
    __typeof (self) wself = self;
    dispatch_async(self.recordingQueue, ^{
        __typeof (wself) sself = wself;
        if (!sself) {
            return;
        }
        JSZVCRRecording *recording = [sself storedRecordingFromTask:task];
        if (recording.response) {
            NSLog(@"already had response: %@", recording.response);
        }
        recording.response = [JSZVCRResponse responseWithResponse:response];
    });
}

- (void)recordTask:(NSURLSessionTask *)task didFinishWithError:(NSError *)error {
    if (!self.enabled) {
        return;
    }
    __typeof (self) wself = self;
    dispatch_async(self.recordingQueue, ^{
        __typeof (wself) sself = wself;
        if (!sself) {
            return;
        }
        JSZVCRRecording *recording = [sself storedRecordingFromTask:task];
        recording.error = error;
    });
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
