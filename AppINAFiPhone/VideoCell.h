//
//  VideoCell.h
//  INAF1
//
//  Created by Nicolo' Parmiggiani on 25/04/14.
// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <UIKit/UIKit.h>

@interface VideoCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *titolo;
@property (strong, nonatomic) IBOutlet UIImageView *immagine;
@property (strong, nonatomic) IBOutlet UITextView *testo;
@property (strong, nonatomic) IBOutlet UILabel *visualizzazioni;
@property (strong, nonatomic) IBOutlet UILabel *data;
@property (strong, nonatomic) IBOutlet UIImageView *play;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end
