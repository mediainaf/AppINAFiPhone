//
//  ViewControllerCinque.m
//  INAF1
//
//  Created by Nicolo' Parmiggiani on 12/02/14.
// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "ViewControllerCinque.h"
#import "ViewControllerApp.h"
#import "ViewControllerMappa.h"
#import "JobsViewController.h"
#import "TweetViewController.h"
#import "SpaceProjViewController.h"

@interface ViewControllerCinque ()

@end

@implementation ViewControllerCinque

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.title = @"More";
    self.sfondoView.image=[UIImage imageNamed:@"Assets/LBTPort.jpg"];
    
    [self.bottoneApp setImage:[UIImage imageNamed:@"Assets/bottoneApps.png"] forState:UIControlStateNormal];
    
    [self.bottoneMappa setImage:[UIImage imageNamed:@"Assets/bottoneSedi.png"] forState:UIControlStateNormal];
    [self.buttonE setImage:[UIImage imageNamed:@"Assets/bottonePT.png"] forState:UIControlStateNormal];
    [self.buttonS setImage:[UIImage imageNamed:@"Assets/bottonePS.png"] forState:UIControlStateNormal];
    
    [self.buttonT setImage:[UIImage imageNamed:@"Assets/bottoneTweet.png"] forState:UIControlStateNormal];
    [self.jobs setImage:[UIImage imageNamed:@"Assets/bottoneLN.png"] forState:UIControlStateNormal];

    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)apriApp:(id)sender
{
    ViewControllerApp * viewControllerApp = [[ViewControllerApp alloc] initWithNibName:@"ViewControllerApp" bundle:nil];
    
    [self.navigationController pushViewController:viewControllerApp animated:YES];
}

- (IBAction)apriMappa:(id)sender
{
    ViewControllerMappa * viewControllerMappa = [[ViewControllerMappa alloc] initWithNibName:@"ViewControllerMappa" bundle:nil];
    
    [self.navigationController pushViewController:viewControllerMappa animated:YES];
    
}
- (IBAction)openEarth:(id)sender {
}

- (IBAction)openSpace:(id)sender
{
    SpaceProjViewController * s = [[SpaceProjViewController alloc] initWithNibName:@"SpaceProjViewController" bundle:nil];
    
    [self.navigationController pushViewController:s animated:YES];
}

- (IBAction)openWorks:(id)sender {
}

- (IBAction)apriJobs:(id)sender
{
    JobsViewController *jobsViewController = [[JobsViewController alloc] initWithNibName:@"JobsViewController" bundle:nil];
    
    [self.navigationController pushViewController:jobsViewController animated:YES];
    
    
}
- (IBAction)openTweer:(id)sender
{
    TweetViewController * tweet = [[TweetViewController alloc] initWithNibName:@"TweetViewController" bundle:nil];
    
    [self.navigationController pushViewController:tweet animated:YES];

}
@end
