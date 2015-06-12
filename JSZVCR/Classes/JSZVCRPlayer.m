//
//  JSZVCRPlayer.m
//  Pods
//
//  Created by Jordan Zucker on 6/11/15.
//
//

#import "JSZVCRPlayer.h"

@interface JSZVCRPlayer ()
@property (nonatomic, readwrite) JSZVCRResourceLoader *resourceLoader;
@end

@implementation JSZVCRPlayer

- (instancetype)initWithResourceLoader:(JSZVCRResourceLoader *)resourceLoader {
    self = [super init];
    if (self) {
        _resourceLoader = resourceLoader;
    }
    return self;
}

- (NSBundle *)bundle {
//    return self.resourceLoader.bundle;
}

@end
