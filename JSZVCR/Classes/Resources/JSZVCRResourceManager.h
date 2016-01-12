//
//  JSZVCRResourceManager.h
//  Pods
//
//  Created by Jordan Zucker on 6/15/15.
//
//

#import <Foundation/Foundation.h>

#if JSZTESTING
@class XCTestCase;
#endif
@class JSZVCRRecorder;

/**
 *  Collection of class methods for dealing with file system loading and saving
 */
@interface JSZVCRResourceManager : NSObject

/**
 *  Returns complete path for a file located in the bundle 
 *  that also contains the provided class
 *
 *  @param fileName      name of file to save
 *  @param classInBundle class contained in the bundle you are 
 *  looking you are also looking for a file in
 *
 *  @return full path in where file is located or nil if file doesn't exist
 */
+ (NSString *)pathForFile:(NSString *)fileName inBundleForClass:(Class)classInBundle;

/**
 *  Returns complete path to for a valid file in a bundle
 *
 *  @param fileName name of file to save
 *  @param bundle   bundle in which to look for file
 *
 *  @return full path for file or nil if it doesn't exist
 */
+ (NSString *)pathForFile:(NSString *)fileName inBundle:(NSBundle *)bundle;

/**
 *  Valid bundle with name containing provided class
 *
 *  @param bundleName    bundle name to look for matching bundle
 *  @param classInBundle class contained in bundle in which to look for bundleName
 *
 *  @return valid bundle or nil if bundle with bundleName cannot be found
 */
+ (NSBundle *)bundleWithName:(NSString *)bundleName containingClass:(Class)classInBundle;

/**
 *  Network responses as Foundation objects located at filePath (assumed to be a plist)
 *
 *  @param filePath filePath containing plist of network responses
 *
 *  @return array of network request/responses as Foundation objects 
 *  or nil if file does not exist
 */
+ (NSArray *)networkResponsesForFilePath:(NSString *)filePath;

/**
 *  Save contents of recorder to disk with full file path. Creates any intermediary directories.
 *
 *  @param recorder instance with network data to serialize to disk
 *  @param filePath full file path to save information, including file path and
 *  extension. File won't save if you don't have write permissions
 *
 *  @return reflects whether save was successful
 */
+ (BOOL)saveToDisk:(JSZVCRRecorder *)recorder withFilePath:(NSString *)filePath;

#if JSZTESTING
/**
 *  Returns complete path for valid file matching test case located in a bundle
 *
 *  @param testCase test case for corresponding file (files are automatically
 *  named for test cases @see saveToDisk:forTest:
 *  @param bundle   bundle in which to look for file
 *
 *  @return full path for file or nil if it doesn't exist
 */
+ (NSString *)pathForFileMatchingTest:(XCTestCase *)testCase inBundle:(NSBundle *)bundle;

/**
 *  Path for file matching test case in default bundle
 *
 *  @param testCase assumed that it matches file containing network responses to look up
 *
 *  @return valid file path for matching test case or nil if none exists
 */
+ (NSString *)pathForFileMatchingTest:(XCTestCase *)testCase; // look in default bundle

/**
 *  Network responses as Foundation objects for file with name corresponding to testCase
 *
 *  @param testCase testCase to match against file name
 *
 *  @return array of network request/responses as Foundation objects
 *  or nil if file does not exist
 */
+ (NSArray *)networkResponsesForTest:(XCTestCase *)testCase;

/**
 *  Bundle corresponding to testCase containing network responses for run
 *
 *  @param testCase to match against files in bundle
 *
 *  @return bundle containing test data
 */
+ (NSBundle *)bundleForTestInDocumentsDirectory:(XCTestCase *)testCase;

/**
 *  Save contents of recorder to disk with file name corresponding to testCase,
 *  creating any intermediary directories
 *
 *  @param recorder instance with network data collected
 *  @param testCase used to name corresponding file, placing it in a
 *  NSBundle named after the test suite
 *
 *  @return reflects whether save was successful
 */
+ (BOOL)saveToDisk:(JSZVCRRecorder *)recorder forTest:(XCTestCase *)testCase;

#endif

@end
