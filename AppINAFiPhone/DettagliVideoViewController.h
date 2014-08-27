//
//  DettagliVideoViewController.h
//  INAF1
//
//  Created by Nicolo' Parmiggiani on 25/04/14.
// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <UIKit/UIKit.h>
#import "Video.h"

@interface DettagliVideoViewController : UIViewController <UIWebViewDelegate>

@property (strong,nonatomic) Video * video;
@property (strong, nonatomic) IBOutlet UILabel *titolo;

@property (strong, nonatomic) IBOutlet UITextView *description;
@property (strong, nonatomic) IBOutlet UILabel *numberOfView;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong,nonatomic) UIImage * thumbnail;
@property (strong, nonatomic) IBOutlet UIImageView *sfondoView;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end
