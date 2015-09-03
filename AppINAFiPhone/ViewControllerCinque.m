//
//  ViewControllerCinque.m
//  INAF1
//
//  Created by Nicolo' Parmiggiani on 12/02/14.
// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "ViewControllerCinque.h"
#import "ViewControllerApp.h"
#import "ViewControllerMappa.h"
#import "JobsViewController.h"
#import "TweetViewController.h"
#import "SpaceProjViewController.h"
#import "EarthProhListViewController.h"
#import "INAFTvViewController.h"
#import "TraspViewController.h"

@interface ViewControllerCinque ()
{
    NSArray * pulsanti;
}
@end

@implementation ViewControllerCinque

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    pulsanti = [NSArray arrayWithObjects:@"Apps",@"Sedi",@"Progetti da terra",@"Progetti Spaziali",@"Lavora con noi",@"Condividi tweet",@"Trasparenza",@"INAF Tv", nil];
    
    self.title = @"More";
    self.sfondoView.image=[UIImage imageNamed:@"Assets/LBTPort2.jpg"];
    
    [self.bottoneApp setImage:[UIImage imageNamed:@"Assets/bottoneApps.png"] forState:UIControlStateNormal];
    
    [self.bottoneMappa setImage:[UIImage imageNamed:@"Assets/bottoneSedi.png"] forState:UIControlStateNormal];
    [self.buttonE setImage:[UIImage imageNamed:@"Assets/bottonePT.png"] forState:UIControlStateNormal];
    [self.buttonS setImage:[UIImage imageNamed:@"Assets/bottonePS.png"] forState:UIControlStateNormal];
    
    [self.buttonT setImage:[UIImage imageNamed:@"Assets/bottoneTweet.png"] forState:UIControlStateNormal];
    [self.jobs setImage:[UIImage imageNamed:@"Assets/bottoneLN.png"] forState:UIControlStateNormal];

    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil)
    {
        cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    //cell.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
    
    cell.textLabel.text = [pulsanti objectAtIndex:indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = [UIColor whiteColor];
    
    
    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
        {
            ViewControllerApp * viewControllerApp = [[ViewControllerApp alloc] initWithNibName:@"ViewControllerApp" bundle:nil];
            
            [self.navigationController pushViewController:viewControllerApp animated:YES];
        }
            break;
        case 1:
        {
            ViewControllerMappa * viewControllerMappa = [[ViewControllerMappa alloc] initWithNibName:@"ViewControllerMappa" bundle:nil];
            
            [self.navigationController pushViewController:viewControllerMappa animated:YES];
        }
            break;
        case 2:
        {
            EarthProhListViewController * e = [[EarthProhListViewController alloc] initWithNibName:@"EarthProhListViewController" bundle:nil];
            
            [self.navigationController pushViewController:e animated:YES];

        }
            break;
        case 3:
        {
            SpaceProjViewController * s = [[SpaceProjViewController alloc] initWithNibName:@"SpaceProjViewController" bundle:nil];
            
            [self.navigationController pushViewController:s animated:YES];
        
        }
            break;
        case 4:
        {
            JobsViewController *jobsViewController = [[JobsViewController alloc] initWithNibName:@"JobsViewController" bundle:nil];
            
            [self.navigationController pushViewController:jobsViewController animated:YES];

        }
            break;
        case 5:
        {
            TweetViewController * tweet = [[TweetViewController alloc] initWithNibName:@"TweetViewController" bundle:nil];
            
            [self.navigationController pushViewController:tweet animated:YES];

            

        }
            break;
        case 6:
        {
            TraspViewController * trasparenza = [[TraspViewController alloc] initWithNibName:@"TraspViewController" bundle:nil];
            
            [self.navigationController pushViewController:trasparenza animated:YES];

        }
            break;
        case 7:
        {
            
            INAFTvViewController * tv = [[INAFTvViewController alloc]
                                     initWithNibName:@"INAFTvViewController" bundle:nil];
            
            [self.navigationController pushViewController:tv animated:YES];
            
        }
            break;

            
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)apriApp:(id)sender
{
    ViewControllerApp * viewControllerApp = [[ViewControllerApp alloc] initWithNibName:@"ViewControllerApp" bundle:nil];
    
    [self.navigationController pushViewController:viewControllerApp animated:YES];
}

- (IBAction)apriMappa:(id)sender
{
    ViewControllerMappa * viewControllerMappa = [[ViewControllerMappa alloc] initWithNibName:@"ViewControllerMappa" bundle:nil];
    
    [self.navigationController pushViewController:viewControllerMappa animated:YES];
    
}
- (IBAction)openEarth:(id)sender
{
    EarthProhListViewController * e = [[EarthProhListViewController alloc] initWithNibName:@"EarthProhListViewController" bundle:nil];
    
    [self.navigationController pushViewController:e animated:YES];
}

- (IBAction)openSpace:(id)sender
{
    SpaceProjViewController * s = [[SpaceProjViewController alloc] initWithNibName:@"SpaceProjViewController" bundle:nil];
    
    [self.navigationController pushViewController:s animated:YES];
}



- (IBAction)apriJobs:(id)sender
{
    JobsViewController *jobsViewController = [[JobsViewController alloc] initWithNibName:@"JobsViewController" bundle:nil];
    
    [self.navigationController pushViewController:jobsViewController animated:YES];
    
    
}
- (IBAction)openTweer:(id)sender
{
    TweetViewController * tweet = [[TweetViewController alloc] initWithNibName:@"TweetViewController" bundle:nil];
    
    [self.navigationController pushViewController:tweet animated:YES];

}
@end
