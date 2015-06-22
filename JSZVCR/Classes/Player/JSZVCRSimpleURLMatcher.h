//
//  JSZVCRSimpleURLMatcher.h
//  Pods
//
//  Created by Jordan Zucker on 6/19/15.
//
//

#import "JSZVCRMatching.h"

/**
 *  Matches by directly comparing the string of the NSURL of a NSURLRequest 
 *  with the recorded strings representing the NSURL of a NSURLRequest
 *  recorded from previous runs.
 */
@interface JSZVCRSimpleURLMatcher : NSObject <JSZVCRMatching>

@end
