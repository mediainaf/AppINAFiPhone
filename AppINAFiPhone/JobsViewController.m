//
//  JobsViewController.m
//  INAF1
//
//  Created by Nicolo' Parmiggiani on 15/02/14.
// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "JobsViewController.h"
#import "DetailJobsViewController.h"
#import "JobsCell.h"

@interface JobsViewController ()
{
    NSArray * bandi;
}

@end

@implementation JobsViewController

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

     bandi = [NSArray arrayWithObjects:@"Borsa di studio a OA Brera su gruppi e ammassi",@"Borsa di studio a OA Brera sulle galassie ellittiche",@"Assegno di ricerca a OA Napoli",@"Assegno di ricerca a OA Brera",@"Concorso per ricercatore T.D. a IAPS Roma",@"Borsa di studio a OA Cagliari",@"Borsa di studio a OA Brera su gruppi e ammassi",@"Borsa di studio a OA Brera sulle galassie ellittiche",@"Assegno di ricerca a OA Napoli",@"Assegno di ricerca a OA Brera",@"Concorso per ricercatore T.D. a IAPS Roma",@"Borsa di studio a OA Cagliari", nil];
   
    self.title=@"Jobs";
    self.navigationController.navigationBar.tintColor=[UIColor blackColor];
    self.tableView.rowHeight=80;
    self.sfondoView.image=[UIImage imageNamed:@"Assets/cerisola-blu.jpg"];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 12;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    JobsCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil)
    {
        cell= [[JobsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSLog(@"cel");
    
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
    
    cell.textView.text=[bandi objectAtIndex:indexPath.row];
 
    
    
    
    return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DetailJobsViewController * detailJobsViewController = [[DetailJobsViewController alloc] initWithNibName:@"DetailJobsViewController" bundle:nil];
    
    [self.navigationController pushViewController:detailJobsViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
