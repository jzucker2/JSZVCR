//
//  JSZVCRPlayerDelegate.h
//  Pods
//
//  Created by Jordan Zucker on 1/11/16.
//
//

#ifndef JSZVCRPlayerDelegate_h
#define JSZVCRPlayerDelegate_h

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
 *  @param shouldFail if YES then test should be failed (in line with JSZVCRMatchingStrictnessFailWhenNoMatch)
 */
- (void)testCase:(XCTestCase *)testCase withUnmatchedRequest:(NSURLRequest *)request shouldFail:(BOOL)shouldFail;

#else
/**
 *  This is provided when there is no XCTestCase as a framework for recording and replaying
 *
 *  @param request
 *  @param request  request that just failed to be matched
 *  @param shouldFail if YES then test should be failed (in line with JSZVCRMatchingStrictnessFailWhenNoMatch)
 */
- (void)unmatchedRequest:(NSURLRequest *)request shouldFail:(BOOL)shouldFail;

/**
 *  Network responses used to match against recorded network calls.
 *
 *  @return array of network responses to parse for matcher
 */
- (NSArray *)networkResponses;
#endif

@end

#endif /* JSZVCRPlayerDelegate_h */
