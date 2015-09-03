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
{
    UINavigationController *navUno ;
    UINavigationController *navDue;
    UINavigationController *navTre ;
    UINavigationController *navQuattro;
    UINavigationController *navCinque ;
    
    ViewControllerUno *viewUno ;
    ViewControllerDue *viewDue ;
    ViewControllerTre *viewTre ;
    ViewControllerQuattro *viewQuattro;
    ViewControllerCinque *viewCinque;
    
    NSString *messaggioNotifica;
    NSDictionary * userINFO;
    int numeroVersione;
    NSString * versioneSistema;
    char versione;
    UITabBarController * tabBarController ;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    versioneSistema = [[UIDevice currentDevice] systemVersion];
    
    UIDevice * device = [UIDevice currentDevice];
    
    
    
    versione = [versioneSistema characterAtIndex:0];
    
    
    
    NSLog(@"%c",versione);
    
    if(![versioneSistema hasPrefix:@"5"])
    {
        NSLog(@"registra notifiche %d",numeroVersione);
        
        if(versione != '6' && versione != '7')
        {
            UIUserNotificationType types = UIUserNotificationTypeSound | UIUserNotificationTypeBadge | UIUserNotificationTypeAlert;
            UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
            //[application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
            
        }
        else
        {
            [application registerForRemoteNotificationTypes: UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
        }
        
        application.applicationIconBadgeNumber = 0;
    }

    
    tabBarController = [[UITabBarController alloc] init];
    
    
    viewUno = [[ViewControllerUno alloc]     initWithNibName:@"ViewControllerUno" bundle:nil];
    viewDue = [[ViewControllerDue alloc]     initWithNibName:@"ViewControllerDue" bundle:nil];
    viewTre = [[ViewControllerTre alloc]     initWithNibName:@"ViewControllerTre" bundle:nil];
    viewQuattro = [[ViewControllerQuattro alloc]     initWithNibName:@"ViewControllerQuattro" bundle:nil];
    viewCinque = [[ViewControllerCinque alloc]     initWithNibName:@"ViewControllerCinque" bundle:nil];
    
    
     navUno = [[UINavigationController alloc]  initWithRootViewController:viewUno];
     navDue = [[UINavigationController alloc]  initWithRootViewController:viewDue];
     navTre = [[UINavigationController alloc]  initWithRootViewController:viewTre];
     navQuattro = [[UINavigationController alloc]  initWithRootViewController:viewQuattro];
    navCinque = [[UINavigationController alloc]  initWithRootViewController:viewCinque];
    
    
    if(![device.systemVersion hasPrefix:@"6"])
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
        navTre.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Eventi" image:[UIImage imageNamed:@"Assets/iconaGallery.png"] tag:2];
        navQuattro.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Video" image:[UIImage imageNamed:@"Assets/iconaVideo.png"] tag:3];
        navCinque.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"More" image:[UIImage imageNamed:@"Assets/iconaMore.png"] tag:4];
        
        
    }
    
    
    tabBarController.viewControllers=[NSArray arrayWithObjects:navUno,navDue,navTre,navQuattro,navCinque,nil];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] ;
    
    // Override point for customization after application launch.
    
    
    
    self.window.rootViewController = tabBarController;
    
    [self.window makeKeyAndVisible];
    
    // Override point for customization after application launch.
    return YES;

}
#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}
#endif
static NSString * token ;

-(NSString * ) getToken
{
    return token;
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
    
    NSLog(@"Did register for remote notifications: %@", devToken);
    
    
    
    
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    
    NSString *pushBadge = @"disabled";
    NSString *pushAlert = @"disabled";
    NSString *pushSound = @"disabled";
    
    
    
    if( [versioneSistema hasPrefix:@"6"] || [versioneSistema hasPrefix:@"7"])
    {
        
        NSUInteger rntypes = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        
        
        
        if(rntypes == UIRemoteNotificationTypeBadge){
            pushBadge = @"enabled";
        }
        else if(rntypes == UIRemoteNotificationTypeAlert){
            pushAlert = @"enabled";
        }
        else if(rntypes == UIRemoteNotificationTypeSound){
            pushSound = @"enabled";
        }
        else if(rntypes == ( UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert)){
            pushBadge = @"enabled";
            pushAlert = @"enabled";
        }
        else if(rntypes == ( UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)){
            pushBadge = @"enabled";
            pushSound = @"enabled";
        }
        else if(rntypes == ( UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)){
            pushAlert = @"enabled";
            pushSound = @"enabled";
        }
        else if(rntypes == ( UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)){
            pushBadge = @"enabled";
            pushAlert = @"enabled";
            pushSound = @"enabled";
        }
    }
    else
    {
        if([[UIApplication sharedApplication] isRegisteredForRemoteNotifications])
        {
            pushBadge = @"enabled";
            pushAlert = @"enabled";
            pushSound = @"enabled";
            
        }
    }
    UIDevice *dev = [UIDevice currentDevice];
    NSUUID *uuid = [[UIDevice currentDevice] identifierForVendor];
    
    
    
    NSString *deviceUuid = [uuid UUIDString];
    NSString *deviceName = dev.name;
    NSString *deviceModel = dev.model;
    NSString *deviceSystemVersion = dev.systemVersion;
    
    
    NSString *deviceToken = [[[[devToken description]
                               stringByReplacingOccurrencesOfString:@"<"withString:@""]
                              stringByReplacingOccurrencesOfString:@">" withString:@""]
                             stringByReplacingOccurrencesOfString: @" " withString: @""];
    token = deviceToken;
    NSString *host = @"app.media.inaf.it";
    
    // devel
    NSString *urlString = [@"/ios/apns-devel.php?"stringByAppendingString:@"task=register"];
    //NSString *urlString = [@"/ios/apns.php?"stringByAppendingString:@"task=register"];
    
    urlString = [urlString stringByAppendingString:@"&appname="];
    urlString = [urlString stringByAppendingString:appName];
    urlString = [urlString stringByAppendingString:@"&appversion="];
    urlString = [urlString stringByAppendingString:appVersion];
    urlString = [urlString stringByAppendingString:@"&deviceuid="];
    urlString = [urlString stringByAppendingString:deviceUuid];
    urlString = [urlString stringByAppendingString:@"&devicetoken="];
    urlString = [urlString stringByAppendingString:deviceToken];
    urlString = [urlString stringByAppendingString:@"&devicename="];
    urlString = [urlString stringByAppendingString:deviceName];
    urlString = [urlString stringByAppendingString:@"&devicemodel="];
    urlString = [urlString stringByAppendingString:deviceModel];
    urlString = [urlString stringByAppendingString:@"&deviceversion="];
    urlString = [urlString stringByAppendingString:deviceSystemVersion];
    urlString = [urlString stringByAppendingString:@"&pushbadge="];
    urlString = [urlString stringByAppendingString:pushBadge];
    urlString = [urlString stringByAppendingString:@"&pushalert="];
    urlString = [urlString stringByAppendingString:pushAlert];
    urlString = [urlString stringByAppendingString:@"&pushsound="];
    urlString = [urlString stringByAppendingString:pushSound];
    
    
    NSURL *url = [[NSURL alloc] initWithScheme:@"http" host:host path:urlString];
    NSLog(@"Register URL: %@", url);
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSLog(@"Return Data: %@", returnData);
    
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    
    NSLog(@"Fail to register for remote notifications: %@", error);
    
    
}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        [tabBarController setSelectedIndex:2];
        
        [viewTre notifica:messaggioNotifica];
        
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"ArrivataNotifica" object:messaggioNotifica];
        
    }
    
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    
    
    userINFO=userInfo;
    
    application.applicationIconBadgeNumber = 0;
    //   self.textView.text = [userInfo description];
    
    
    NSLog(@"remote notification: %@",[userInfo description]);
    NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
    
     NSString * message = [apsInfo objectForKey:@"alert"];
       NSLog(@"Received Push Alert: %@", message);
    
    
    messaggioNotifica = message;
    
    NSString *sound = [apsInfo objectForKey:@"sound"];
    NSLog(@"Received Push Sound: %@", sound);
    
    NSString *badge = [apsInfo objectForKey:@"badge"];
    NSLog(@"Received Push Badge: %@", badge);
    
    

    
    if (application.applicationState == UIApplicationStateActive) {
        
        UIAlertView *alertView;
        
        //        NSString * locale  = [[NSLocale currentLocale] localeIdentifier];
        //
        //        char a = [locale characterAtIndex:0];
        //        char b = [locale characterAtIndex:1];
        //
        //        NSLog(@"%@",locale);
        
        NSString * loc = [[NSLocale preferredLanguages] objectAtIndex:0];
        
        
        if([loc isEqualToString:@"it"])
        {
            
            alertView = [[UIAlertView alloc] initWithTitle:@"Hai Ricevuto Una Notifica"
                                                   message:[NSString stringWithFormat:@"Vuoi vedere la notifica:\n%@ ?",
                                                            message ]
                                                  delegate:self
                                         cancelButtonTitle:@"NO"
                                         otherButtonTitles:@"SI", nil];
        }
        else
        {
            alertView = [[UIAlertView alloc] initWithTitle:@"You received a notification"
                                                   message:[NSString stringWithFormat:@"Do you want to read: \n%@ ?",
                                                            message]
                                                  delegate:self
                                         cancelButtonTitle:@"NO"
                                         otherButtonTitles:@"YES", nil];
        }
        
        [alertView show];
    }
    else
    {
        
        //apri eventi

        [tabBarController setSelectedIndex:2];
        
        [viewTre notifica:messaggioNotifica];
    }
    
    
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
