//
//  ViewControllerUno.m
//  INAF1
//
//  Created by Nicolo' Parmiggiani on 12/02/14.
// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "ViewControllerUno.h"
#import "ViewControllerInfo.h"
#import "HomeTableViewCell.h"
#import "DetailNewsViewController.h"
#import "ViewControllerCredits.h"

@interface ViewControllerUno ()

@end



@implementation ViewControllerUno

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) apriInfo
{
    NSLog(@"info");
    
    ViewControllerInfo * viewControllerInfo = [[ViewControllerInfo alloc] initWithNibName:@"ViewControllerInfo" bundle:nil];
    
    [self presentViewController:viewControllerInfo animated:YES completion:nil];
    
}
-(void) apriCredits
{
    ViewControllerCredits * viewControllerCredits = [[ViewControllerCredits alloc] initWithNibName:@"ViewControllerCredits" bundle:nil];
    
    [self presentViewController:viewControllerCredits animated:YES completion:nil];
    
}
- (NSString *)applicationDocumentsDirectory
{
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"recive data");
    
    NSError * jsonParsingError = nil;
    
    NSDictionary * jsonElement = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
    
    NSDictionary * json = [jsonElement objectForKey:@"response"];
    
    NSString * urlImage = [json objectForKey:@"urlMainSplashScreen"];
    
    
    
    NSData * dataImmagine = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlImage]];
    
    UIImage * image = [UIImage imageWithData:dataImmagine];
    
    NSString * pathIm= [[NSString alloc] initWithFormat:@"immaginehome.plist"];
    NSString * pathIm2 = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:pathIm];

    
    [NSKeyedArchiver archiveRootObject:image toFile:pathIm2 ];
    
    
    
}
- (void)viewDidLoad
{
    //NSString * immagine = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://app.media.inaf.it/GetSplashImage.php?width=768&height=280&deviceName=iphone"] encoding:NSUTF8StringEncoding error:nil];
  //  self.logoInaf.image = [UIImage imageNamed:@"Assets/logoinaf.gif"];
    
  //  self.title = @"INAF";
    self.navigationItem.title=@"INAF";

    self.sfondoView.image=[UIImage imageNamed:@"Assets/galileo2.jpg"];
    
    UIButton * credits = [UIButton buttonWithType:UIButtonTypeInfoLight];
    
    [credits addTarget:self
                action:@selector(apriCredits)
      forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * Credits = [[UIBarButtonItem alloc] initWithCustomView: credits ];
    
    self.navigationItem.leftBarButtonItem= Credits;

    UIImage * bottoneSatellite = [UIImage imageNamed:@"Assets/logoINAF2.png"];
    
    UIButton * bottone = [UIButton buttonWithType:UIButtonTypeInfoDark];
    
    [bottone addTarget:self action:@selector(apriInfo) forControlEvents:UIControlEventTouchUpInside];
    
    [bottone setImage:bottoneSatellite forState:UIControlStateNormal];
    
    [bottone setFrame:CGRectMake(310, 2, 30, 30)];
    
    UIBarButtonItem * buttonBar = [[UIBarButtonItem alloc] initWithCustomView:bottone];
    
    self.navigationItem.rightBarButtonItem=buttonBar;

    
    // scarica immagine home
    NSString* foofile = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"immaginehome.plist"];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:foofile])
    {
        NSLog(@"caso 1");
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://app.media.inaf.it/GetSplashImage.php?width=320&height=209&deviceName=iphone"]];
        
        NSData * response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        NSError * jsonParsingError = nil;
        
        NSDictionary * jsonElement = [NSJSONSerialization JSONObjectWithData:response options:0 error:&jsonParsingError];
        
        NSDictionary * json = [jsonElement objectForKey:@"response"];
        
        NSString * urlImage = [json objectForKey:@"urlMainSplashScreen"];
        
               
        
        NSData * dataImmagine = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlImage]];
        
        UIImage * image = [UIImage imageWithData:dataImmagine];
        
        
        NSString * pathIm= [[NSString alloc] initWithFormat:@"immaginehome.plist"];
        NSString * pathIm2 = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:pathIm];
        
        self.logoInaf.image=image;

        
        [NSKeyedArchiver archiveRootObject:image toFile:pathIm2 ];
        
    }
    else
    {
        NSLog(@"caso 2");
        
        NSString * pathIm= [[NSString alloc] initWithFormat:@"immaginehome.plist"];
        NSString * pathIm2 = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:pathIm];
      
        UIImage * image =   [NSKeyedUnarchiver unarchiveObjectWithFile:pathIm2];
        
        self.logoInaf.image=image;
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://app.media.inaf.it/GetSplashImage.php?width=320&height=209&deviceName=iphone"]];
        
        NSURLConnection * connection = [[NSURLConnection alloc ] initWithRequest:request delegate:self];
        
        [connection start];
        
       
    }
    
    
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    //NSLog(@"%@",immagine);
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}





-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 3;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
     HomeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil)
    {
        cell= [[HomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSLog(@"cel");

    cell.anteprima.text = @"Là dove osa Voyager 1";
    cell.immaginePreview.image = [UIImage imageNamed:@"Assets/thumb-ibex-150x150.jpg"];
    cell.backgroundView.alpha = 0.7;
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1];
    /*
     if(self.numeroNews>0)
     {
     
     int index = [self.numeroNews intValue] - indexPath.row-1;
     
     NSString * pathArchivio1= [NSString stringWithFormat:@"%@.plist",  [ self.newsPath objectAtIndex: index]];
     NSString * pathArchivio2 = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:pathArchivio1];
     
     
     News *  notiziaA= [NSKeyedUnarchiver unarchiveObjectWithFile:pathArchivio2];
     
     NSLog(@"%@ %@",notiziaA.anteprimaEN,notiziaA.anteprima);
     
     
     NSLog(@"crea cella %@",notiziaA.fotoPiccolaPath);
     
     NSString * locale  = [[NSLocale currentLocale] localeIdentifier];
     
     char a = [locale characterAtIndex:0];
     char b = [locale characterAtIndex:1];
     
     NSLog(@"%@",locale);
     
     if(a=='i' && b=='t')
     {
     
     cell.testoAnteprima.text = notiziaA.anteprima;
     cell.imageView.image= notiziaA.fotoPath;
     }
     else
     {
     
     
     
     
     cell.testoAnteprima.text = notiziaA.anteprimaEN;
     
     NSLog(@"ing %@",notiziaA.anteprimaEN);
     
     cell.imageView.image= notiziaA.fotoPath;
     
     }
     
     
     
     }
     */
    
    
    
    
    //cell.imageView.image = ogg.fotoPiccola;
    
    
    
    
    
    return cell;
    

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DetailNewsViewController * detailNewsViewController = [[DetailNewsViewController alloc] initWithNibName:@"DetailNewsViewController" bundle:nil];
    
    detailNewsViewController.anteprima=@"Là dove osa Voyager 1";

    [self.navigationController pushViewController:detailNewsViewController animated:YES];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
