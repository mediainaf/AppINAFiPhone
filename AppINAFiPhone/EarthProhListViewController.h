//
//  EarthProhListViewController.h
//  AppINAFiPhone
//
//  Created by Nicolo' Parmiggiani on 30/08/14.
//  Copyright (c) 2014 Nicolo' Parmiggiani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EarthProhListViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *sfondoView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
