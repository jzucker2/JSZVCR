//
//  JSZVCRError.h
//  Pods
//
//  Created by Jordan Zucker on 6/29/15.
//
//

#import <Foundation/Foundation.h>
#import "JSZVCRSerializer.h"

/**
 *  Represents error objects in recordings
 */
@interface JSZVCRError : NSObject <JSZVCRSerializer>

/**
 *  Convenience initializer for created error recordings from plists
 *
 *  @param errorDictionary dictionary from plist of error
 *
 *  @return newly initialized error recording
 */
- (instancetype)initWithDictionary:(NSDictionary *)errorDictionary;

/**
 *  Initializer for created error recordings from plists
 *
 *  @param errorDictionary errorDictionary dictionary from plist of error
 *
 *  @return newly initialized error recording
 */
+ (instancetype)errorWithDictionary:(NSDictionary *)errorDictionary;

/**
 *  Initializer for error recording from network error
 *
 *  @param error from a network request
 *
 *  @return newly initialized error recording
 */
- (instancetype)initWithError:(NSError *)error;

/**
 *  Convenience initializer for error recording from network error
 *
 *  @param error error from a network request
 *
 *  @return newly initialized error recording
 */
+ (instancetype)errorWithError:(NSError *)error;

/**
 *  Domain from NSError
 */
@property (nonatomic, readonly) NSString *domain;

/**
 *  Code from NSError, represented as object for easier serialization
 */
@property (nonatomic, readonly) NSNumber *code;

/**
 *  userInfo from NSError, needs to be checked for only Foundation objects
 */
@property (nonatomic, readonly) NSDictionary *userInfo;

/**
 *  This is the localizedDescription from the error object
 */
@property (nonatomic, readonly) NSString *errorDescription;

/**
 *  This creates an NSError based on the current properties
 */
@property (nonatomic, readonly) NSError *networkError;

@end
