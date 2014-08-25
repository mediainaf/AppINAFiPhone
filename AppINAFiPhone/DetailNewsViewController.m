//
//  DetailNewsViewController.m
//  INAF1
//
//  Created by Nicolo' Parmiggiani on 14/02/14.
// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "News.h"
#import "DetailNewsViewController.h"
#import "InternetNewsViewController.h"
#import "ViewControllerImagineGrande.h"

@interface DetailNewsViewController ()

@end

@implementation DetailNewsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        NSString *titolo = self.news.title;
        NSString* spazio = @"";
        NSURL   *imageToShare = [NSURL URLWithString:self.news.link];
        
        NSArray *postItems = [NSArray arrayWithObjects:titolo,spazio,imageToShare, nil];
        
        UIActivityViewController *activityVC = [[UIActivityViewController alloc]
                                                initWithActivityItems:postItems
                                                applicationActivities:nil];
        
        [self presentViewController:activityVC animated:YES completion:nil];

    }
    if(buttonIndex == 1)
    {
        InternetNewsViewController * internetViewController = [[InternetNewsViewController alloc] initWithNibName:@"InternetNewsViewController" bundle:nil];
        
        internetViewController.link =self.news.link;
        
        [self.navigationController pushViewController:internetViewController animated:YES];
        
        NSLog(@"Apri link");
    }
}
-(void) OpenLink
{
    UIActionSheet * action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share",@"Open link", nil];
    [action showFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
    
    
    
}
-(UIImage*)imageWithImage:(UIImage*)image
{
    /*
    
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSLog( @"immagine");
    return  newImage;
    */
    
   CGImageRef  mySubimage;
    
    CGSize  size = image.size;
    
    UIImage * immagine;
    
    if(size.height >= size.width)
    {
        float w = size.width;
        float h = w / 2.5;
        
        float y = size.height/2 - (h/2);
        float x = size.width/2 - (w /2);
        
        CGRect  myImageArea = CGRectMake (x, y,w ,h );
        
        mySubimage = CGImageCreateWithImageInRect (image.CGImage, myImageArea);

        
         immagine = [UIImage imageWithCGImage:mySubimage];
        
    }
    else
    {

        float h = size.height;
        float w = h*2.5;
        
        float y = size.height/2 - (h/2);
        float x = size.width/2 - (w /2);
        
        CGRect  myImageArea = CGRectMake (x, y,w ,h );
        
        mySubimage = CGImageCreateWithImageInRect (image.CGImage, myImageArea);
        
        
        immagine = [UIImage imageWithCGImage:mySubimage];
        
    }
    
    

   
    
    
    
    
    //myRect = CGRectMake(0, 0, myWidth*2, myHeight*2);
    
    //CGContextDrawImage(context, myRect, mySubimage);

    
    return immagine;
    
}
- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer
{
    NSString * urlImmGrande = [[NSString alloc]initWithFormat:@"http://marlin.iasfbo.inaf.it/AGILEApp/NEWS/big_AGILE.png"];
    
    
   
        ViewControllerImagineGrande * viewControllerImmagineGrande = [[ViewControllerImagineGrande alloc]initWithNibName:@"ViewControllerImagineGrande" bundle:nil];
        
        //viewControllerImmagineGrande.immagineUrl=urlImmGrande;
        
        [self.navigationController pushViewController:viewControllerImmagineGrande animated:YES];
    
}

- (void)viewDidLoad
{
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
  
    
    [self.immagine addGestureRecognizer:singleTap];

    
    //self.sfindoView.image = [UIImage imageNamed:@"Assets/lbt3.jpg"];
    
 //   self.title = self.anteprima;
    
    
    self.testo.text = self.news.content;
    
    char const * s = [@"s"  UTF8String];
    
    
    
    dispatch_queue_t queue = dispatch_queue_create(s, 0);
    
    dispatch_async(queue, ^
                   {
                       NSString *url = [self.news.images objectAtIndex:0];
                       
                       UIImage *img = nil;
                       
                       NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
                       
                       img = [[UIImage alloc] initWithData:data];
                       
                       dispatch_async(dispatch_get_main_queue(), ^
                                      {
                                          NSLog(@"load image");
                                          
                                          
                                          UIImage * image = [self imageWithImage:img];
                                          
                                          self.immagine.image=image;
                                          
                                      });//end
                   });//end
    
    

    self.titolo.text = self.news.title;
        
    UIBarButtonItem * apriImmagine = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(OpenLink)];
    
    [self.navigationItem setRightBarButtonItem:apriImmagine animated:YES];

    
    CGRect frame = CGRectMake(0, 0, [self.title sizeWithFont:[UIFont boldSystemFontOfSize:15.0]].width, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:15.0];
    label.textColor=[UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    self.navigationItem.titleView = label;
    label.text = self.title;
    
    //self.immagine.image = [UIImage imageNamed:@"Assets/news2.jpg"];
    //self.immagine.contentMode= UIViewContentModeScaleAspectFit;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
