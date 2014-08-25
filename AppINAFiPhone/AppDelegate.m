//
//  AppDelegate.m
//  AppINAFiPhone
//
//  Created by Nicolo' Parmiggiani on 25/08/14.
//  Created by Nicolo' Parmiggiani on 12/02/14.
// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


#import "AppDelegate.h"
#import "ViewControllerUno.h"
#import "ViewControllerDue.h"
#import "ViewControllerTre.h"
#import "ViewControllerQuattro.h"
#import "ViewControllerCinque.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UITabBarController * tabBarController = [[UITabBarController alloc] init];
    
    
    
    ViewControllerUno *viewUno = [[ViewControllerUno alloc]     initWithNibName:@"ViewControllerUno" bundle:nil];
    ViewControllerDue *viewDue = [[ViewControllerDue alloc]     initWithNibName:@"ViewControllerDue" bundle:nil];
    ViewControllerTre *viewTre = [[ViewControllerTre alloc]     initWithNibName:@"ViewControllerTre" bundle:nil];
    ViewControllerQuattro *viewQuattro = [[ViewControllerQuattro alloc]     initWithNibName:@"ViewControllerQuattro" bundle:nil];
    ViewControllerCinque *viewCinque = [[ViewControllerCinque alloc]     initWithNibName:@"ViewControllerCinque" bundle:nil];
    
    
    UINavigationController *navUno = [[UINavigationController alloc]  initWithRootViewController:viewUno];
    UINavigationController *navDue = [[UINavigationController alloc]  initWithRootViewController:viewDue];
    UINavigationController *navTre = [[UINavigationController alloc]  initWithRootViewController:viewTre];
    UINavigationController *navQuattro = [[UINavigationController alloc]  initWithRootViewController:viewQuattro];
    UINavigationController *navCinque = [[UINavigationController alloc]  initWithRootViewController:viewCinque];
    
    UIDevice *device = [UIDevice currentDevice];
    
    
    if([device.systemVersion hasPrefix:@"7"])
    {
        // NSLog(@"%@",device.systemVersion);
        navUno.navigationBar.translucent = NO;
        navDue.navigationBar.translucent = NO;
        navTre.navigationBar.translucent = NO;
        navQuattro.navigationBar.translucent = NO;
        navCinque.navigationBar.translucent = NO;
        
        navUno.navigationBar.tintColor=[UIColor blackColor];
        navDue.navigationBar.tintColor=[UIColor blackColor];
        navTre.navigationBar.tintColor=[UIColor blackColor];
        navQuattro.navigationBar.tintColor=[UIColor blackColor];
        navCinque.navigationBar.tintColor=[UIColor blackColor];
        
        tabBarController.tabBar.translucent=NO;
        tabBarController.tabBar.tintColor=[UIColor blackColor];
        
        navDue.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"News" image:[UIImage imageNamed:@"Assets/iconaNews7.png"] tag:1];
        navUno.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Home" image:[UIImage imageNamed:@"Assets/iconaHome7.png"] tag:0];
        navTre.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Eventi" image:[UIImage imageNamed:@"Assets/iconaGallery7.png"] tag:2];
        navQuattro.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Video" image:[UIImage imageNamed:@"Assets/iconaVideo7.png"] tag:3];
        navCinque.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"More" image:[UIImage imageNamed:@"Assets/iconaMore7.png"] tag:4];
        
        
    }
    else
    {
        
        [navUno.navigationBar setBarStyle:UIBarStyleBlackOpaque];
        [navDue.navigationBar setBarStyle:UIBarStyleBlackOpaque];
        [navTre.navigationBar setBarStyle:UIBarStyleBlackOpaque];
        [navQuattro.navigationBar setBarStyle:UIBarStyleBlackOpaque];
        
        [navCinque.navigationBar setBarStyle:UIBarStyleBlackOpaque];
        
        navDue.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"News" image:[UIImage imageNamed:@"Assets/iconaNews.png"] tag:1];
        navUno.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Home" image:[UIImage imageNamed:@"Assets/iconaHome.png"] tag:0];
        navTre.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Gallery" image:[UIImage imageNamed:@"Assets/iconaGallery.png"] tag:2];
        navQuattro.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Video" image:[UIImage imageNamed:@"Assets/iconaVideo.png"] tag:3];
        navCinque.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"INAF" image:[UIImage imageNamed:@"Assets/iconaMore.png"] tag:4];
        
        
    }
    
    
    tabBarController.viewControllers=[NSArray arrayWithObjects:navUno,navDue,navTre,navQuattro,navCinque,nil];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] ;
    
    // Override point for customization after application launch.
    
    
    
    self.window.rootViewController = tabBarController;
    
    [self.window makeKeyAndVisible];
    
    // Override point for customization after application launch.
    return YES;

}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
