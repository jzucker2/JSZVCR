//
//  JSZVCR.h
//  Pods
//
//  Created by Jordan Zucker on 6/8/15.
//
//

#import <Foundation/Foundation.h>
#import "JSZVCRTestCase.h"

@class JSZVCRPlayer;
@class JSZVCRRecorder;
@interface JSZVCR : NSObject

@property (nonatomic, getter=isRecording) BOOL recording;
@property (nonatomic) XCTestCase *currentTestCase;

//+ (instancetype)sharedInstance;
+ (instancetype)vcr;
- (instancetype)initWithPlayer:(JSZVCRPlayer *)player
                      recorder:(JSZVCRRecorder *)recorder;


- (void)swizzleNSURLSessionClasses;

- (void)removeAllNetworkResponses;

- (void)dumpRecordingsToFile:(NSString *)filePath;

@end
