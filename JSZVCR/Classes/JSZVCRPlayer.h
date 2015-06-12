//
//  JSZVCRPlayer.h
//  Pods
//
//  Created by Jordan Zucker on 6/11/15.
//
//

#import <Foundation/Foundation.h>

@class JSZVCRResourceLoader;

@interface JSZVCRPlayer : NSObject

- (instancetype)initWithResourceLoader:(JSZVCRResourceLoader *)resourceLoader;

@property (nonatomic, readonly) JSZVCRResourceLoader *resourceLoader;
@property (nonatomic, readonly) NSBundle *bundle;
@property (nonatomic, readonly) NSArray *networkResponses;

@end
