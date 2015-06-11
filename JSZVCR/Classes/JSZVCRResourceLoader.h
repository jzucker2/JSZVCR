//
//  JSZVCRResourceLoader.h
//  Pods
//
//  Created by Jordan Zucker on 6/10/15.
//
//

#import <Foundation/Foundation.h>


//NSString* OHPathForFile(NSString* fileName, Class inBundleForClass)
//{
//    NSBundle* bundle = [NSBundle bundleForClass:inBundleForClass];
//    return OHPathForFileInBundle(fileName, bundle);
//}
//
//NSString* OHPathForFileInBundle(NSString* fileName, NSBundle* bundle)
//{
//    return [bundle pathForResource:[fileName stringByDeletingPathExtension]
//                            ofType:[fileName pathExtension]];
//}

//NSBundle* OHResourceBundle(NSString* bundleBasename, Class inBundleForClass)
//{
//    NSBundle* classBundle = [NSBundle bundleForClass:inBundleForClass];
//    return [NSBundle bundleWithPath:[classBundle pathForResource:bundleBasename
//                                                          ofType:@"bundle"]];
//}

@class XCTestCase;

@interface JSZVCRResourceLoader : NSObject

+ (instancetype)sharedInstance;

- (NSString *)pathForFile:(NSString *)fileName bundleForClass:(Class)classInBundle;
- (NSString *)pathForFile:(NSString *)fileName inBundle:(NSBundle *)bundle;
- (NSString *)pathForFileMatchingTest:(XCTestCase *)testCase inBundle:(NSBundle *)bundle;
- (NSString *)pathForFileMatchingTest:(XCTestCase *)testCase;
- (NSBundle *)bundleWithName:(NSString *)bundleName containingClass:(Class)classInBundle;

//+ (NSDictionary *)responseForOHHTTPStubs:(id)networkInfo;

- (BOOL)hasResponseForRequest:(NSURLRequest *)request;
- (NSDictionary *)responseForRequest:(NSURLRequest *)request;
- (void)setTest:(XCTestCase *)testCase;
- (void)setResourceBundle:(NSString *)bundleName containingClass:(Class)classInBundle;

//- (id)resourceForFilePath:(NSString *)filePath;
//- (id)resourceForBundle:(NSBundle *)bundle;
//- (id)resourceForTest:(XCTestCase *)testCase;

@end
