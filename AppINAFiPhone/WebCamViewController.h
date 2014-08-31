//
//  WebCamViewController.h
//  AppINAFiPhone
//
//  Created by Nicolo' Parmiggiani on 30/08/14.
//  Copyright (c) 2014 Nicolo' Parmiggiani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebCamViewController : UIViewController <NSXMLParserDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end
