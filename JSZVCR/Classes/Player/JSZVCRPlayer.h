//
//  JSZVCRPlayer.h
//  Pods
//
//  Created by Jordan Zucker on 6/11/15.
//
//

#import <Foundation/Foundation.h>
#import "JSZVCRMatching.h"

/**
 * Strictness level for unmatched network calls during a test run
 */
typedef NS_ENUM(NSInteger, JSZVCRTestingStrictness){
    /**
     *  No strictness for unmatched network requests (default)
     */
    JSZVCRTestingStrictnessNone = 0,
    /**
     *  Fail any test with unmatched network requests
     */
    JSZVCRTestingStrictnessFailWhenNoMatch
};

#if JSZTESTING
@class XCTestCase;
#endif

@protocol JSZVCRPlayerDelegate;

/**
 *  This plays all recordings during a test run
 */
@interface JSZVCRPlayer : NSObject


/**
 *  Whether or not the response replayer is active
 */
@property (nonatomic, getter=isEnabled) BOOL enabled;

/**
 *  Set the response matching strictness during a playback test run
 */
@property (nonatomic) JSZVCRTestingStrictness matchFailStrictness;

/**
 *  All available network responses for a test case
 */
@property (nonatomic, readonly) NSArray *networkResponses;
/**
 *  The matcher to use to for comparing networkResponses to requests
 */
@property (nonatomic) id<JSZVCRMatching> matcher; // might not be safe to change this during a test run if there's lots of async network calls

/**
 *  Delegate provides feedback for status of run during execution
 */
@property (nonatomic, weak) id<JSZVCRPlayerDelegate>delegate;

/**
 *  Initialize a player with a type of matcher class
 *
 *  @param matcherClass Class conforming to JSZVCRMatching protocol to be used during test runs
 *
 *  @return Newly initialized player instance
 */
- (instancetype)initWithMatcherClass:(Class<JSZVCRMatching>)matcherClass;

/**
 *  Convenience method for player with type of matcher.
 *
 *  @param matcherClass matcherClass Class conforming to JSZVCRMatching protocol to be used during test runs
 *
 *  @return Newly initialized player instance
 */
+ (instancetype)playerWithMatcherClass:(Class<JSZVCRMatching>)matcherClass;

/**
 *  Clean up after each test run/usage
 */
- (void)tearDown;

#if JSZTESTING
/**
 *  Current test case to be stubbing
 */
@property (nonatomic) XCTestCase *currentTestCase;

#endif

@end

/**
 *  This is for relaying testing state during a run
 */
@protocol JSZVCRPlayerDelegate <NSObject>

#if JSZTESTING
/**
 *  This provides an update if a testCase encounters an unmatched request
 *
 *  @param testCase   currently executing test case
 *  @param request  request that just failed to be matched
 *  @param shouldFail if YES then test should be failed (in line with JSZVCRTestingStrictnessFailWhenNoMatch)
 */
- (void)testCase:(XCTestCase *)testCase withUnmatchedRequest:(NSURLRequest *)request shouldFail:(BOOL)shouldFail;

#else
/**
 *  This is provided when there is no XCTestCase as a framework for recording and replaying
 * 
 *  @param request
 *  @param request  request that just failed to be matched
 *  @param shouldFail if YES then test should be failed (in line with JSZVCRTestingStrictnessFailWhenNoMatch)
 */
- (void)unmatchedRequest:(NSURLRequest *)request shouldFail:(BOOL)shouldFail;
#endif

@end
