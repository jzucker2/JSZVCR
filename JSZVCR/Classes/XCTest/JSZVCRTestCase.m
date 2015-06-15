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
//@property (nonatomic) BOOL recording;
@property (nonatomic) JSZVCR *vcr;
@end

@implementation JSZVCRTestCase

- (BOOL)recording {
    return NO;
}

- (instancetype)initWithInvocation:(NSInvocation *)invocation {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    self = [super initWithInvocation:invocation];
    if (self) {
        _vcr = [JSZVCR vcr];
        _vcr.currentTestCase = self;
        _vcr.recording = [self recording];
    }
    return self;
}

//- (instancetype)initWithSelector:(SEL)selector {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//    return [super initWithSelector:selector];
//}

//+ (instancetype)testCaseWithInvocation:(NSInvocation *)invocation {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//    JSZVCRTestCase *testCase = [super testCaseWithInvocation:invocation];
////    [[JSZVCRResourceLoader sharedInstance] setResourceBundle:[self bundleNameContainingResponses] containingClass:self.class];
////    [[JSZVCRResourceLoader sharedInstance] setTest:testCase];
//    return testCase;
//}

//+ (instancetype)testCaseWithSelector:(SEL)selector {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//    NSLog(@"%@", NSStringFromSelector(selector));
//    return [super testCaseWithSelector:selector];
//}

//- (JSZVCRTestingStrictness)testingStrictnessForSelector:(SEL)testCaseSelector {
//    return JSZVCRTestingStrictnessNone;
//}

//- (NSDictionary *)responseForReqeust:(NSURLRequest *)request {
//    return nil;
//}
//
//- (NSArray *)responsesForSelector:(SEL)testCaseSelector {
//    return nil;
//}
//
//+ (NSString *)bundleNameContainingResponses {
////    NSString *fullFilePathString = [NSString stringWithFormat:@"%s", __FILE__];
////    return [[fullFilePathString lastPathComponent] stringByDeletingPathExtension];
//    return NSStringFromClass(self);
//}
//
////+ (void)setUp {
////    [super setUp];
////    [[JSZVCRResourceLoader sharedInstance] setResourceBundle:[self bundleNameContainingResponses] containingClass:self.class];
////}
//
- (void)setUp {
    [super setUp];
    if (self.vcr.isRecording) {
        // only swizzle if you have to
        [self.vcr swizzleNSURLSessionClasses];
        [self.vcr setRecording:YES];
    } else {
        [[JSZVCRRecorder sharedInstance] setEnabled:NO];
        [self.vcr setRecording:NO];
        
//        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
//            return [[JSZVCRResourceLoader sharedInstance] hasResponseForRequest:request];
//        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
//            // Stub it with our "wsresponse.json" stub file (which is in same bundle as self)
//            NSDictionary *responseDict = [[JSZVCRResourceLoader sharedInstance] responseForRequest:request];
//            return [OHHTTPStubsResponse responseWithData:responseDict[@"data"]
//                                              statusCode:[responseDict[@"statusCode"] intValue]
//                                                 headers:responseDict[@"httpHeaders"]];
//        }];
    }
}
//
//+ (void)tearDown {
////    [[JSZVCRResourceLoader sharedInstance] setResourceBundle:nil containingClass:self.class];
//    [super tearDown];
//}
//
- (void)tearDown {
    [OHHTTPStubs removeAllStubs];
    [self.vcr dumpRecordingsToFile:@"test"];
    [super tearDown];
}

@end
