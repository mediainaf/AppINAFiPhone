//
//  NewsCell.m
//  INAF1
//
//  Created by Nicolo' Parmiggiani on 04/06/14.
// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
#import "NewsCell.h"

@implementation NewsCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        NSArray * nibArray = [[NSBundle mainBundle] loadNibNamed:@"NewsCell" owner:self options:nil];
        
        self = [nibArray objectAtIndex:0];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
