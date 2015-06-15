//
//  JSZVCRPlayer.h
//  Pods
//
//  Created by Jordan Zucker on 6/11/15.
//
//

#import <Foundation/Foundation.h>

@class XCTestCase;

@interface JSZVCRPlayer : NSObject


@property (nonatomic) XCTestCase *currentTestCase;
@property (nonatomic, readonly) NSArray *networkResponses;

- (BOOL)hasResponseForRequest:(NSURLRequest *)request;
- (NSDictionary *)responseForRequest:(NSURLRequest *)request;

- (void)removeAllNetworkResponses;

-

@end
