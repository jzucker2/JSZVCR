//
//  JSZVCRMatcher.h
//  Pods
//
//  Created by Jordan Zucker on 6/19/15.
//
//

// Suggested subclass

#import <Foundation/Foundation.h>
#import "JSZVCRMatching.h"

@interface JSZVCRMatcher : NSObject <JSZVCRMatching>

+ (instancetype)matcher;

@end
