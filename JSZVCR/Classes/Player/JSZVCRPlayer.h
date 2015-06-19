//
//  JSZVCRPlayer.h
//  Pods
//
//  Created by Jordan Zucker on 6/11/15.
//
//

#import <Foundation/Foundation.h>
#import "JSZVCRMatching.h"

@class XCTestCase;

@interface JSZVCRPlayer : NSObject


@property (nonatomic, getter=isEnabled) BOOL enabled;
@property (nonatomic) XCTestCase *currentTestCase;
@property (nonatomic, readonly) NSArray *networkResponses;
@property (nonatomic) id<JSZVCRMatching> matcher; // might not be safe to change this during a test run if there's lots of async network calls


- (instancetype)initWithMatcher:(id<JSZVCRMatching>)matcher;
+ (instancetype)playerWithMatcher:(id<JSZVCRMatching>)matcher;

- (void)removeAllNetworkResponses;

@end
