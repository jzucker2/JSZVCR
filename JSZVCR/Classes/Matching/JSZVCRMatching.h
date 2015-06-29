//
//  JSZVCRMatching.h
//  Pods
//
//  Created by Jordan Zucker on 6/19/15.
//
//

#import <Foundation/Foundation.h>

/**
 *  This protocol is what any matcher object must conform to for matching requests to responses.
 */
@protocol JSZVCRMatching <NSObject>

/**
 *  This is basically an init method, you should return the object for matching
 *
 *  @return newly initialized matcher object conforming to this protocol
 */
+ (id<JSZVCRMatching>)matcher;

/**
 *  Whether or not we should stub a network response for a specific request
 *
 *  @param request    The request sent
 *  @param recordings An array of all the available recordings to match against
 *
 *  @return whether or not to respond to this request
 */
- (BOOL)hasResponseForRequest:(NSURLRequest *)request inRecordings:(NSArray *)recordings;

- (NSDictionary *)responseForRequest:(NSURLRequest *)request inRecordings:(NSArray *)recordings;

@optional

- (NSDictionary *)infoForRequest:(NSURLRequest *)request inRecordings:(NSArray *)recordings;

/**
 *  Overrides testCase level JSZVCRTestingStrictness to deal with failure or passing of
 *  individual requests at a granular level. Useful for whitelisting specific requests
 *  in your framework during the course of a test run by returning NO
 *
 *  @param request request that failed to match
 *
 *  @return returning YES allows unmatched request to go to Internet while returning
 *  NO respects the JSZVCRTestingStrictness value returned by - (JSZVCRTestingStrictness)matchingFailStrictness
 *  in JSZVCRTestCase
 */
- (BOOL)shouldAllowUnmatchedRequest:(NSURLRequest *)request;


@end
