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

@interface JSZVCRTestCase () <JSZVCRPlayerDelegate>
@property (nonatomic) JSZVCR *vcr;
@end

@implementation JSZVCRTestCase

- (BOOL)isRecording {
    return YES;
}

- (JSZVCRTestingStrictness)matchingFailStrictness {
    return JSZVCRTestingStrictnessNone;
}

- (Class<JSZVCRMatching>)matcherClass {
    return [JSZVCRSimpleURLMatcher class];
}

- (instancetype)initWithInvocation:(NSInvocation *)invocation {
    self = [super initWithInvocation:invocation];
    if (self) {
        _vcr = [JSZVCR vcrWithMatcherClass:self.matcherClass];
        _vcr.playerDelegate = self;
        _vcr.currentTestCase = self;
        _vcr.recording = [self isRecording];
        _vcr.matchFailStrictness = [self matchingFailStrictness];
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

#pragma mark - JSZVCRPlayerDelegate

- (void)testCase:(XCTestCase *)testCase withUnmatchedRequest:(NSURLRequest *)request shouldFail:(BOOL)shouldFail {
    if (shouldFail) {
        XCTFail(@"Unmatched request: %@", request);
    }
}

@end
