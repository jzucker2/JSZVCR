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
+ (instancetype)vcrWithMatcherClass:(Class<JSZVCRMatching>)matcherClass;
- (instancetype)initWithMatcherClass:(Class<JSZVCRMatching>)matcherClass
                            recorder:(JSZVCRRecorder *)recorder;


- (void)swizzleNSURLSessionClasses;

- (void)removeAllNetworkResponses;

- (void)saveTestRecordings;

@end
