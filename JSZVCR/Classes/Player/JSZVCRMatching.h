//
//  JSZVCRMatching.h
//  Pods
//
//  Created by Jordan Zucker on 6/19/15.
//
//

#import <Foundation/Foundation.h>

@protocol JSZVCRMatching <NSObject>

- (BOOL)hasResponseForRequest:(NSURLRequest *)request inRecordings:(NSArray *)recordings;

- (NSDictionary *)responseForRequest:(NSURLRequest *)request inRecordings:(NSArray *)recordings;


@end
