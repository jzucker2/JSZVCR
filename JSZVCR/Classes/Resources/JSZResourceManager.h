//
//  JSZResourceManager.h
//  Pods
//
//  Created by Jordan Zucker on 6/14/15.
//
//

#import <Foundation/Foundation.h>

@class XCTestCase;

@interface JSZResourceManager : NSObject

+ (NSString *)pathForFile:(NSString *)fileName bundleForClass:(Class)classInBundle;
+ (NSString *)pathForFile:(NSString *)fileName inBundle:(NSBundle *)bundle;
+ (NSString *)pathForFileMatchingTest:(XCTestCase *)testCase inBundle:(NSBundle *)bundle;
+ (NSBundle *)bundleWithName:(NSString *)bundleName containingClass:(Class)classInBundle;

@end
