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


@end
