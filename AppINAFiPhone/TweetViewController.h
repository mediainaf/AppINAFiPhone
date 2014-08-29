//
//  TweetViewController.h
//  AppINAFiPhone
//
//  Created by Nicolo' Parmiggiani on 29/08/14.
// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <UIKit/UIKit.h>

@interface TweetViewController : UIViewController <UIWebViewDelegate,UIImagePickerControllerDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end
