//
//  DetailNewsViewController.h
//  INAF1
//
//  Created by Nicolo' Parmiggiani on 14/02/14.
// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <UIKit/UIKit.h>

#import "News.h"


@interface DetailNewsViewController : UIViewController <UIActionSheetDelegate,UIWebViewDelegate>

@property (strong, nonatomic) News * news;
@property (strong, nonatomic) IBOutlet UIImageView *immagine;
@property (strong, nonatomic) IBOutlet UITextView *testo;
@property (strong, nonatomic) IBOutlet UILabel *autore;
@property (strong, nonatomic) IBOutlet UILabel *data;
@property (strong, nonatomic)  NSString * anteprima;
@property (strong, nonatomic) IBOutlet UIImageView *sfindoView;
@property (strong, nonatomic) IBOutlet UILabel *titolo;
@property (strong, nonatomic) IBOutlet UILabel *sommario;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end
