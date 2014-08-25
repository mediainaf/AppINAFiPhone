//
//  InternetNewsViewController.h
//  INAF1
//
//  Created by Nicolo' Parmiggiani on 14/02/14.
// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <UIKit/UIKit.h>

@interface InternetNewsViewController : UIViewController <UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@property(strong,nonatomic) NSString * link;

@end
