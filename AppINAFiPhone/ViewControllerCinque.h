//
//  ViewControllerCinque.h
//  INAF1
//
//  Created by Nicolo' Parmiggiani on 12/02/14.
// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <UIKit/UIKit.h>

@interface ViewControllerCinque : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *sfondoView;


@property (strong, nonatomic) IBOutlet UIButton *bottoneApp;

- (IBAction)apriApp:(id)sender;
- (IBAction)apriMappa:(id)sender;


@property (strong, nonatomic) IBOutlet UIButton *jobs;

@property (strong, nonatomic) IBOutlet UIButton *buttonE;
- (IBAction)openEarth:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *buttonS;
- (IBAction)openSpace:(id)sender;



- (IBAction)apriJobs:(id)sender;


@property (strong, nonatomic) IBOutlet UIButton *buttonT;
- (IBAction)openTweer:(id)sender;


@property (strong, nonatomic) IBOutlet UIButton *bottoneMappa;
@end
