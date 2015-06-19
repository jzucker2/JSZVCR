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
#import "JSZVCRSimpleURLMatcher.h"

@interface JSZVCRTestCase ()
@property (nonatomic) JSZVCR *vcr;
@end

@implementation JSZVCRTestCase

- (BOOL)recording {
    return NO;
}

- (id<JSZVCRMatching>)matcher {
    return [JSZVCRSimpleURLMatcher matcher];
}

- (instancetype)initWithInvocation:(NSInvocation *)invocation {
    self = [super initWithInvocation:invocation];
    if (self) {
        _vcr = [JSZVCR vcrWithMatcher:self.matcher];
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
        // only set matcher if not recording
        
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
