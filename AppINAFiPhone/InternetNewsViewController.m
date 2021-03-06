//
//  InternetNewsViewController.m
//  INAF1
//
//  Created by Nicolo' Parmiggiani on 14/02/14.
// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "InternetNewsViewController.h"

@interface InternetNewsViewController ()

@end

@implementation InternetNewsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.indicator stopAnimating];
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
    
    NSLog(@"%d", error.code);
    
    if(error.code!=-999)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Internet connection failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        
        [alert show];
        
        [self.indicator stopAnimating];
    }
}
- (void)viewDidLoad
{
    
    [self.indicator startAnimating];
    
    
    NSLog(@"%@",self.link);
    NSURL * urlNews = [NSURL URLWithString:self.link];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlNews
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
   // [request setValue:@"Mozilla/5.0 AppleWebKit/537.11  Chrome/23.0.1271.6 Safari/537.11" forHTTPHeaderField:@"User-Agent"];
    [self.webView loadRequest:request];
    
    self.webView.scalesPageToFit=YES;

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
