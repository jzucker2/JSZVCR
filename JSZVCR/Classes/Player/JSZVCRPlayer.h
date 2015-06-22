//
//  JSZVCRPlayer.h
//  Pods
//
//  Created by Jordan Zucker on 6/11/15.
//
//

#import <Foundation/Foundation.h>
#import "JSZVCRMatching.h"

@class XCTestCase;

/**
 *  This plays all recordings during a test run
 */
@interface JSZVCRPlayer : NSObject


/**
 *  Whether or not the response replayer is active
 */
@property (nonatomic, getter=isEnabled) BOOL enabled;
/**
 *  Current test case to be stubbing
 */
@property (nonatomic) XCTestCase *currentTestCase;
/**
 *  All available network responses for a test case
 */
@property (nonatomic, readonly) NSArray *networkResponses;
/**
 *  The matcher to use to for comparing networkResponses to requests
 */
@property (nonatomic) id<JSZVCRMatching> matcher; // might not be safe to change this during a test run if there's lots of async network calls

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
 *  Clean up after each test run
 */
- (void)removeAllNetworkResponses;

@end
