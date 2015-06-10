//
//  JSZVCRResourceLoader.m
//  Pods
//
//  Created by Jordan Zucker on 6/10/15.
//
//

//NSBundle* OHResourceBundle(NSString* bundleBasename, Class inBundleForClass)
//{
//    NSBundle* classBundle = [NSBundle bundleForClass:inBundleForClass];
//    return [NSBundle bundleWithPath:[classBundle pathForResource:bundleBasename
//                                                          ofType:@"bundle"]];
//}
#import <XCTest/XCTest.h>

#import "JSZVCRResourceLoader.h"

@interface JSZVCRResourceLoader ()
@property (nonatomic) NSString *networkInfoPath;
@property (nonatomic) NSBundle *bundle;
@property (nonatomic) NSArray *networkInfo;

@end

@implementation JSZVCRResourceLoader

+ (instancetype)sharedInstance {
    static JSZVCRResourceLoader *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[JSZVCRResourceLoader alloc] init];
    });
    return sharedInstance;
}

- (NSString *)pathForFile:(NSString *)fileName bundleForClass:(Class)classInBundle {
    NSBundle *bundle = [NSBundle bundleForClass:classInBundle];
    return [self pathForFile:fileName inBundle:bundle];
}

- (NSString *)pathForFile:(NSString *)fileName inBundle:(NSBundle *)bundle {
    return [bundle pathForResource:fileName.stringByDeletingPathExtension
                            ofType:fileName.pathExtension];
}

- (NSString *)pathForFileMatchingTest:(XCTestCase *)testCase inBundle:(NSBundle *)bundle {
    NSString *currentTestCaseMethod = NSStringFromSelector(testCase.invocation.selector);
    NSString *filePath = [NSString stringWithFormat:@"%@.plist", currentTestCaseMethod];
    return [self pathForFile:filePath inBundle:bundle];
}

- (NSString *)pathForFileMatchingTest:(XCTestCase *)testCase {
//    NSBundle *bundle = [NSBundle bundleForClass:testCase.class];
    NSAssert(self.bundle, @"Bundle must be set before this will work");
    return [self pathForFileMatchingTest:testCase inBundle:self.bundle];
}

- (NSBundle *)bundleWithName:(NSString *)bundleName containingClass:(Class)classInBundle {
    NSBundle *classBundle = [NSBundle bundleForClass:classInBundle];
    return [NSBundle bundleWithPath:[classBundle pathForResource:bundleName ofType:@"bundle"]];
}

//+ (NSDictionary *)responseForOHHTTPStubsWith:(id)networkInfo forRequest:(NSURLRequest *)request {
//    
//}

- (void)setTest:(XCTestCase *)testCase {
//    self.networkInfo = [[self class] pathForFileMatchingTest:testCase];
    self.networkInfoPath = [self pathForFileMatchingTest:testCase];
    NSAssert(self.networkInfoPath, @"No path found for testCase: %@", testCase);
    self.networkInfo = [[NSArray alloc] initWithContentsOfFile:self.networkInfoPath];
}

- (void)setResourceBundle:(NSString *)bundleName containingClass:(__unsafe_unretained Class)classInBundle {
    self.bundle = [self bundleWithName:bundleName containingClass:classInBundle];
}

//- (void)setNetworkResponses:(id)networkResponses {
//    _networkInfo = networkResponses;
//}

- (BOOL)hasResponseForRequest:(NSURLRequest *)request {
    NSDictionary *info = [self infoForRequest:request];
    return (info != nil);
}

- (NSDictionary *)infoForRequest:(NSURLRequest *)request {
    for (NSDictionary *info in self.networkInfo) {
        NSString *currentRequestURLString = info[@"request"][@"currentRequest"][@"URL"];
        NSString *originalRequestURLString = info[@"request"][@"originalRequest"][@"URL"];
        if ([request.URL.absoluteString isEqualToString:currentRequestURLString] ||
            [request.URL.absoluteString isEqualToString:originalRequestURLString]) {
            return info;
        }
    }
    return nil;
}

- (NSDictionary *)responseForRequest:(NSURLRequest *)request {
    NSDictionary *info = [self infoForRequest:request];
    
    if (!info) {
        return nil;
    }
    
    NSDictionary *responseDictionary = info[@"response"][@"response"];
    NSNumber *responseCode = responseDictionary[@"statusCode"];
    NSDictionary *headersDict = responseDictionary[@"allHeaderFields"];
    NSData *data = info[@"data"][@"data"];
    return @{
             @"statusCode" : responseCode,
             @"httpHeaders" : headersDict,
             @"data" : data
             };
}



@end
