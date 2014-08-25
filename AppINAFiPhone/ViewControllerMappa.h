//
//  ViewControllerMappa.h
//  INAF1
//
//  Created by Nicolo' Parmiggiani on 14/02/14.
// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface ViewControllerMappa : UIViewController <MKMapViewDelegate,UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end
