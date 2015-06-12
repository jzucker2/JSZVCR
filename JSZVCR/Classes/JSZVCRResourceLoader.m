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
#import "JSZVCRRecorder.h"
#import "JSZVCRRecording.h"

@interface JSZVCRResourceLoader ()
@property (nonatomic) NSString *networkInfoPath;
@property (nonatomic) NSBundle *bundle;
@property (nonatomic) NSArray *networkInfo;

@end

@implementation JSZVCRResourceLoader

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

- (void)setResourceBundle:(NSString *)bundleName containingClass:(__unsafe_unretained Class)classInBundle {
    self.bundle = [self bundleWithName:bundleName containingClass:classInBundle];
}

- (void)saveToDisk:(JSZVCRRecorder *)recorder {
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

- (NSArray *)networkInfo {
    return @[];
}

@end
