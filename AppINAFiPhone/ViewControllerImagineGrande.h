//
//  ViewControllerImagineGrande.h
//  INAF1
//
//  Created by Nicolo' Parmiggiani on 25/04/14.
// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <UIKit/UIKit.h>

@interface ViewControllerImagineGrande : UIViewController <NSURLConnectionDataDelegate,NSURLConnectionDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) NSString * imageUrl;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollerView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;


@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end
