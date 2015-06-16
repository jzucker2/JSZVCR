//
//  JSZVCRTestCase.m
//  Pods
//
//  Created by Jordan Zucker on 6/11/15.
//
//
#import <OHHTTPStubs/OHHTTPStubs.h>

#import "JSZVCRTestCase.h"
#import "JSZVCR.h"
#import "JSZVCRResourceManager.h"
#import "JSZVCRRecorder.h"

@interface JSZVCRTestCase ()
@property (nonatomic) JSZVCR *vcr;
@end

@implementation JSZVCRTestCase

- (BOOL)recording {
    return NO;
}

- (instancetype)initWithInvocation:(NSInvocation *)invocation {
    self = [super initWithInvocation:invocation];
    if (self) {
        _vcr = [JSZVCR vcr];
        _vcr.currentTestCase = self;
        _vcr.recording = [self recording];
    }
    return self;
}

- (void)setUp {
    [super setUp];
    if (self.vcr.isRecording) {
        // only swizzle if you have to
        [self.vcr swizzleNSURLSessionClasses];
        [self.vcr setRecording:YES];
    } else {
        [self.vcr setRecording:NO];
    }
}

- (void)tearDown {
    [self.vcr removeAllNetworkResponses];
    if (self.vcr.isRecording) {
        [self.vcr saveTestRecordings];
    }
    [super tearDown];
}

@end
