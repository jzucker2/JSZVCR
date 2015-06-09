//
//  JSZVCRRecording.h
//  Pods
//
//  Created by Jordan Zucker on 6/8/15.
//
//

#import <Foundation/Foundation.h>

@interface JSZVCRRecording : NSObject

@property (nonatomic, copy) NSNumber *taskIdentifier;
@property (nonatomic, copy) NSString *taskDescription;
@property (nonatomic, copy) NSURLResponse *response;
@property (nonatomic, copy) NSURLRequest *originalRequest;
@property (nonatomic, copy) NSURLRequest *currentRequest;
@property (nonatomic, copy) NSData *data;
@property (nonatomic, copy) NSError *error;

- (instancetype)initWithTask:(NSURLSessionTask *)task;
+ (instancetype)recordingWithTask:(NSURLSessionTask *)task;
- (NSDictionary *)dictionaryRepresentation;

@end
