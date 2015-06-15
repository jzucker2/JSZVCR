//
//  JSZVCRResourceManager.h
//  Pods
//
//  Created by Jordan Zucker on 6/15/15.
//
//

#import <Foundation/Foundation.h>

@class XCTestCase;
@class JSZVCRRecorder;

@interface JSZVCRResourceManager : NSObject

+ (NSString *)pathForFile:(NSString *)fileName inBundleForClass:(Class)classInBundle;
+ (NSString *)pathForFile:(NSString *)fileName inBundle:(NSBundle *)bundle;
+ (NSString *)pathForFileMatchingTest:(XCTestCase *)testCase inBundle:(NSBundle *)bundle;
+ (NSBundle *)bundleWithName:(NSString *)bundleName containingClass:(Class)classInBundle;
+ (NSString *)pathForFileMatchingTest:(XCTestCase *)testCase; // look in default bundle

+ (NSArray *)networkResponsesForFilePath:(NSString *)filePath;
+ (NSArray *)networkResponsesForTest:(XCTestCase *)testCase;


+ (void)saveToDisk:(JSZVCRRecorder *)recorder;

@end
