//
//  JSZVCR.m
//  Pods
//
//  Created by Jordan Zucker on 6/8/15.
//
//

#import "JSZVCR.h"
#import "JSZVCRRecorder.h"
#import "JSZVCRResourceManager.h"
#import "JSZVCRPlayer.h"
#import "JSZVCRNSURLSessionConnection.h"

@interface JSZVCR ()
@property (nonatomic) JSZVCRRecorder *recorder;
@property (nonatomic) JSZVCRPlayer *player;
@end

@implementation JSZVCR

@synthesize recording = _recording;

//+ (instancetype)sharedInstance {
//    static JSZVCR *sharedInstance = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        JSZVCRResourceLoader *resourceLoader = [[JSZVCRResourceLoader alloc] init];
//        sharedInstance = [JSZVCR vcrWithResourceLoader:resourceLoader];
//    });
//    return sharedInstance;
//}

+ (instancetype)vcr {
    JSZVCRPlayer *player = [[JSZVCRPlayer alloc] init];
    JSZVCRRecorder *recorder = [JSZVCRRecorder sharedInstance];
    // should probably reset recorder for every VCR instance, just in case it already had data
    [recorder reset];
    return [[self alloc] initWithPlayer:player recorder:recorder];
}

- (instancetype)initWithPlayer:(JSZVCRPlayer *)player recorder:(JSZVCRRecorder *)recorder {
    self = [super init];
    if (self) {
        _player = player;
        _recorder = recorder;
    }
    return self;
}

- (void)setRecording:(BOOL)recording {
    _recording = recording;
    self.recorder.enabled = recording;
}

- (BOOL)isRecording {
    return _recording;
}

- (void)swizzleNSURLSessionClasses {
    [JSZVCRNSURLSessionConnection swizzleNSURLSessionClasses];
}

- (void)setCurrentTestCase:(XCTestCase *)currentTestCase {
    _currentTestCase = currentTestCase;
    self.player.currentTestCase = _currentTestCase;
}

- (void)dumpRecordingsToFile:(NSString *)filePath {
    [JSZVCRResourceManager saveToDisk:self.recorder];
    [self.recorder reset];
}

- (void)removeAllNetworkResponses {
    [self.player removeAllNetworkResponses];
}



@end

