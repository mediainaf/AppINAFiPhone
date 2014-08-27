//
//  ViewControllerQuattro.m
//  INAF1
//
//  Created by Nicolo' Parmiggiani on 12/02/14.
// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "ViewControllerQuattro.h"
#import "DettagliVideoViewController.h"
#import "VideoCell.h"
#import "Parser.h"
#import "Video.h"

@interface ViewControllerQuattro ()
{
    BOOL load;
 
    NSMutableArray * video;
    NSMutableDictionary *cachedImages;
    NSMutableDictionary *tableImages;

    UIRefreshControl *refreshControl;
    

    int page;
   
}

@end

@implementation ViewControllerQuattro

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated
{
    if(!load)
    {
        load=YES;
        
       
        [self loadData];
     
        
    }
}
-(void) loadData
{
    [self.loadingView setHidden:YES];
    
    
    NSString *response1 = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://gdata.youtube.com/feeds/api/users/inaftv/uploads?alt=json&max-results=50"] encoding:NSUTF8StringEncoding error:nil];
    if(!response1)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Internet Connection Error" message:@"Change internet settings" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://gdata.youtube.com/feeds/api/users/inaftv/uploads?alt=json&max-results=50"]];
    
    NSData * response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    
    NSArray *jsonArray ;
    if (response) {
        
        NSError *e = nil;
        jsonArray = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error: &e];
        
    }
    
    NSDictionary *results = [jsonArray valueForKey:@"feed"];
    
    NSArray * entry = [results valueForKey:@"entry"];
    
    for(NSDictionary * vid in entry)
    {
        
        Video * v = [[Video alloc]init];
        
        NSDictionary * token = [vid valueForKey:@"id"];
        NSString * linktoken = [token valueForKey:@"$t"];
        NSArray * elementi =  [linktoken componentsSeparatedByString:@"/"];
        v.videoToken = [elementi objectAtIndex:6];
        
        NSDictionary * titolo = [vid valueForKey:@"title"];
        NSLog(@"titolo %@",[titolo valueForKey:@"$t"]);
        v.title = [titolo valueForKey:@"$t"];
        
        NSDictionary * lin = [vid valueForKey:@"link"];
        NSArray * linkTot = [lin valueForKey:@"href"];
        v.link = [linkTot objectAtIndex:0];
        NSLog(@"link %@",v.link);
        
        NSDictionary * mediaGroup = [vid valueForKey:@"media$group"];
        NSDictionary * mediaDescription = [mediaGroup valueForKey:@"media$description"];
        v.summary = [mediaDescription valueForKey:@"$t"];
        NSLog(@"description %@",v.summary);
        
        NSArray * mediaThumbnail = [mediaGroup valueForKey:@"media$thumbnail"];
        NSDictionary * thumbnail = [mediaThumbnail objectAtIndex:0];
        v.thumbnail = [thumbnail valueForKey:@"url"];
        NSLog(@"thumbnail %@",v.thumbnail);
        
        NSDictionary * like = [vid valueForKey:@"gd$rating"];
        v.numberOfLike = [like valueForKey:@"numRaters"];
        NSLog(@"raters %@",v.numberOfLike);
        
        NSDictionary * view = [vid valueForKey:@"yt$statistics"];
        v.numberOfView = [view valueForKey:@"viewCount"];
        NSLog(@"view %@",v.numberOfView);
        
        NSDictionary * date = [vid valueForKey:@"published"];
        NSString * dateFormatted = [date valueForKey:@"$t"];
        NSLog(@"data %@",dateFormatted);
        NSArray * elementiData  = [dateFormatted componentsSeparatedByString:@"T"];
        /*
         NSString * day = [elementiData objectAtIndex:1];
         NSString * DM = [day stringByAppendingString:[NSString stringWithFormat:@" %@",[elementiData objectAtIndex:2]]];
         NSString * DMY = [DM stringByAppendingString:[NSString stringWithFormat:@" %@",[elementiData objectAtIndex:3]]];
         */
        v.data = [elementiData objectAtIndex:0];
        
        NSLog(@"data %@",v.data);
        
        
        [video addObject:v];
    }
    
    [self.collectionView reloadData];
    
    [self.loadingView setHidden:YES];
    
    [refreshControl endRefreshing];
    
    

    
}
-(void) reloadData : (id) selector
{
    
    [self.loadingView setHidden:NO];
    
    load =1;
    page = 1;
    
    
    [self loadData];
    
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
       //[self.collectionView setContentOffset:CGPointZero animated:YES];
    
    [refreshControl removeFromSuperview];
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh)
             forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:refreshControl];
    
    [refreshControl setTintColor:[UIColor whiteColor]];
    
    self.collectionView.alwaysBounceVertical = YES;
    
}
-(void) refresh
{
    [self performSelector:@selector(reloadData:) withObject:nil afterDelay:0.5];
}
- (void)viewDidLoad
{
    
    [self.collectionView setContentOffset:CGPointMake(0, -refreshControl.frame.size.height) animated:YES];
    [refreshControl beginRefreshing];
    
    
    self.loadingView.image = [UIImage imageNamed:@"Assets/loadingNews.png"];
    
    
    cachedImages = [[NSMutableDictionary alloc] init];

    
    [self.collectionView registerClass:[VideoCell class] forCellWithReuseIdentifier:@"cvCell"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(300, 345)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setMinimumLineSpacing:10.0];
    [flowLayout setSectionInset:UIEdgeInsetsMake(10, 10, 10, 10)];
    // [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    [self.collectionView setCollectionViewLayout:flowLayout];
    
    
    self.title=@"Video";
    
    self.sfondoView.image=[UIImage imageNamed:@"Assets/cerisola3.jpg"];
    self.sfondoView.alpha = 0.6;

    
    
    video = [[NSMutableArray alloc] init];
    
    
    
       // [self.tableView setFrame:CGRectMake(0, 44, 320, 387)];
    // if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    //   self.edgesForExtendedLayout = UIRectEdgeNone;

    self.sfondoView.alpha = 0.7;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}



-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if([video count]>0)
        return  [video count];
    
    return 6 ;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cvCell";
    
     VideoCell *cell = (VideoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor=[UIColor colorWithWhite:1.0 alpha:0.5];
    
    if([video count]>0)
    {
        
        
        NSLog(@"cel");
        
        Video * v  = [video objectAtIndex:indexPath.row];
        
        cell.titolo.textColor=[UIColor blackColor];
        cell.titolo.text = v.title;
       // cell.testo.text = v.summary;
        cell.visualizzazioni.text = [NSString stringWithFormat:@"%@ visualizzazioni",v.numberOfView];
        cell.data.text = v.data;
        //sNSLog(@"%lu",(unsigned long)[notizie count]);
        
        // [cell.immaginePreview loadImageAtURL:[NSURL URLWithString:[[notizie objectAtIndex:indexPath.row] linkImageSmall]]];
        NSString *identifier = [NSString stringWithFormat:@"Cell%d" ,
                                indexPath.row];
        
        if([cachedImages objectForKey:identifier] != nil)
        {
            cell.immagine.image = [cachedImages valueForKey:identifier];
            cell.play.hidden=NO;
            
        }
        else
        {
            cell.immagine.image = nil;
            cell.play.hidden=YES;
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,  0ul);
            dispatch_async(queue, ^{
                //This is what you will load lazily
                
                NSData   *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:v.thumbnail]];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                    UIImage * image = [UIImage imageWithData:data];
                    [cachedImages setObject:image forKey:identifier];
                    //cell.thumbnail.image = image;
                    [cell setNeedsLayout];
                    [UIView setAnimationsEnabled:NO];
                    
                    [self.collectionView performBatchUpdates:^{
                        [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
                        cell.play.hidden=NO;
                        [cell.indicator stopAnimating];
                        
                    } completion:^(BOOL finished) {
                        [UIView setAnimationsEnabled:YES];
                    }];
                    
                });
            });
            
        }
    }
    //[titleLabel setText:cellData];
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [NSString stringWithFormat:@"Cell%d" ,
                            indexPath.row];
    
    DettagliVideoViewController * detail = [[DettagliVideoViewController alloc] initWithNibName:@"DettagliVideoViewController" bundle:nil];
    
    detail.video = [video objectAtIndex:indexPath.row];
    detail.thumbnail = [cachedImages objectForKey:identifier];
    
    [self.navigationController pushViewController:detail animated:YES];
    
    [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
