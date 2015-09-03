//
//  TraspViewController.h
//  AppINAFiPhone
//
//  Created by Nicolo' Parmiggiani on 03/09/15.
//  Copyright (c) 2015 Nicolo' Parmiggiani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TraspViewController : UIViewController <UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end
