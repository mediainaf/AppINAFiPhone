//
//  SpaceProjViewController.m
//  AppINAFiPhone
//
//  Created by Nicolo' Parmiggiani on 29/08/14.
// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "SpaceProjViewController.h"
#import "AppTableCell.h"
#import "MapOrbitViewController.h"
#import "AllSatellite.h"
#import "InternetNewsViewController.h"

@interface SpaceProjViewController ()
{
    NSMutableDictionary *cachedImages;
    int load;
    NSMutableArray * satellites;

}
@end

@implementation SpaceProjViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        // Custom initialization
        
    }
    
    return self;
}

NSArray * titoli;

-(void) openMap
{
    
    MapOrbitViewController * map = [[MapOrbitViewController alloc] initWithNibName:@"MapOrbitViewController" bundle:nil];
    
    [self.navigationController pushViewController:map animated:YES];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    if(load == 0)
    {
        load=1;
        
        NSString * url = [NSString stringWithFormat: @"http://app.media.inaf.it/GetSatellites.php"];
        
        NSString *response1 = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil];
        if(!response1)
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Internet Connection Error" message:@"Change internet settings" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        
        NSData * response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        
        NSLog(@"%@",url);
        
        NSArray *jsonArray ;
        if (response) {
            
            NSError *e = nil;
            jsonArray = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error: &e];
            
        }
        
        [satellites removeAllObjects];
        
        for(NSDictionary * d in jsonArray)
        {
            
            if([[d valueForKeyPath:@"showonapp"] isEqualToString:@"0"] )
            {
                
            }
            else
            {
                NSString *name = [d valueForKey:@"name"];
                NSString *tag = [d valueForKey:@"tag"];
                NSString *phase = [d valueForKey:@"phase"];
                NSString *scope = [d valueForKey:@"scope"];
                NSString *img = [d valueForKey:@"imgbase"];
                
                AllSatellite * t = [[AllSatellite alloc]init];
                
                
                NSLog(@"%@ %@",name,tag);
                t.name=name;
                t.scope=scope;
                t.img=img;
                t.phase=phase;
                t.tag=tag;
                
                [satellites addObject:t];
            }
        }
        
        [self.tableView reloadData];
        
    }
}

- (void)viewDidLoad
{
    
    
    load = 0;
    
    cachedImages = [[NSMutableDictionary alloc] init];
    
    satellites = [[NSMutableArray alloc] init];

    self.sfondoView.image = [UIImage imageNamed:@"Assets/nebulaViola1.jpg"];
    
    UIImage * bottoneSatellite = [UIImage imageNamed:@"Assets/iconOrbit.png"];
    
    
    UIButton * bottone = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [bottone addTarget:self action:@selector(openMap) forControlEvents:UIControlEventTouchUpInside];
    
    UIDevice * device = [UIDevice currentDevice];
    
    if([device.systemVersion hasPrefix:@"6"])
    {
        [bottone setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [bottone setTintColor:[UIColor blackColor]];
    }
    
    [bottone setTitle:@"Satellites Orbits" forState:UIControlStateNormal];
    
    [bottone setImage:bottoneSatellite forState:UIControlStateNormal];
    
    [bottone setFrame:CGRectMake(310, 2, 130, 30)];
    
    UIBarButtonItem * buttonBar = [[UIBarButtonItem alloc] initWithCustomView:bottone];
    
    self.navigationItem.rightBarButtonItem=buttonBar;
    
    
    self.tableView.rowHeight=80;
    
   // self.title = @"Progetti Spaziali";
    
    
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([satellites count] >0)
        return [satellites count];
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    AppTableCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil)
    {
        cell= [[AppTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    //cell.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
    
    if([satellites count] >0)
    {
        
        
        AllSatellite * s = [satellites objectAtIndex:indexPath.row];
        
        cell.textLable.text = s.name;
        
        NSString *identifier = [NSString stringWithFormat:@"Cell%d" ,
                                indexPath.row];
        
        
        if([cachedImages objectForKey:identifier] != nil)
        {
            cell.immaginePreview.image = [cachedImages valueForKey:identifier];
            //[cell.indicator stopAnimating];
            NSLog(@"metti immagine");
            
        }
        else
        {
            cell.immaginePreview.image = nil;
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,  0ul);
            dispatch_async(queue, ^{
                //This is what you will load lazily
                
                NSData   *data = [NSData dataWithContentsOfURL:[NSURL URLWithString: [NSString stringWithFormat:@"http://www.media.inaf.it/wp-content/themes/mediainaf/images/tags/%@.jpg",s.img]]];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                    UIImage * image = [UIImage imageWithData:data];
                    
                    if(image != nil)
                    {
                        [cachedImages setObject:image forKey:identifier];
                        //cell.thumbnail.image = image;
                        [cell setNeedsLayout];
                        
                        [self.tableView beginUpdates];
                        
                        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        [self.tableView endUpdates];
                        
                        
                        
                    }
                    else
                    {
                        UIImage * image = [UIImage imageNamed:@"Assets/satelliteIcon.jpeg"];
                        [cachedImages setObject:image forKey:identifier];
                        
                        [cell setNeedsLayout];
                        [self.tableView beginUpdates];
                        
                        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        [self.tableView endUpdates];
                        
                        
                        
                        
                        
                        
                    }
                });
            });
            
        }
    }
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([satellites count]>0)
    {
        InternetNewsViewController * internet = [[InternetNewsViewController alloc] initWithNibName:@"InternetNewsViewController" bundle:nil];
        
        AllSatellite * s =[satellites objectAtIndex:indexPath.row];
        
        internet.link = [NSString stringWithFormat:@"http://www.media.inaf.it/tag/%@/",s.tag];
        
        [self.navigationController pushViewController:internet animated:YES];
        
    
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
