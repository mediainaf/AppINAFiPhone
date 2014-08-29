//
//  MapOrbitViewController.h
//  AppINAFiPhone
//
//  Created by Nicolo' Parmiggiani on 29/08/14.
// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapOrbitViewController : UIViewController <MKMapViewDelegate,MKAnnotation,UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property(nonatomic,strong) NSTimer * timer;

@end
