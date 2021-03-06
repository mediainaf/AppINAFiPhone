//
//  AppTableCell.m
//  INAF1
//
//  Created by Nicolo' Parmiggiani on 28/02/14.
// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "AppTableCell.h"

@implementation AppTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        NSArray * nibArray = [[NSBundle mainBundle] loadNibNamed:@"AppTableCell" owner:self options:nil];
        
        self = [nibArray objectAtIndex:0];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
