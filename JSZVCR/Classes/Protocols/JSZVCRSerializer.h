//
//  JSZVCRSerializer.h
//  Pods
//
//  Created by Jordan Zucker on 6/9/15.
//
//

#import <Foundation/Foundation.h>

/**
 *  This is implemented by all objects that are serialized as part of a network request recording
 */
@protocol JSZVCRSerializer <NSObject>

/**
 *  This is called to provide a serializable foundation object representing a more complex object. Similar to NSJONSerialization
 *
 *  @return a dictionary composed entirely of Foundation objects (NSNumber, NSString, NSArray, NSDictionary, etc.)
 */
- (NSDictionary *)dictionaryRepresentation;

@end
