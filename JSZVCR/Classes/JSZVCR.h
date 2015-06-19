//
//  JSZVCR.h
//  Pods
//
//  Created by Jordan Zucker on 6/8/15.
//
//

#import <Foundation/Foundation.h>
#import "JSZVCRTestCase.h"
#import "JSZVCRMatching.h"

@class JSZVCRRecorder;
@interface JSZVCR : NSObject

@property (nonatomic, getter=isRecording) BOOL recording;
@property (nonatomic) XCTestCase *currentTestCase;

//+ (instancetype)sharedInstance;
+ (instancetype)vcrWithMatcher:(id<JSZVCRMatching>)matcher;
- (instancetype)initWithMatcher:(id<JSZVCRMatching>)matcher
                       recorder:(JSZVCRRecorder *)recorder;


- (void)swizzleNSURLSessionClasses;

- (void)removeAllNetworkResponses;

- (void)saveTestRecordings;

@end
