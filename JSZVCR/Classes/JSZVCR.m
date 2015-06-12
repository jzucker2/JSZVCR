//
//  JSZVCR.m
//  Pods
//
//  Created by Jordan Zucker on 6/8/15.
//
//

#import "JSZVCR.h"
#import "JSZVCRRecorder.h"
#import "JSZVCRResourceLoader.h"
#import "JSZVCRPlayer.h"
#import "JSZVCRNSURLSessionConnection.h"

@interface JSZVCR ()
@property (nonatomic, readwrite) XCTestCase *currentTestCase;
@property (nonatomic) JSZVCRRecorder *recorder;
@property (nonatomic) JSZVCRPlayer *player;
@property (nonatomic) JSZVCRResourceLoader *resourceLoader;
@end

@implementation JSZVCR

@synthesize enabled = _enabled;

+ (instancetype)sharedInstance {
    static JSZVCR *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        JSZVCRResourceLoader *resourceLoader = [[JSZVCRResourceLoader alloc] init];
        sharedInstance = [JSZVCR vcrWithResourceLoader:resourceLoader];
    });
    return sharedInstance;
}

+ (instancetype)vcrWithResourceLoader:(JSZVCRResourceLoader *)resourceLoader {
    JSZVCRPlayer *player = [[JSZVCRPlayer alloc] initWithResourceLoader:resourceLoader];
    JSZVCRRecorder *recorder = [JSZVCRRecorder sharedInstance];
    return [[self alloc] initWithResourceLoader:resourceLoader player:player recorder:recorder];
}

- (instancetype)initWithResourceLoader:(JSZVCRResourceLoader *)resourceLoader
                        player:(JSZVCRPlayer *)player
                      recorder:(JSZVCRRecorder *)recorder {
    self = [super init];
    if (self) {
        _resourceLoader = resourceLoader;
        _player = player;
        _recorder = recorder;
    }
    return self;
}

- (void)setEnabled:(BOOL)enabled {
    _enabled = enabled;
    self.recorder.enabled = enabled;
}

- (BOOL)isEnabled {
    return _enabled;
}

- (void)swizzleNSURLSessionClasses {
    [JSZVCRNSURLSessionConnection swizzleNSURLSessionClasses];
}

- (void)dumpRecordingsToFile:(NSString *)filePath {
    [self.resourceLoader saveToDisk:self.recorder];
    [self.recorder reset];
}



@end

