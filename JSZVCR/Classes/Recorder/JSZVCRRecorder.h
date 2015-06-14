//
//  JSZVCRRecorder.h
//  Pods
//
//  Created by Jordan Zucker on 6/11/15.
//
//

#import <Foundation/Foundation.h>

@interface JSZVCRRecorder : NSObject

@property (nonatomic, getter=isEnabled) BOOL enabled;

+ (instancetype)sharedInstance;

- (void)reset;

- (void)recordTask:(NSURLSessionTask *)task redirectRequest:(NSURLRequest *)arg1 redirectResponse:(NSURLResponse *)arg2;
- (void)recordTask:(NSURLSessionTask *)task didReceiveData:(NSData *)data;
- (void)recordTask:(NSURLSessionTask *)task didReceiveResponse:(NSURLResponse *)response;
- (void)recordTask:(NSURLSessionTask *)task didFinishWithError:(NSError *)arg1;

- (NSArray *)allRecordings;

@end
