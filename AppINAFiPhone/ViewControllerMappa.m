//
//  ViewControllerMappa.m
//  INAF1
//
//  Created by Nicolo' Parmiggiani on 14/02/14.
// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "ViewControllerMappa.h"
#import "Annotation.h"
#import "Istituto.h"
#import "InternetNewsViewController.h"
#import "DetailMapViewController.h"

#import "ViewControllerAnnotation.h"



@interface ViewControllerMappa ()
{
    UIButton *button;
    int load;
    NSMutableArray * istituti;
    int cont;
    NSMutableArray * annotations;
    CLLocationCoordinate2D  location;
    int Tag;
    ViewControllerAnnotation * va;
}

@end

@implementation ViewControllerMappa
- (CLLocationCoordinate2D) geoCodeUsingAddress:(NSString *)address
{
    NSString *esc_addr =  [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=true&address=%@", esc_addr];
    CLLocationCoordinate2D center;
    
    
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result)
    {
        //NSLog(@"LOC RESULT: %@", result);
        NSError *e;
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData: [result dataUsingEncoding:NSUTF8StringEncoding]
                                                                   options: NSJSONReadingMutableContainers
                                                                     error: &e];
        NSArray *resultsArray = [resultDict objectForKey:@"results"];
        
        if(resultsArray.count > 0)
        {
            resultDict = [[resultsArray objectAtIndex:0] objectForKey:@"geometry"];
            resultDict = [resultDict objectForKey:@"location"];
            center.latitude = [[resultDict objectForKey:@"lat"] floatValue];
            center.longitude = [[resultDict objectForKey:@"lng"] floatValue];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Results Found" message:@"No locations were found using, please try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        }
        
        //goes through each result
        /*for(NSDictionary *dict in resultsArray)
         {
         resultDict = [dict objectForKey:@"geometry"];
         resultDict = [resultDict objectForKey:@"location"];
         }*/
    }
    return center;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void) Call
{
    UIDevice * device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        
        
        Istituto * istituto = [istituti objectAtIndex:Tag];
        
        
        NSString *phoneNumber = [@"telprompt://" stringByAppendingString:[NSString stringWithFormat:@"%@",istituto.phone]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
        
        
        NSLog(@"%d",Tag);
        
    } else {
        
        UIAlertView *warning =[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [warning show];
    }
    
    
    

   }
-(void) Navigate
{
    
    MKPlacemark* place = [[MKPlacemark alloc] initWithCoordinate: location addressDictionary: nil];
    MKMapItem* destination = [[MKMapItem alloc] initWithPlacemark: place];
    destination.name = @"Name Here!";
    NSArray* items = [[NSArray alloc] initWithObjects: destination, nil];
    NSDictionary* options = [[NSDictionary alloc] initWithObjectsAndKeys:
                             MKLaunchOptionsDirectionsModeDriving,
                             MKLaunchOptionsDirectionsModeKey, nil];
    [MKMapItem openMapsWithItems: items launchOptions: options];
    
    NSLog(@"navigate");

}
-(void) OpenLink
{
    InternetNewsViewController * internet = [[InternetNewsViewController alloc] initWithNibName:@"InternetNewsViewController" bundle:nil];
    
    Istituto * istituto = [istituti objectAtIndex:Tag];
    
    internet.link = istituto.website;
    
    [self.navigationController pushViewController:internet animated:YES];
    
    NSLog(@"link");

    
}
-(void) Detail
{
    DetailMapViewController * detail = [[DetailMapViewController alloc] initWithNibName:@"DetailMapViewController" bundle:nil];

     Istituto * istituto = [istituti objectAtIndex:Tag];
    
    detail.nameS=istituto.name;
    detail.phoneS=istituto.phone;
    detail.webpageS=istituto.website;
    //detail.descrS=istituto.descr;
    detail.addressS=istituto.address;
    
    NSLog(@"%@",istituto.descr);
    
    [self.navigationController pushViewController:detail animated:YES];


}
- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    [self Detail];
                    break;
                case 1:
                    [self OpenLink];
                    break;
                case 2:
                    [self Call];
                    break;
                case 3:
                    [self Navigate];
                    break;
                
            }
            break;
        }
        default:
            break;
    }
}

-(void) apriEvento : (id) sender
{
    
   
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select Sharing option:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Detail",
                            @"Open Link",
                            @"Call Phone Number",
                            @"Show In Navigator",
                            
                            nil];
    popup.tag = 1;
    [popup showInView:[UIApplication sharedApplication].keyWindow];
    
    /*
    
    
    MKPlacemark* place = [[MKPlacemark alloc] initWithCoordinate: location addressDictionary: nil];
    MKMapItem* destination = [[MKMapItem alloc] initWithPlacemark: place];
    destination.name = @"Name Here!";
    NSArray* items = [[NSArray alloc] initWithObjects: destination, nil];
    NSDictionary* options = [[NSDictionary alloc] initWithObjectsAndKeys:
                             MKLaunchOptionsDirectionsModeDriving,
                             MKLaunchOptionsDirectionsModeKey, nil];
    [MKMapItem openMapsWithItems: items launchOptions: options];
    
     */
    
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    //7
    else
    {
        Annotation * an = annotation;
        
 
        
        MKPinAnnotationView* customPinView = [[MKPinAnnotationView alloc]
                                              initWithAnnotation:annotation reuseIdentifier:@"current"];
        cont++;
        //customPinView.pinColor = MKPinAnnotationColorPurple;
        customPinView.animatesDrop = YES;
        customPinView.highlighted=YES;
        customPinView.draggable=YES;
        customPinView.tag=an.tag;
        
        return customPinView;
    }
    
    
    
}

    

//11
-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSLog(@"tap");
}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
    
    if(![view.annotation isKindOfClass:[MKUserLocation class]]) {
        self.navigationItem.rightBarButtonItem.enabled=YES;
        NSLog(@"%d",view.tag);
        Tag=view.tag;
        
        Annotation * v = (Annotation *)view;
        
        
    
        CLLocationCoordinate2D cord ;
        cord.latitude=v.coordinate.latitude;
        cord.longitude=v.coordinate.longitude;
        
        MKCoordinateRegion region;
        MKCoordinateSpan span;
        span.latitudeDelta = 1;
        span.longitudeDelta = 1;
        region.span = span;
        region.center = cord;
        
        [self.mapView setRegion:region animated:TRUE];
        [self.mapView regionThatFits:region];
        
         va = [[ViewControllerAnnotation alloc] initWithNibName:@"ViewControllerAnnotation" bundle:nil];
        
        //SMCalloutView *calloutView = (SMCalloutView *)[[[NSBundle mainBundle] loadNibNamed:@"CalloutView" owner:self options:nil] objectAtIndex:0];
        
        CGRect calloutViewFrame = va.view.frame;
        
        calloutViewFrame.origin = CGPointMake(-calloutViewFrame.size.width/2 +8, -calloutViewFrame.size.height-10);
        
        va.view.frame = calloutViewFrame;
        
        va.view.layer.cornerRadius = 5;
        va.view.layer.masksToBounds = YES;
            
        
               Istituto * i = [istituti objectAtIndex:Tag];
        
        [va.nome setText:i.name];
        [va.phone setText:i.phone];
        [va.link setText:i.website];
        [va.address setText:i.address];
        
        
       [view addSubview:va.view];
    

   
    }
    
}
//12

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    for (UIView *subview in view.subviews ){
        self.navigationItem.rightBarButtonItem.enabled=NO;
        [subview removeFromSuperview];
    }
}
    

- (void)viewDidLoad
{
    
    
    UIBarButtonItem * refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(apriEvento:) ];
    
    self.navigationItem.rightBarButtonItem= refresh ;
    self.navigationItem.rightBarButtonItem.enabled=NO;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(apriEvento:) name:@"InfoAnnotation" object:nil];
    
    self.title=@"Mappa";
    self.navigationController.navigationBar.tintColor=[UIColor blackColor];
    
    istituti = [[NSMutableArray alloc]init];
    
    load = 0;
    
}

-(void)viewDidAppear:(BOOL)animated
{
    if(load == 0)
    {
        load=1;
        
        NSString * url = [NSString stringWithFormat: @"http://app.media.inaf.it/GetLocations.php"];
        
        NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        
        NSData * response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        
        NSLog(@"%@",url);
        
        NSArray *jsonArray ;
        if (response) {
            
            NSError *e = nil;
            jsonArray = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error: &e];
            
        }
        
        for(NSDictionary * d in jsonArray)
        {
            
            NSString *ID = [d valueForKey:@"id"];
            NSString *name = [d valueForKey:@"name"];
            NSString *descr = [d valueForKey:@"descr"];
            NSString *website = [d valueForKey:@"website"];
            NSString *address = [d valueForKey:@"address"];
            NSString *phone = [d valueForKey:@"phone"];
            NSString *coord = [d valueForKey:@"coordinates"];
            
            Istituto * i = [[Istituto alloc]init];
            
            i.ID=ID;
            i.name=name;
            i.descr=descr;
            i.address=address;
            i.website=website;
            i.phone=phone;
            
            NSArray * elementi = [coord componentsSeparatedByString:@","];
            
           
            
            CLLocationCoordinate2D coordinate;
            coordinate.latitude = [[elementi objectAtIndex:1] floatValue];
            coordinate.longitude = [[elementi objectAtIndex:0] floatValue];
            
            i.coord = coordinate;
            
            NSLog(@"%f %f",coordinate.longitude,i.coord.longitude);

            [istituti addObject:i];
        }
        
        
        
        
        
        
        MKUserLocation * userlocation = self.mapView.userLocation;
        self.mapView.showsUserLocation=YES;
        CLLocationCoordinate2D latlong = [self geoCodeUsingAddress:@"Viale del Parco Mellini 84, Roma"];
        
        
        location = latlong;
        
        /*if (!userlocation.location) {
         
         NSLog(@"allerta");
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Localizzazione Disabilitata"
         message:@"Andare nelle impostazioni ed abilitare il servizio"
         delegate:nil
         cancelButtonTitle:@"OK"
         otherButtonTitles:nil];
         
         [alert show];
         
         }
         else */
        {
            NSLog(@"apri mappa %d",self.mapView.hidden);
            [self.mapView removeAnnotations:annotations];
            [annotations removeAllObjects];
            
            cont=-1;
            /*
             MKCoordinateRegion region;
             region.center = self.mapView.userLocation.coordinate;
             NSLog(@"%f",region.center.latitude);
             
             NSString * risposta = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://app.media.inaf.it/locations"] encoding:NSUTF8StringEncoding error:nil];
             
             NSLog(@"%@",risposta);
             
             region.span = MKCoordinateSpanMake(0.5, 0.5);
             region = [self.mapView regionThatFits:region];
             [self.mapView setRegion:region animated:YES];
             */
            
            int j = -1;
            
            for(Istituto * i in istituti)
            {
                j++;
            
                annotations = [[NSMutableArray alloc] init];
                
                Annotation * newAnnotation = [[Annotation alloc] init];
                
                newAnnotation.coordinate= i.coord;
                
                NSLog(@"%f %f",i.coord.latitude,i.coord.longitude);
                
                //newAnnotation.subtitle=i.descr;
                newAnnotation.title =i.name;
                
                newAnnotation.link =i.website;
                newAnnotation.tag=j;
                // NSLog(@"%f %f",ev.center.latitude,ev.center.longitude);
                
                [annotations addObject:newAnnotation];
                
                
                [self.mapView addAnnotations:annotations];
            }
        }
        
        
    }
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
