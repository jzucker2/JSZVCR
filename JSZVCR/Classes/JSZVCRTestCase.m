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
#import "JSZVCRResourceLoader.h"
#import "JSZVCRRecorder.h"

@interface JSZVCRTestCase ()
//@property (nonatomic) BOOL recording;
@end

@implementation JSZVCRTestCase

- (BOOL)recording {
    return NO;
}

- (instancetype)initWithInvocation:(NSInvocation *)invocation {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return [super initWithInvocation:invocation];
}

//- (instancetype)initWithSelector:(SEL)selector {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//    return [super initWithSelector:selector];
//}

+ (instancetype)testCaseWithInvocation:(NSInvocation *)invocation {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    JSZVCRTestCase *testCase = [super testCaseWithInvocation:invocation];
    [[JSZVCRResourceLoader sharedInstance] setResourceBundle:[self bundleNameContainingResponses] containingClass:self.class];
//    [[JSZVCRResourceLoader sharedInstance] setTest:testCase];
    return testCase;
}

//+ (instancetype)testCaseWithSelector:(SEL)selector {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//    NSLog(@"%@", NSStringFromSelector(selector));
//    return [super testCaseWithSelector:selector];
//}

- (JSZVCRTestingStrictness)testingStrictnessForSelector:(SEL)testCaseSelector {
    return JSZVCRTestingStrictnessNone;
}

- (NSDictionary *)responseForReqeust:(NSURLRequest *)request {
    return nil;
}

- (NSArray *)responsesForSelector:(SEL)testCaseSelector {
    return nil;
}

+ (NSString *)bundleNameContainingResponses {
//    NSString *fullFilePathString = [NSString stringWithFormat:@"%s", __FILE__];
//    return [[fullFilePathString lastPathComponent] stringByDeletingPathExtension];
    return NSStringFromClass(self);
}

//+ (void)setUp {
//    [super setUp];
//    [[JSZVCRResourceLoader sharedInstance] setResourceBundle:[self bundleNameContainingResponses] containingClass:self.class];
//}

- (void)setUp {
    [super setUp];
    if (self.recording) {
        // only swizzle if you have to
        [[JSZVCR sharedInstance] swizzleNSURLSessionClasses];
        [[JSZVCRRecorder sharedInstance] setEnabled:YES];
    } else {
        [[JSZVCRRecorder sharedInstance] setEnabled:NO];
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            return [[JSZVCRResourceLoader sharedInstance] hasResponseForRequest:request];
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
            // Stub it with our "wsresponse.json" stub file (which is in same bundle as self)
            NSDictionary *responseDict = [[JSZVCRResourceLoader sharedInstance] responseForRequest:request];
            return [OHHTTPStubsResponse responseWithData:responseDict[@"data"]
                                              statusCode:[responseDict[@"statusCode"] intValue]
                                                 headers:responseDict[@"httpHeaders"]];
        }];
    }
}

+ (void)tearDown {
    [[JSZVCRResourceLoader sharedInstance] setResourceBundle:nil containingClass:self.class];
    [super tearDown];
}

- (void)tearDown {
    [OHHTTPStubs removeAllStubs];
    [[JSZVCRRecorder sharedInstance] dumpRecordingsToFile:@"test"];
//    [[JSZVCRResourceLoader sharedInstance] setTest:nil];
    [super tearDown];
}

@end
