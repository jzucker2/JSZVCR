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

+ (instancetype)vcrWithMatcherClass:(Class<JSZVCRMatching>)matcherClass {
    JSZVCRRecorder *recorder = [JSZVCRRecorder sharedInstance];
    // should probably reset recorder for every VCR instance, just in case it already had data
    [recorder reset];
    return [[self alloc] initWithMatcherClass:matcherClass recorder:recorder];
}

- (instancetype)initWithMatcherClass:(Class<JSZVCRMatching>)matcherClass recorder:(JSZVCRRecorder *)recorder {
    self = [super init];
    if (self) {
        _player = [JSZVCRPlayer playerWithMatcherClass:matcherClass];
        _recorder = recorder;
        _disabled = NO;
    }
    return self;
}

- (void)setDisabled:(BOOL)disabled {
    _disabled = disabled;
    self.recorder.enabled = _disabled;
    self.player.enabled = _disabled;
}

- (void)tearDown {
    self.recorder.enabled = NO;
    [self.player tearDown];
}

- (void)setRecording:(BOOL)recording {
    _recording = recording;
    if (_recording) {
        [self swizzleNSURLSessionClasses];
    }
    self.recorder.enabled = _recording;
    self.player.enabled = (!_recording);
}

- (void)setPlayerDelegate:(id<JSZVCRPlayerDelegate>)playerDelegate {
    self.player.delegate = playerDelegate;
}

- (BOOL)isRecording {
    return _recording;
}

- (NSArray *)currentStoredRecordings {
    return self.player.networkResponses;
}

- (void)setMatchFailStrictness:(JSZVCRTestingStrictness)matchFailStrictness {
    _matchFailStrictness = matchFailStrictness;
    self.player.matchFailStrictness = _matchFailStrictness;
}

- (void)swizzleNSURLSessionClasses {
    [JSZVCRNSURLSessionConnection swizzleNSURLSessionClasses];
}

- (void)setCurrentTestCase:(XCTestCase *)currentTestCase {
    _currentTestCase = currentTestCase;
    self.player.currentTestCase = _currentTestCase;
}

- (void)removeAllNetworkResponses {
    [self.player tearDown];
}

- (void)removeAllUnsavedRecordings {
    [self.recorder reset];
}

- (void)saveTestRecordings {
    [self.recorder saveToDiskForTest:self.currentTestCase];
    [self.recorder reset];
}



@end

