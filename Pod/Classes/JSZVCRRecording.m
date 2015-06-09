//
//  JSZVCRRecording.m
//  Pods
//
//  Created by Jordan Zucker on 6/8/15.
//
//

#import "JSZVCRRecording.h"
#import "JSZVCRRequest.h"
#import "JSZVCRResponse.h"
#import "JSZVCRData.h"

@implementation JSZVCRRecording

- (instancetype)initWithTask:(NSURLSessionTask *)task {
    self = [super init];
    if (self) {
//        _currentRequest = task.currentRequest;
//        _originalRequest = task.originalRequest;
        _taskIdentifier = @(task.taskIdentifier);
        _taskDescription = task.description;
        if (task.response) {
            _response = [JSZVCRResponse responseWithResponse:task.response];
        }
        _request = [JSZVCRRequest requestWithTask:task];
//        _response = task.response;
    }
    return self;
}

+ (instancetype)recordingWithTask:(NSURLSessionTask *)task {
    return [[self alloc] initWithTask:task];
}

//- (NSDictionary *)dictionaryRepresentation {
//    return @{
////             @"currentRequest" : self.currentRequest.description,
////             @"originalRequest" : self.originalRequest.description,
////             @"response" : self.response.description,
////             @"data" : [NSJSONSerialization JSONObjectWithData:self.data options:kNilOptions error:nil]
//             };
//}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dict = [@{
                                   @"request" : self.request.dictionaryRepresentation,
                                   @"response" : self.response.dictionaryRepresentation,
                                   @"data" : self.data.dictionaryRepresentation
                                   } mutableCopy];
    if (self.error) {
        dict[@"error"] = self.error.localizedDescription;
    }
    return [dict copy];
}

@end
