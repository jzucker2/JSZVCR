//
//  JSZVCRRecording.m
//  Pods
//
//  Created by Jordan Zucker on 6/8/15.
//
//

#import "JSZVCRRecording.h"

@implementation JSZVCRRecording

- (instancetype)initWithTask:(NSURLSessionTask *)task {
    self = [super init];
    if (self) {
        _currentRequest = task.currentRequest;
        _originalRequest = task.originalRequest;
        _taskIdentifier = @(task.taskIdentifier);
        _taskDescription = task.description;
        _response = task.response;
    }
    return self;
}

+ (instancetype)recordingWithTask:(NSURLSessionTask *)task {
    return [[self alloc] initWithTask:task];
}

- (NSDictionary *)dictionaryRepresentation {
    return @{
             @"currentRequest" : self.currentRequest.description,
             @"originalRequest" : self.originalRequest.description,
             @"response" : self.response.description,
             @"data" : [NSJSONSerialization JSONObjectWithData:self.data options:kNilOptions error:nil]
             };
}

@end
