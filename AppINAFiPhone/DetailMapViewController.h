//
//  DetailMapViewController.h
//  INAF1
//
//  Created by Nicolo' Parmiggiani on 16/02/14.
// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <UIKit/UIKit.h>

@interface DetailMapViewController : UIViewController


@property (strong, nonatomic) IBOutlet UILabel *name;

@property(nonatomic,strong) NSString* nameS;
@property(nonatomic,strong) NSString* addressS;
@property(nonatomic,strong) NSString* webpageS;
@property(nonatomic,strong) NSString* phoneS;
@property(nonatomic,strong) NSString* descrS;

@property (strong, nonatomic) IBOutlet UITextView *descr;
@property (strong, nonatomic) IBOutlet UILabel *address;
@property (strong, nonatomic) IBOutlet UILabel *website;
@property (strong, nonatomic) IBOutlet UILabel *phone;


@end
