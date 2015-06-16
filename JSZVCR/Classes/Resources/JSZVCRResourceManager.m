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

+ (void)saveToDisk:(JSZVCRRecorder *)recorder {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *filePathComponent = [NSString stringWithFormat:@"%@.plist", [NSUUID UUID].UUIDString];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:filePathComponent];
    NSLog(@"filePath = %@", filePath);
    NSMutableArray *dumpArray = [NSMutableArray array];
    for (JSZVCRRecording *recording in recorder.allRecordings) {
        [dumpArray addObject:recording.dictionaryRepresentation];
    }
    [dumpArray writeToFile:filePath atomically:YES];
}

@end
