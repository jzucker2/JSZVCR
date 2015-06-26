//
//  JSZVCR.h
//  Pods
//
//  Created by Jordan Zucker on 6/8/15.
//
//

#import <Foundation/Foundation.h>
#import "JSZVCRTestCase.h"
#import "JSZVCRMatching.h"
#import "JSZVCRSimpleURLMatcher.h"
#import "JSZVCRUnorderedQueryMatcher.h"

@class JSZVCRRecorder;

/**
 *  This class is responsible for coordinating the recording and playing
 */
@interface JSZVCR : NSObject

/**
 *  reflects whether in recording or playing mode
 */
@property (nonatomic, getter=isRecording) BOOL recording;

/**
 *  Current test case that is being run
 */
@property (nonatomic) XCTestCase *currentTestCase;

/**
 *  Current stored recordings associated with this vcr's player instance
 */
@property (nonatomic, readonly) NSArray *currentStoredRecordings;

/**
 *  Set the response matching strictness during a playback test run
 */
@property (nonatomic) JSZVCRTestingStrictness matchFailStrictness;

/**
 *  Delegate handles feedback for JSZVCRPlayer during a playback run
 */
@property (nonatomic, weak) id<JSZVCRPlayerDelegate> playerDelegate;

/**
 *  Convenience method for creating VCR object with matcherClass, supplies a singleton JSZVCRRecorder
 *
 *  @param matcherClass class conforming to protocol JSZVCRMatching
 *
 *  @return a newly intialized VCR instance
 */
+ (instancetype)vcrWithMatcherClass:(Class<JSZVCRMatching>)matcherClass;

/**
 *  Designated initializer for VCR object
 *
 *  @param matcherClass class conforming to protocol JSZVCRMatching
 *  @param recorder     recorder object, should be singleton
 *
 *  @return a newly intialized VCR instance
 */
- (instancetype)initWithMatcherClass:(Class<JSZVCRMatching>)matcherClass
                            recorder:(JSZVCRRecorder *)recorder;

/**
 *  Swizzle all NSURLSession methods with recording on by default
 */
- (void)swizzleNSURLSessionClasses;

/**
 *  Remove all OHHTTP network responses
 */
- (void)removeAllNetworkResponses;

/**
 *  Save all test recordings
 */
- (void)saveTestRecordings;

@end
