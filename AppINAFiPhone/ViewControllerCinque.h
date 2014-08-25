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
- (IBAction)apriJobs:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *bottoneMappa;
@end
