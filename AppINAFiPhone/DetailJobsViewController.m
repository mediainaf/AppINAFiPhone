//
//  DetailJobsViewController.m
//  INAF1
//
//  Created by Nicolo' Parmiggiani on 15/02/14.
// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "InternetNewsViewController.h"
#import "DetailJobsViewController.h"

@interface DetailJobsViewController ()

@end

@implementation DetailJobsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void) OpenLink
{
    InternetNewsViewController * internetViewController = [[InternetNewsViewController alloc] initWithNibName:@"InternetNewsViewController" bundle:nil];
    
    internetViewController.link =@"http://www.inaf.it/it/lavora-con-noi/borse-di-studio/borsa-di-studio-dal-titolo-progettazione-realizzazione-e-caratterizzazione-di-circuiti-elettronici-analogico-digitali";
    
    [self.navigationController pushViewController:internetViewController animated:YES];
}
- (void)viewDidLoad
{
    //self.title=@"Jobs";
    self.navigationController.navigationBar.tintColor=[UIColor blackColor];

    self.sfondoView.image=[UIImage imageNamed:@"Assets/lbt4.jpg"];
    UIBarButtonItem * apriImmagine = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(OpenLink)];
    
    [self.navigationItem setRightBarButtonItem:apriImmagine animated:YES];

    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
