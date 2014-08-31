//
//  WebcamCell.h
//  AppINAFiPhone
//
//  Created by Nicolo' Parmiggiani on 31/08/14.
//  Copyright (c) 2014 Nicolo' Parmiggiani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebcamCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UIImageView *webcam;

@end
