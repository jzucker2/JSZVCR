//
//  JSZVCRResourceManager.m
//  Pods
//
//  Created by Jordan Zucker on 6/15/15.
//
//
#import <XCTest/XCTest.h>

#import "JSZVCRResourceManager.h"
#import "JSZVCRRecorder.h"
#import "JSZVCRRecording.h"

@implementation JSZVCRResourceManager

#pragma mark - Class File Path Helper Methods

+ (NSString *)pathForFile:(NSString *)fileName inBundleForClass:(Class)classInBundle {
    NSBundle *bundle = [NSBundle bundleForClass:classInBundle];
    return [self pathForFile:fileName inBundle:bundle];
}

+ (NSString *)pathForFile:(NSString *)fileName inBundle:(NSBundle *)bundle {
    return [bundle pathForResource:fileName.stringByDeletingPathExtension
                            ofType:fileName.pathExtension];
}

+ (NSString *)pathForFileMatchingTest:(XCTestCase *)testCase inBundle:(NSBundle *)bundle {
    NSString *currentTestCaseMethod = NSStringFromSelector(testCase.invocation.selector);
    NSString *filePath = [NSString stringWithFormat:@"%@.plist", currentTestCaseMethod];
    return [self pathForFile:filePath inBundle:bundle];
}

+ (NSBundle *)bundleWithName:(NSString *)bundleName containingClass:(Class)classInBundle {
    NSBundle *classBundle = [NSBundle bundleForClass:classInBundle];
    return [NSBundle bundleWithPath:[classBundle pathForResource:bundleName ofType:@"bundle"]];
}

+ (NSString *)pathForFileMatchingTest:(XCTestCase *)testCase {
    return [self pathForFileMatchingTest:testCase inBundle:[self bundleWithName:NSStringFromClass(testCase.class) containingClass:testCase.class]];
}

+ (NSArray *)networkResponsesForFilePath:(NSString *)filePath {
    NSParameterAssert(filePath);
    return [[NSArray alloc] initWithContentsOfFile:filePath];
}

+ (NSArray *)networkResponsesForTest:(XCTestCase *)testCase {
    NSParameterAssert(testCase);
    return [self networkResponsesForFilePath:[self pathForFileMatchingTest:testCase]];
}

+ (NSBundle *)bundleForTestInDocumentsDirectory:(XCTestCase *)testCase {
    NSParameterAssert(testCase);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *bundleName = [NSString stringWithFormat:@"%@.bundle", NSStringFromClass(testCase.class)];
    NSString *bundlePath = [documentsPath stringByAppendingPathComponent:bundleName];
    BOOL isDir;
    if (![[NSFileManager defaultManager] fileExistsAtPath:bundlePath isDirectory:&isDir]) {
        NSError *bundleCreationError = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:bundlePath withIntermediateDirectories:YES attributes:nil error:&bundleCreationError];
        NSLog(@"bundleCreationError: %@", bundleCreationError);
    }
    return [NSBundle bundleWithPath:bundlePath];
}

+ (void)saveToDisk:(JSZVCRRecorder *)recorder {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *filePathComponent = [NSString stringWithFormat:@"%@.plist", [NSUUID UUID].UUIDString];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:filePathComponent];
    NSLog(@"filePath = %@", filePath);
    NSArray *dumpArray = recorder.allRecordingsForPlist;
    [dumpArray writeToFile:filePath atomically:YES];
}

+ (void)saveToDisk:(JSZVCRRecorder *)recorder forTest:(XCTestCase *)testCase {
    NSBundle *documentsBundle = [self bundleForTestInDocumentsDirectory:testCase];
    NSString *currentTestCaseMethod = NSStringFromSelector(testCase.invocation.selector);
    NSString *fileName = [NSString stringWithFormat:@"%@.plist", currentTestCaseMethod];
    NSString *filePath = [documentsBundle.bundlePath stringByAppendingPathComponent:fileName];
    NSLog(@"filePath = %@", filePath);
    NSArray *dumpArray = recorder.allRecordingsForPlist;
    [dumpArray writeToFile:filePath atomically:YES];
}

@end
