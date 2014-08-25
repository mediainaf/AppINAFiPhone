//
//  ViewControllerCredits.h
//  INAF1
//
//  Created by Nicolo' Parmiggiani on 16/02/14.
// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <UIKit/UIKit.h>

@interface ViewControllerCredits : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *logo1;
@property (strong, nonatomic) IBOutlet UIImageView *logo2;
@property (strong, nonatomic) IBOutlet UITextView *textView;
- (IBAction)chiudi:(id)sender;

@end
