//
//  DetailMapViewController.m
//  INAF1
//
//  Created by Nicolo' Parmiggiani on 16/02/14.
// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "DetailMapViewController.h"

@interface DetailMapViewController ()

@end

@implementation DetailMapViewController

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
    
    self.name.text = self.nameS;
        self.phone.text = [@"Phone: " stringByAppendingString:self.phoneS];
    self.address.text = self.addressS;
    self.website.text = self.webpageS;
    
    NSLog(@"%@",self.descrS);
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
