//
//  DetailNewsViewController.m
//  INAF1
//
//  Created by Nicolo' Parmiggiani on 14/02/14.
// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "News.h"
#import "DetailEventsViewController.h"
#import "InternetNewsViewController.h"
#import "ViewControllerImagineGrande.h"

@interface DetailEventsViewController ()

@end

@implementation DetailEventsViewController

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
        
        NSArray *postItems = [NSArray arrayWithObjects:titolo,spazio,self.news.link,self.immagine.image, nil];
        
        UIActivityViewController *activityVC = [[UIActivityViewController alloc]
                                                initWithActivityItems:postItems
                                                applicationActivities:nil];
        
        [self presentViewController:activityVC animated:YES completion:nil];
        
    }
    if(buttonIndex == 1)
    {
        InternetNewsViewController * internetViewController = [[InternetNewsViewController alloc] initWithNibName:@"InternetNewsViewController" bundle:nil];
        
        NSArray * elements = [ self.news.link componentsSeparatedByString:@"/"];
        
        NSMutableArray * elementsArray = [[NSMutableArray alloc] init ];
        
        [elementsArray setArray:elements];
        
        [elementsArray removeLastObject];
        
        NSMutableString * link = [[NSMutableString alloc] initWithString:[elementsArray componentsJoinedByString:@"/"]];
        
        
        
        internetViewController.link =link;

        
        [self.navigationController pushViewController:internetViewController animated:YES];
        
        NSLog(@"Apri link");
    }
    if(buttonIndex == 2)
    {
        NSLog(@"immagine grande");
        
        ViewControllerImagineGrande * viewControllerImmagineGrande = [[ViewControllerImagineGrande alloc]initWithNibName:@"ViewControllerImagineGrande" bundle:nil];
        
        viewControllerImmagineGrande.imageUrl= [self.news.images objectAtIndex:0];
        
        [self.navigationController pushViewController:viewControllerImmagineGrande animated:YES];
        
    }
}
-(void) OpenLink
{
    UIActionSheet * action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share",@"Open link",@"Open Image", nil];
    [action showFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
    
    
    
}
-(CGSize) getContentSize:(UITextView*) myTextView{
    return [myTextView sizeThatFits:CGSizeMake(myTextView.frame.size.width, FLT_MAX)];
}
-(void) calcolaScroll
{
    
    CGRect rect      = self.testo.frame;
    rect.size.height = [self getContentSize:self.testo].height;
    self.testo.frame   = rect;
    
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.testo.frame.origin.y+self.testo.frame.size.height+50)];
    
    
    rect = self.data.frame;
    rect.origin.y = self.testo.frame.origin.y+20+self.testo.frame.size.height ;
    self.data.frame = rect;
    
    rect = self.autore.frame;
    
    rect.origin.y = self.testo.frame.origin.y+20+self.testo.frame.size.height ;
    self.autore.frame = rect;
    

    NSLog(@"calcola %f",self.testo.contentSize.height);
}

-(void)viewDidLayoutSubviews
{
    NSLog(@"layou");
}
-(void)viewDidAppear:(BOOL)animated
{
    
    
    
    
    NSLog(@"appear");
    // [self performSelector:@selector(calcolaScroll) withObject:self afterDelay:0.4];
    //[self performSelector:@selector(calcolaScroll) withObject:self afterDelay:2.0];
    [self calcolaScroll];
    
    
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"3%f",self.testo.contentSize.height);
}
- (void)viewDidLoad
{
    //self.testo.scrollEnabled=YES;
    
    self.testo.text = self.news.content;
    
    UIBarButtonItem * apriImmagine = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(OpenLink)];
    
    [self.navigationItem setRightBarButtonItem:apriImmagine animated:YES];
    
    self.sfindoView.image = [UIImage imageNamed:@"Assets/sunset1.jpg"];
    //self.sfondoView.image = [UIImage imageNamed:@"Assets/galileo4.jpg"];
    self.sfindoView.alpha = 0.6;
    
    self.titolo.text = self.news.title;
    self.sommario.text = self.news.summary;
    
    
    
    
    self.autore.text = self.news.author;
    self.data.text = self.news.date;
    
    
    if([self.news.images count] >0 && [self.news.videos count] == 0)
    {
        NSLog(@"1");
        
        
        [self.immagine setHidden:NO];
        char const * s = [@"s"  UTF8String];
        
        dispatch_queue_t queue = dispatch_queue_create(s, 0);
        
        dispatch_async(queue, ^
                       {
                           NSString * imageUrl =  [self.news.images objectAtIndex:0] ;
                           
                           NSArray * elements = [ imageUrl componentsSeparatedByString:@"/"];
                           
                           int number = [elements count];
                           
                           NSString * url = [NSString stringWithFormat:@"http://app.media.inaf.it/GetMediaImage.php?sourceYear=%@&sourceMonth=%@&sourceName=%@&width=300&height=122",[elements objectAtIndex:number-3],[elements objectAtIndex:number-2],[elements objectAtIndex:number-1]];
                           
                           NSString *response1 = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil];
                           if(!response1)
                           {
                               UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Internet Connection Error" message:@"Change internet settings" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                               [alert show];
                           }
                           
                           NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
                           
                           NSData * response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
                           
                           self.immagine.image = nil;
                           
                           if(response != nil)
                           {
                               
                               NSError * jsonParsingError = nil;
                               
                               NSDictionary * jsonElement = [NSJSONSerialization JSONObjectWithData:response options:0 error:&jsonParsingError];
                               
                               NSDictionary * json = [jsonElement objectForKey:@"response"];
                               
                               NSString * urlImage = [json objectForKey:@"urlResizedImage"];
                               
                               NSData * dataImmagine = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlImage]];
                               
                               
                               
                               dispatch_async(dispatch_get_main_queue(), ^
                                              {
                                                  NSLog(@"load image");
                                                  
                                                  UIImage * img = [[UIImage alloc] initWithData:dataImmagine];
                                                  
                                                  self.immagine.image=img;
                                                  
                                                  
                                                  
                                              });//end
                           }
                           
                       });//end
        
        
        
        
    }
    else if([self.news.videos count] >0)
    {
        NSLog(@"load video");
        [self loadVideo];
    }
    else
    {
        NSLog(@"3");
        [self.immagine setHidden:NO];
        self.immagine.image = [UIImage imageNamed:@"Assets/newsDefault.png"];
        
    }
    
    
    /*
     
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
     label.text = self.title;    */
    
    //self.immagine.image = [UIImage imageNamed:@"Assets/news2.jpg"];
    //self.immagine.contentMode= UIViewContentModeScaleAspectFit;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void) loadVideo
{
    
    
    [self.webView setHidden:NO];
    
    NSMutableString *html = [NSMutableString string];
    [html appendString:@"<html>"];
    [html appendString:@"<head>"];
    [html appendString:@"<style type=\"text/css\">"];
    [html appendString:@"body {"];
    [html appendString:@"background-color: transparent;"];
    [html appendString:@"color: white;"];
    [html appendString:@"margin: 0;"];
    [html appendString:@"}"];
    [html appendString:@"</style>"];
    [html appendString:@"</head>"];
    [html appendString:@"<body>"];
    [html appendFormat:@"<iframe id=\"ytplayer\" type=\"text/html\" width=\"%0.0f\" height=\"%0.0f\" src=\"%@\" frameborder=\"0\"/>", self.webView.frame.size.width, self.webView.frame.size.height, [self.news.videos objectAtIndex:0]];
    [html appendString:@"</body>"];
    [html appendString:@"</html>"];
    
    //[self.indicator stopAnimating];
    
    [self.webView loadHTMLString:html baseURL:nil];
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
