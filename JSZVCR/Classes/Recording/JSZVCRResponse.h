//
//  JSZVCRResponse.h
//  Pods
//
//  Created by Jordan Zucker on 6/9/15.
//
//

#import <Foundation/Foundation.h>
#import "JSZVCRSerializer.h"

/**
 * Represents all the responses over the course of a network request
 */
@interface JSZVCRResponse : NSObject <JSZVCRSerializer>

/**
 *  Designated initializer for an object representing a request's responses
 *
 *  @param response valid response object
 *
 *  @return newly initialized instance representing a network request
 */
- (instancetype)initWithResponse:(NSURLResponse *)response;

/**
 *  Convenience method for an object representing a request's responses
 *
 *  @param response valid response object
 *
 *  @return newly initialized instance representing a network request
 */
+ (instancetype)responseWithResponse:(NSURLResponse *)response;

/**
 *  Valid Foundation response object that this class represents
 */
@property (nonatomic, copy) NSURLResponse *response;

@end
