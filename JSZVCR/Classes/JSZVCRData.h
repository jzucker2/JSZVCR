//
//  JSZVCRData.h
//  Pods
//
//  Created by Jordan Zucker on 6/9/15.
//
//

#import <Foundation/Foundation.h>
#import "JSZVCRSerializer.h"

@interface JSZVCRData : NSObject <JSZVCRSerializer>

- (instancetype)initWithData:(NSData *)data;
+ (instancetype)dataWithData:(NSData *)data;

@property (nonatomic, copy) NSData *data;

@end
