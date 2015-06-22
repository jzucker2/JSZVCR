//
//  JSZVCRRecording.h
//  Pods
//
//  Created by Jordan Zucker on 6/8/15.
//
//

#import <Foundation/Foundation.h>
#import "JSZVCRSerializer.h"

@class JSZVCRResponse;
@class JSZVCRRequest;
@class JSZVCRData;

/**
 *  Represents all the parts of a complete network request 
 *  and response, including data
 */
@interface JSZVCRRecording : NSObject <JSZVCRSerializer>

@property (nonatomic, copy) NSNumber *taskIdentifier;
@property (nonatomic, copy) NSString *taskDescription;
/**
 *  Object representing everything involving NSURLResponses
 */
@property (nonatomic) JSZVCRResponse *response;

/**
 *  Object representing everything that happens to NSURLRequest 
 *  over the course of execution
 */
@property (nonatomic) JSZVCRRequest *request;

/**
 *  Object representing data returned by the request.
 */
@property (nonatomic) JSZVCRData *data;
/**
 *  Any errors that can possibly occur during the course of execution
 */
@property (nonatomic, copy) NSError *error;
/**
 *  Whether or nor this task has been cancelled
 */
@property (nonatomic, getter=isCancelled) BOOL cancelled;

/**
 *  Initializer using NSURLSessionTask
 *
 *  @param task network task
 *
 *  @return Recording representing everything that can and 
 *  will happen to this task over its lifetime
 */
- (instancetype)initWithTask:(NSURLSessionTask *)task;
/**
 *  Convenience initializer using NSURLSessionTask
 *
 *  @param task network task
 *
 *  @return Recording representing everything that can and 
 *  will happen to this task over its lifetime
 */
+ (instancetype)recordingWithTask:(NSURLSessionTask *)task;

@end
