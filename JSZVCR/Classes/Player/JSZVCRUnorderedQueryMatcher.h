//
//  JSZVCRUnorderedQueryMatcher.h
//  Pods
//
//  Created by Jordan Zucker on 6/20/15.
//
//

#import <Foundation/Foundation.h>
#import "JSZVCRMatching.h"

/**
 *  This class will compare the components of a NSURL in a request with the components of a NSURL from recordings. It does so without respect to the ordering of the items in the query of the URL, in case the query is built in a different order.
 */
@interface JSZVCRUnorderedQueryMatcher : NSObject <JSZVCRMatching>

@end
