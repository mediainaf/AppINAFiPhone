//
//  WebCamViewController.m
//  AppINAFiPhone
//
//  Created by Nicolo' Parmiggiani on 30/08/14.
//  Copyright (c) 2014 Nicolo' Parmiggiani. All rights reserved.
//

#import "WebCamViewController.h"
#import "WebcamCell.h"

@interface WebCamViewController ()
{
    NSMutableArray * webcamName;
    NSMutableDictionary *cachedImages;
    
    NSMutableData * responseData;
    NSMutableArray * webcamLink;
    
    NSTimer * timer;
    
    
}
@end

@implementation WebCamViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [responseData setLength:0];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if(responseData.length>0)
    {
        [webcamLink removeAllObjects];
        [webcamName removeAllObjects];
        
        
        NSArray * json;
        NSError *e = nil;
        
        
        
        
        json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error: &e];
     
        
        
        for(NSDictionary * d in json)
        {
            
            NSString * nome = [d objectForKey:@"title"];
            NSString * link = [d objectForKey:@"source"];
            
            [webcamName addObject:nome];
            [webcamLink addObject:link];
        }
        
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Errore!" message:@"Controllare la connessione a internet" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    NSLog(@"prereload");
    
    [self.collectionView reloadData];
    
    [timer fire];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [responseData appendData:data];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Errore!" message:@"Controllare la connessione a internet" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
 
    [alert show];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    
    NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://app.media.inaf.it/GetWebcams.php"]] delegate:self];
    
    
    [connection start];
    
//    
//    
//    
//    NSString *response1 = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://app.media.inaf.it/GetSatellites.php"] encoding:NSUTF8StringEncoding error:nil];
//    if(!response1)
//    {
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Internet Connection Error" message:@"Change internet settings" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//    }
    
    
    // [self.collectionView reloadData];
}
-(void) reloadWebcam
{
    
    for(int i =0;i <webcamLink.count ;i++)
    {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,  0ul);
        dispatch_async(queue, ^{
            //This is what you will load lazily
            
            NSData   *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[webcamLink objectAtIndex:i ] ]];
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                NSLog(@"immagine scaricata");
                
                NSString *identifier = [NSString stringWithFormat:@"Cell%d" ,i];
                
                
                
                UIImage * image = [UIImage imageWithData:data];
                if(image)
                {
                    [cachedImages setObject:image forKey:identifier];
                    //cell.thumbnail.image = image;
                    
                    [UIView setAnimationsEnabled:NO];
                    
                    [self.collectionView performBatchUpdates:^{
                        [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:i inSection:0]]];
                        
                    } completion:^(BOOL finished) {
                        [UIView setAnimationsEnabled:YES];
                    }];
                }
                
            });
        });
        
    }
    // [self.collectionView reloadData];
    
    NSLog(@"reload");
}

-(void)viewDidDisappear:(BOOL)animated
{
    [timer invalidate];
}


-(void)viewWillAppear:(BOOL)animated
{
    
    
    //[self deviceOrientationDidChangeNotification:nil];
}
- (void)viewDidLoad
{
    
    responseData = [[NSMutableData alloc]init];
    webcamLink = [[NSMutableArray alloc]init];
    webcamName = [[NSMutableArray alloc]init];

    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //[flowLayout setItemSize:CGSizeMake(354, 414)];
    [flowLayout setItemSize:CGSizeMake(320  , 385)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setMinimumLineSpacing:20.0];
    [flowLayout setSectionInset:UIEdgeInsetsMake(20, 20, 20, 20)];
    
   // [self.collectionView setFrame:CGRectMake(0, 0,1024, 668)];
    
    [self.collectionView setCollectionViewLayout:flowLayout];

    
    UIBarButtonItem * button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadWebcam)];
    
    self.navigationItem.rightBarButtonItem= button;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(reloadWebcam) userInfo:nil repeats:YES];
    
    
    cachedImages = [[NSMutableDictionary alloc] init];

    
    //
//    webcamLink = [NSArray arrayWithObjects:@"http://www.med.ira.inaf.it/webcam.jpg",
//                  @"http://abell.as.arizona.edu/~hill/lbtmc02/image.jpg",
//                  @"http://abell.as.arizona.edu/~hill/lbtcam/hugesize.jpg",
//                  @"http://www.tt1obs.org/slideshow/p013_1_1.jpg",
//                  @"http://www.srt.inaf.it/static/img/web-image-last-ts.jpg?1402669975",
//                  @"http://www.tng.iac.es/webcam/get.html?resolution=640x480&compression=30&clock=1&date=1&dummy=1402670070248",
//                  @"http://www.noto.ira.inaf.it/cams/cam1.jpg",
//                  @"http://www.magic.iac.es/webcams/webcam/2014/06/13/1530_la.jpg",
//                  @"http://www.magic.iac.es/webcams/webcam2/2014/06/13/1530_la.jpg",
//                  @"http://archive.oapd.inaf.it/meteo/webcam_high.jpg",
//                  @"http://archive.oapd.inaf.it/meteo/videocam_low.jpg",
//                  @"http://polaris.me.oa-brera.inaf.it/remwbc/remwbc1.jpg",
//                  @"http://polaris.me.oa-brera.inaf.it/remwbc/remwbc2.jpg",
//                  @"http://polaris.me.oa-brera.inaf.it/remwbc/remwbcx.jpg",
//                  @"http://www.media.inaf.it/wp-content/uploads/webcams/img_6.jpg",nil];
//    
//    
//    webcamName = [NSArray arrayWithObjects:
//                  @"Radiotelescopio di Medicina (Bologna)",
//                  @"Large Binocular Telescope (Arizona,US) - Interno sx fronte",
//                  @"Large Binocular Telescope (Arizona,US) - Esterno",
//                  @" Il telescopio TT1 di Toppo Castel-grande (PZ)",
//                  @"Sardinia Radio Telescope (Cagliari)",
//                  @"Telescopio Nazionale Galileo (Isole Canarie)",
//                  @"Radiotelescopio di Noto (SR)",
//                  @"Il telescopio Cherenkov MAGIC-I (Isole Canarie)",
//                  @"Il telescopio Cherenkov MAGIC-II (Isole Canarie)",
//                  @"Stazione Osservativa di Cima Ekar (Asiago) - High",
//                  @"Stazione Osservativa di Cima Ekar (Asiago) - Low",
//                  @"Telescopio REM- Rapid Ey Mount (La Silla, Cile)",
//                  @"Telescopio REM- Rapid Ey Mount (La Silla, Cile)",
//                  @"Telescopio REM- Rapid Ey Mount (La Silla, Cile)",
//                  @"Il telescopio di Loiano (Bologna)",
//                  nil];
//    
    
    
    self.title = @"Webcam";
    
    [self.collectionView registerClass:[WebcamCell class] forCellWithReuseIdentifier:@"cvCell"];
    
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(webcamLink.count >0)
        return webcamLink.count;
    
    return 4;
  
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cvCell";
    
    WebcamCell *cell = (WebcamCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
     cell.backgroundColor=[UIColor colorWithWhite:0.9 alpha:0.7];

    if(webcamLink.count >0)
    {
    
   
    
        cell.title.text = [webcamName objectAtIndex:indexPath.row];
        
        
        
        NSLog(@"cel %ld",(long)indexPath.row);
        
        NSString *identifier = [NSString stringWithFormat:@"Cell%ld" ,
                                (long)indexPath.row];
        
        
        if([cachedImages objectForKey:identifier] != nil)
        {
            cell.webcam.image = [cachedImages valueForKey:identifier];
            [cell.indicator stopAnimating];
            //  NSLog(@"metti immagine");
            
        }
        else
        {
            cell.webcam.image = nil;
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,  0ul);
            dispatch_async(queue, ^{
                //This is what you will load lazily
                
                NSData   *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[webcamLink objectAtIndex:indexPath.row ] ]];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                    //      NSLog(@"immagine scaricata");
                    
                    UIImage * image = [UIImage imageWithData:data];
                    if(image)
                    {
                        [cachedImages setObject:image forKey:identifier];
                        //cell.thumbnail.image = image;
                        [cell setNeedsLayout];
                        [UIView setAnimationsEnabled:NO];
                        
                        [self.collectionView performBatchUpdates:^{
                            [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
                            
                        } completion:^(BOOL finished) {
                            [UIView setAnimationsEnabled:YES];
                        }];
                    }
                    
                });
            });
            
        }
    }
    
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     NSLog(@"deselect");
     
     NSString *identifier = [NSString stringWithFormat:@"Cell%d" ,
     indexPath.row];
     
     DetailVideoViewController * detail = [[DetailVideoViewController alloc] initWithNibName:@"DetailVideoViewController" bundle:nil];
     
     
     
     detail.video = [video objectAtIndex:indexPath.row];
     detail.thumbnail = [cachedImages objectForKey:identifier];
     
     
     
     [self.navigationController pushViewController:detail animated:YES];
     
     [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];*/
    [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
