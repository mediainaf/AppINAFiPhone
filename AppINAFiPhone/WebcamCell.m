//
//  WebcamCell.m
//  AppINAFiPhone
//
//  Created by Nicolo' Parmiggiani on 31/08/14.
//  Copyright (c) 2014 Nicolo' Parmiggiani. All rights reserved.
//

#import "WebcamCell.h"

@implementation WebcamCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray * nibArray = [[NSBundle mainBundle] loadNibNamed:@"WebcamCell" owner:self options:nil];
        
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
