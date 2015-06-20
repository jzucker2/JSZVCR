//
//  JSZVCRMatching.h
//  Pods
//
//  Created by Jordan Zucker on 6/19/15.
//
//

#import <Foundation/Foundation.h>

@protocol JSZVCRMatching <NSObject>

+ (id<JSZVCRMatching>)matcher;

- (BOOL)hasResponseForRequest:(NSURLRequest *)request inRecordings:(NSArray *)recordings;

- (NSDictionary *)responseForRequest:(NSURLRequest *)request inRecordings:(NSArray *)recordings;

@optional

- (NSDictionary *)infoForRequest:(NSURLRequest *)request inRecordings:(NSArray *)recordings;


@end
