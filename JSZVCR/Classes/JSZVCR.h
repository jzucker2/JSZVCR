//
//  JSZVCR.h
//  Pods
//
//  Created by Jordan Zucker on 6/8/15.
//
//

#import <Foundation/Foundation.h>
//#import "JSZVCRRecorder.h"
//#import "JSZVCRResourceLoader.h"
#import "JSZVCRTestCase.h"

@class JSZVCRResourceLoader;
@class JSZVCRPlayer;
@class JSZVCRRecorder;
@interface JSZVCR : NSObject

@property (nonatomic, getter=isEnabled) BOOL enabled;
@property (nonatomic, readonly) XCTestCase *currentTestCase;

+ (instancetype)sharedInstance;
+ (instancetype)vcrWithResourceLoader:(JSZVCRResourceLoader *)resourceLoader;
- (instancetype)initWithResourceLoader:(JSZVCRResourceLoader *)resourceLoader
                        player:(JSZVCRPlayer *)player
                      recorder:(JSZVCRRecorder *)recorder;


- (void)swizzleNSURLSessionClasses;

//- (void)recordTask:(NSURLSessionTask *)task redirectRequest:(NSURLRequest *)arg1 redirectResponse:(NSURLResponse *)arg2;
//- (void)recordTask:(NSURLSessionTask *)task didReceiveData:(NSData *)data;
//- (void)recordTask:(NSURLSessionTask *)task didReceiveResponse:(NSURLResponse *)response;
//- (void)recordTask:(NSURLSessionTask *)task didFinishWithError:(NSError *)arg1;
//
//- (NSArray *)allRecordings;
- (void)dumpRecordingsToFile:(NSString *)filePath;

@end
