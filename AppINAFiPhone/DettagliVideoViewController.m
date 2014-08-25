//
//  DettagliVideoViewController.m
//  INAF1
//
//  Created by Nicolo' Parmiggiani on 25/04/14.
// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "DettagliVideoViewController.h"


@interface DettagliVideoViewController ()

@end

@implementation DettagliVideoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    
    NSMutableString *html = [NSMutableString string];
    [html appendString:@"<html>"];
    [html appendString:@"<head>"];
    [html appendString:@"<style type=\"text/css\">"];
    [html appendString:@"body {"];
    [html appendString:@"background-color: transparent;"];
    [html appendString:@"color: white;"];
    [html appendString:@"margin: 0;"];
    [html appendString:@"}"];
    [html appendString:@"</style>"];
    [html appendString:@"</head>"];
    [html appendString:@"<body>"];
    [html appendFormat:@"<iframe id=\"ytplayer\" type=\"text/html\" width=\"%0.0f\" height=\"%0.0f\" src=\"http://www.youtube.com/embed/%@\" frameborder=\"0\"/>", self.webView.frame.size.width, self.webView.frame.size.height, self.video.videoToken];
    [html appendString:@"</body>"];
    [html appendString:@"</html>"];
    
    [self.indicator stopAnimating];
    
    [self.webView loadHTMLString:html baseURL:nil];

    
}
- (void)viewDidLoad
{
    
    [self.indicator startAnimating];
    
    self.sfondoView.image=[UIImage imageNamed:@"Assets/lbt5.jpg"];
    self.sfondoView.alpha = 0.6;
    
    Video * v = [[Video alloc]init];
    v=self.video;
    
       self.titolo.text= v.title;
    self.description.text = v.summary;
    [self.description setFont:[UIFont fontWithName:@"Helvetica" size:16.0f]];
    self.date.text = v.data;
    self.numberOfView.text = [NSString stringWithFormat:@"%@ visualizzazioni", v.numberOfView];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
