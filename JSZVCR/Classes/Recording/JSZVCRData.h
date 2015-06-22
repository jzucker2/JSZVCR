//
//  JSZVCRData.h
//  Pods
//
//  Created by Jordan Zucker on 6/9/15.
//
//

#import <Foundation/Foundation.h>
#import "JSZVCRSerializer.h"

/**
 * Abstract representing NSData associated with a network response
 */
@interface JSZVCRData : NSObject <JSZVCRSerializer>

/**
 *  Designated initializer for recorded data object
 *
 *  @param data network data to record
 *
 *  @return instance representing data from network request
 */
- (instancetype)initWithData:(NSData *)data;

/**
 *  Convenience method for recorded data instance
 *
 *  @param data network data to record
 *
 *  @return instance representing data from network request
 */
+ (instancetype)dataWithData:(NSData *)data;

/**
 *  Data this class associates with a network
 */
@property (nonatomic, copy) NSData *data;

@end
