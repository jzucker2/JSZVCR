//
//  JSZVCRTestCase.h
//  Pods
//
//  Created by Jordan Zucker on 6/11/15.
//
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>
#import "JSZVCRMatching.h"
#import "JSZVCRPlayer.h"

/**
 *  Subclass of XCTestCase for making easy recorded network responses 
 *  and replaying them for further test runs.
 */
@interface JSZVCRTestCase : XCTestCase

/**
 *  Method should be overriden in subclass so that network 
 *  requests will be recorded during development. Should be 
 *  set to YES during development for recoring network 
 *  responses and NO during CI test runs so that recorded 
 *  data will be used. Default is YES favoring development.
 *
 *  @return YES means requests are recording to file in Documents 
 *  directory of device at path corresponding to current test case. 
 *  NO means files are read from file matching test case in suite 
 *  matching bundle in current XCode project.
 */
- (BOOL)isRecording;

/**
 *  Class conforming to @protocol JSZMatching will be used 
 *  to control matching requests with recorded network responses. 
 *  This is only called when isRecording is set to NO. If not 
 *  overridden, then JSZVCRSimpleURLMatcher is returned by default.
 *
 *  @return Class conforming to @protocol JSZMatching for use 
 *  in matching test case requests with responses
 */
- (Class<JSZVCRMatching>)matcherClass;

/**
 *  Override in subclass so that tests can be failed if network
 *  requests are made during a playback test run that don't 
 *  match any recorded network requests
 *
 *  @return enum level determines strictness for passing tests,
 *  default is JSZVCRTestingStrictnessNone. The enum value
 *  JSZVCRTestingStrictnessFailWhenNoMatch will cause a test to fail
 *  if a network request occurs that does not match a recorded request.
 */
- (JSZVCRTestingStrictness)matchingFailStrictness;

/**
 *  Available default network responses for this test case.
 */
@property (nonatomic, readonly) NSArray *recordings;


//+ (NSString *)bundleNameContainingResponses;


@end
