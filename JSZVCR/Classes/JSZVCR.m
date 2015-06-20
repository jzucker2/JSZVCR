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
    }
    return self;
}

- (void)setRecording:(BOOL)recording {
    _recording = recording;
    self.recorder.enabled = _recording;
    self.player.enabled = (!_recording);
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

- (void)removeAllNetworkResponses {
    [self.player removeAllNetworkResponses];
}

- (void)saveTestRecordings {
    [JSZVCRResourceManager saveToDisk:self.recorder forTest:self.currentTestCase];
    [self.recorder reset];
}



@end

