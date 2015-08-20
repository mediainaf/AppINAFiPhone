//
//  TvViewController.m
//  AppINAFiPhone
//
//  Created by Nicolo' Parmiggiani on 20/08/15.
//  Copyright (c) 2015 Nicolo' Parmiggiani. All rights reserved.
//

#import "TvViewController.h"

@interface TvViewController ()

@end

@implementation TvViewController
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.indicator stopAnimating];
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
    
    NSLog(@"%d", error.code);
    
    if(error.code!=-999)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Internet connection failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        
        [alert show];
        
        [self.indicator stopAnimating];
    }
}
-(void)viewDidAppear:(BOOL)animated
{
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://astrochannel.media.inaf.it/"]]];
}
- (void)viewDidLoad {
    self.webView.scalesPageToFit=YES;

    

    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
