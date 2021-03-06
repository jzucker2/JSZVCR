//
//  JSZVCR.h
//  Pods
//
//  Created by Jordan Zucker on 6/8/15.
//
//

#import <Foundation/Foundation.h>
#if JSZTESTING
    #import "JSZVCRTestCase.h"
#else
    #import "JSZVCRPlayerDelegate.h"
#endif
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
 *  Default is NO, when isDisabled == YES, recording and playback are both 
 *  turned off. This typically only be called during tearDown
 */
@property (nonatomic, getter=isDisabled) BOOL disabled;

/**
 *  Current stored recordings associated with this vcr's player instance
 */
@property (nonatomic, readonly) NSArray *currentStoredRecordings;

/**
 *  Set the response matching strictness during a playback test run
 */
@property (nonatomic) JSZVCRMatchingStrictness matchFailStrictness;

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
 *  Remove all OHHTTP stubbed network responses
 */
- (void)removeAllNetworkResponses;

/**
 *  Removes all recordings from memory of JSZVCRRecorder instance
 */
- (void)removeAllUnsavedRecordings;

/**
 *  tearDown recordings for XCTest
 */
- (void)tearDown;

#if JSZTESTING

/**
 *  Save all test recordings
 */
- (void)saveTestRecordings;

/**
 *  Current test case that is being run
 */
@property (nonatomic) XCTestCase *currentTestCase;

#endif

@end
