//
//  JSZVCRDeserializer.h
//  Pods
//
//  Created by Jordan Zucker on 1/12/16.
//
//

#ifndef JSZVCRDeserializer_h
#define JSZVCRDeserializer_h

#import <Foundation/Foundation.h>

static NSString * const kJSZVCROriginalRequestKey = @"originalRequest";
static NSString * const kJSZVCRCurrentRequestKey = @"originalRequest";

/**
 *  This is implemented by all objects that are serialized as part of a network request recording
 */
@protocol JSZVCRDeserializer <NSObject>

/**
 *  This is called to deserialize a foundation object representing
 *  into a component that is useable within JSZVCR. Similar to NSJONSerialization
 *
 *  @return an instance composed entirely of JSZVCR objects (JSZVCRecording, 
 *  JSZVCRResponse, JSZVCRRequest, etc.). 
 *  @note This will create objects from the top down. You can feed it keys with values
 *  corresponding to foundations objects only containing the keys in this file, or consisting
 *  of objects composed of JSZVCRRecording classes.
 */
- (instancetype)initWithDictionary:(NSDictionary *)info;

@end

#endif /* JSZVCRDeserializer_h */
