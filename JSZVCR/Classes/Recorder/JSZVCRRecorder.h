//
//  JSZVCRRecorder.h
//  Pods
//
//  Created by Jordan Zucker on 6/11/15.
//
//

#import <Foundation/Foundation.h>

@class XCTestCase;

/**
 *  This records all network activity
 */
@interface JSZVCRRecorder : NSObject

/**
 *  Whether or not network activity should be recorded
 */
@property (nonatomic, getter=isEnabled) BOOL enabled;

/**
 *  Singleton instance is used so we don't have to pass in a 
 *  reference to every disparate network connection
 *
 *  @return singleton recorder instance
 */
+ (instancetype)sharedInstance;

/**
 *  Reset all recorded values
 */
- (void)reset;

/**
 *  Called by JSZVCRNSURLSessionConnection
 *
 *  @param task in flight network task
 *  @param arg1 redirect request
 *  @param arg2 response for redirect
 */
- (void)recordTask:(NSURLSessionTask *)task redirectRequest:(NSURLRequest *)arg1 redirectResponse:(NSURLResponse *)arg2;

/**
 *  Called by JSZVCRNSURLSessionConnection
 *
 *  @param task in flight network task
 *  @param data data received from network task
 */
- (void)recordTask:(NSURLSessionTask *)task didReceiveData:(NSData *)data;

/**
 *  Called by JSZVCRNSURLSessionConnection. May be called multiple times.
 *
 *  @param task in flight network task
 *  @param response Response received from server
 */
- (void)recordTask:(NSURLSessionTask *)task didReceiveResponse:(NSURLResponse *)response;
/**
 *  Called by JSZVCRNSURLSessionConnection. Error will only 
 *  be passed if something goes wrong.
 *
 *  @param task in flight network task
 *  @param arg1 error from network request
 */
- (void)recordTask:(NSURLSessionTask *)task didFinishWithError:(NSError *)arg1;
/**
 *  Called by JSZVCRNSURLSessionConnection. This is called 
 *  when [task cancel] is called.
 *
 *  @param task in flight network task
 */
- (void)recordTaskCancellation:(NSURLSessionTask *)task;

/**
 *  All recordings from this instance
 *
 *  @return array of JSZVCRRecordings
 */
- (NSArray *)allRecordings;
/**
 *  All recordings from this instance as Foundation objects, 
 *  similar to NSJSONSerialization
 *
 *  @return array of Foundation objects
 */
- (NSArray *)allRecordingsForPlist;

/**
 *  Save contents of recorder to disk with full file path. Creates any intermediary directories.
 *
 *  @param recorder instance with network data to serialize to disk
 *  @param filePath full file path to save information, including file path and
 *  extension. File won't save if you don't have write permissions
 *
 *  @return reflects whether save was successful
 */
- (BOOL)saveToDiskWithFilePath:(NSString *)filePath;

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
- (BOOL)saveToDiskForTest:(XCTestCase *)testCase;

@end
