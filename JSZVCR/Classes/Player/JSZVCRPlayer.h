//
//  JSZVCRPlayer.h
//  Pods
//
//  Created by Jordan Zucker on 6/11/15.
//
//

#import <Foundation/Foundation.h>

@class JSZVCRResourceManager;

@interface JSZVCRPlayer : NSObject

- (instancetype)initWithResourceManager:(JSZVCRResourceManager *)resourceManager;

@property (nonatomic, readonly) JSZVCRResourceManager *resourceManager;
@property (nonatomic, readonly) NSArray *networkResponses;

- (BOOL)hasResponseForRequest:(NSURLRequest *)request;
- (NSDictionary *)responseForRequest:(NSURLRequest *)request;

@end
