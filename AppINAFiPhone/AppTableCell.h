//
//  AppTableCell.h
//  INAF1
//
//  Created by Nicolo' Parmiggiani on 28/02/14.
// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <UIKit/UIKit.h>

@interface AppTableCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *textLable;
@property (strong, nonatomic) IBOutlet UIImageView *immaginePreview;

@end
