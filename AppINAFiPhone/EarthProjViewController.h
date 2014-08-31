//
//  EarthProjViewController.h
//  AppINAFiPhone
//
//  Created by Nicolo' Parmiggiani on 30/08/14.
//  Copyright (c) 2014 Nicolo' Parmiggiani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface EarthProjViewController : UIViewController <UIActionSheetDelegate,MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end
