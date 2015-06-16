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

@interface JSZVCRRecording : NSObject <JSZVCRSerializer>

@property (nonatomic, copy) NSNumber *taskIdentifier;
@property (nonatomic, copy) NSString *taskDescription;
@property (nonatomic) JSZVCRResponse *response;
@property (nonatomic) JSZVCRRequest *request;
@property (nonatomic) JSZVCRData *data;
@property (nonatomic, copy) NSError *error;
@property (nonatomic, getter=isCancelled) BOOL cancelled;

- (instancetype)initWithTask:(NSURLSessionTask *)task;
+ (instancetype)recordingWithTask:(NSURLSessionTask *)task;

@end
