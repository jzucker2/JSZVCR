//
//  JSZViewController.m
//  JSZVCR
//
//  Created by Jordan Zucker on 06/08/2015.
//  Copyright (c) 2014 Jordan Zucker. All rights reserved.
//

#import <JSZVCR/JSZVCR.h>
#import <JSZVCR/JSZVCRRecording.h>

#import "JSZViewController.h"

@interface JSZViewController ()
@property (nonatomic) NSURLSession *session;
@end

@implementation JSZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://pubsub.pubnub.com/publish/demo/demo/0/hello_world/0/%22Hello%20World%22"]];
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"data: %@", data);
        NSLog(@"response: %@", response);
        NSLog(@"error: %@", error);
    }];
    [task resume];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *allRecordings = [JSZVCR sharedInstance].allRecordings;
        NSLog(@"allRecordings: %@", allRecordings);
        for (JSZVCRRecording *recording in allRecordings) {
            NSLog(@"recording: %@", recording);
        }
        [[JSZVCR sharedInstance] dumpRecordingsToFile:@"test"];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    NSArray *allRecordings = [JSZVCR sharedInstance].allRecordings;
//    NSLog(@"allRecordings: %@", allRecordings);
//    for (JSZVCRRecording *recording in allRecordings) {
//        NSLog(@"recording: %@", recording);
//    }
}

@end
