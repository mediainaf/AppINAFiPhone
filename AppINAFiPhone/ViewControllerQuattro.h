//
//  ViewControllerQuattro.h
//  INAF1
//
//  Created by Nicolo' Parmiggiani on 12/02/14.
// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <UIKit/UIKit.h>



@interface ViewControllerQuattro : UIViewController <UICollectionViewDelegate,UICollectionViewDataSource,NSXMLParserDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *sfondoView;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;




@end
