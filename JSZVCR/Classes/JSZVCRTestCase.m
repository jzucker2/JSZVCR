//
//  JSZVCRTestCase.m
//  Pods
//
//  Created by Jordan Zucker on 6/11/15.
//
//
#import <OHHTTPStubs/OHHTTPStubs.h>

#import "JSZVCRTestCase.h"
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
    [[JSZVCRResourceLoader sharedInstance] setTest:testCase];
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
    return [NSString stringWithFormat:@"%s", __FILE__];
}

+ (void)setUp {
    [super setUp];
    [[JSZVCRResourceLoader sharedInstance] setResourceBundle:[self bundleNameContainingResponses] containingClass:self.class];
}

- (void)setUp {
    [super setUp];
    if (self.recording) {
        [JSZVCRRecorder swizzleNSURLSessionClasses];
        [[JSZVCRRecorder sharedInstance] setEnabled:YES];
    } else {
        [[JSZVCRRecorder sharedInstance] setEnabled:NO];
    }
}

+ (void)tearDown {
    [[JSZVCRResourceLoader sharedInstance] setResourceBundle:nil containingClass:self.class];
    [super tearDown];
}

- (void)tearDown {
    [OHHTTPStubs removeAllStubs];
    [[JSZVCRResourceLoader sharedInstance] setTest:nil];
    [super tearDown];
}

@end
