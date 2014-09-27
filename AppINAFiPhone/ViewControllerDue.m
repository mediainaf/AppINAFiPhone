//
//  ViewControllerDue.m
//  INAF1
//
//  Created by Nicolo' Parmiggiani on 12/02/14.
// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "ViewControllerDue.h"
#import "News.h"
#import "NewsCell.h"
#import "DetailNewsViewController.h"
#import "Parser.h"
#import "ParserImages.h"
#import "ParserThumbnail.h"


@interface ViewControllerDue ()
{
    UIView* timeBackgroundView;
    UIRefreshControl * refreshControl;
    NSString * tag;
    NSArray * telescopes;
    NSArray * telescopesTag;
    NSArray * institutes;
    NSArray * institutesTag;
    NSArray * satellites;
    NSArray * satellitesTag;
    UIPickerView * pickerView;
    int popAperto;
    UISegmentedControl *segmentedControl;
    int pickerRowSelected;
    int segmentSelected;
    
    NSXMLParser * parser;
    
    NSMutableArray * news;
    
    int page;
    int load;
    
    NSMutableDictionary *images;
    
    NSMutableString * title, *author, * date, *summary ,*content, *link, *currentElement;

}
- (void)parseXMLFileAtURL:(NSString *)URL;
@end

@implementation ViewControllerDue



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    currentElement = [elementName copy];
    if ([elementName isEqualToString:@"item"]) {
        
        title = [[NSMutableString alloc] init];
        author = [[NSMutableString alloc] init];
        date = [[NSMutableString alloc] init];
        summary = [[NSMutableString alloc] init];
        content = [[NSMutableString alloc] init];
        link = [[NSMutableString alloc] init];
        
        // inizializza tutti gli elementi
    }
    
    
}


-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if ([currentElement isEqualToString:@"title"]){
        [title appendString:string];
    } else if ([currentElement isEqualToString:@"link"]) {
        [link appendString:string];
    } else if ([currentElement isEqualToString:@"description"]) {
        [summary appendString:string];
    } else if ([currentElement isEqualToString:@"pubDate"]) {
        [date appendString:string];
    } else if ([currentElement isEqualToString:@"content:encoded"]) {
        [content appendString:string];
    } else if ([currentElement isEqualToString:@"dc:creator"]) {
        [author appendString:string];
    }
    
    
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"item"]) {
        /* salva tutte le proprietà del feed letto nell'elemento "item", per
         poi inserirlo nell'array "elencoFeed" */
        
        
        
        dispatch_queue_t reentrantAvoidanceQueue = dispatch_queue_create("reentrantAvoidanceQueue", DISPATCH_QUEUE_SERIAL);
        dispatch_async(reentrantAvoidanceQueue, ^{
            ParserImages * parserImages = [[ParserImages alloc] init];
            NSArray * imagesAndVideo = [[NSArray alloc] init];
            imagesAndVideo = [parserImages parseText:content];
            
            [self addnews:imagesAndVideo];
        });
        dispatch_sync(reentrantAvoidanceQueue, ^{ });

        
        
       
        
       // NSString * linkThumbnail = [parserThumbnail parse:summary];
        
        // NSString * imageLinkBig = [parserThree parse:cdata];
        
        // NSLog(@"img piccola %@ ",imageLinkSmall );
        //  NSLog(@"content %@ ",content );
        
      
        
        
        //
        // NSLog(@"autore %@",imageLinkBig);
        
        
        
        
        //  news.titolo =
        
    }
    
}
-(void) addnews : (NSArray * ) imagesAndVideoArray
{
    
    NSMutableArray * imagesArray = [[NSMutableArray alloc] init];
    imagesArray = [imagesAndVideoArray objectAtIndex:0];
    NSMutableArray * videos = [[NSMutableArray alloc] init];
    videos = [imagesAndVideoArray objectAtIndex:1];
    
    NSLog(@"url %d %d titolo %@", [imagesArray count],[videos count],title );
    
    
    News * n = [[News alloc] init];
    // manca autore data link
    n.title = title;
    n.images = imagesArray;
    //n.thumbnail = linkThumbnail;
    n.videos = videos;
    // news.linkImageBig = imageLinkBig;
    n.author = author;
    n.link = link;
    
    NSArray * elementiData  = [date componentsSeparatedByString:@" "];
    
    NSString * day = [elementiData objectAtIndex:1];
    NSString * DM = [day stringByAppendingString:[NSString stringWithFormat:@" %@",[elementiData objectAtIndex:2]]];
    NSString * DMY = [DM stringByAppendingString:[NSString stringWithFormat:@" %@",[elementiData objectAtIndex:3]]];
    
    
    
    //     NSLog(@"data %@",DMY);
    
    n.date = DMY;
    
    NSArray *components = [summary componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    
    NSMutableArray *componentsToKeep = [NSMutableArray array];
    for (int i = 0; i < [components count]; i = i + 2) {
        [componentsToKeep addObject:[components objectAtIndex:i]];
    }
    
    n.summary = [componentsToKeep componentsJoinedByString:@""];
    
    
    
    components = [content componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    
    componentsToKeep = [NSMutableArray array];
    
    for (int i = 0; i < [components count]; i = i + 2) {
        [componentsToKeep addObject:[components objectAtIndex:i]];
    }
    
    
    NSMutableString * contentBeforeReplace = [[NSMutableString alloc] initWithString:[componentsToKeep componentsJoinedByString:@""]];
    [contentBeforeReplace replaceOccurrencesOfString:@"&nbsp" withString:@" " options:NSLiteralSearch range:NSMakeRange(0, [contentBeforeReplace length])];
    
    NSString * finalContent= [ NSString stringWithString:contentBeforeReplace];
    
    
    n.content = [self stringByDecodingXMLEntities:finalContent];
    
    
    [news addObject:n];
    

}

- (NSString *)stringByDecodingXMLEntities: (NSString*) string {
    
    NSUInteger myLength = [string length];
    NSUInteger ampIndex = [string rangeOfString:@"&" options:NSLiteralSearch].location;
    
    // Short-circuit if there are no ampersands.
    if (ampIndex == NSNotFound) {
        return string;
    }
    // Make result string with some extra capacity.
    NSMutableString *result = [NSMutableString stringWithCapacity:(myLength * 1.25)];
    
    // First iteration doesn't need to scan to & since we did that already, but for code simplicity's sake we'll do it again with the scanner.
    NSScanner *scanner = [NSScanner scannerWithString:string];
    
    [scanner setCharactersToBeSkipped:nil];
    
    NSCharacterSet *boundaryCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@" \t\n\r;"];
    
    do {
        // Scan up to the next entity or the end of the string.
        NSString *nonEntityString;
        if ([scanner scanUpToString:@"&" intoString:&nonEntityString]) {
            [result appendString:nonEntityString];
        }
        if ([scanner isAtEnd]) {
            goto finish;
        }
        // Scan either a HTML or numeric character entity reference.
        if ([scanner scanString:@"&amp;" intoString:NULL])
            [result appendString:@"&"];
        else if ([scanner scanString:@"&apos;" intoString:NULL])
            [result appendString:@"'"];
        else if ([scanner scanString:@"&quot;" intoString:NULL])
            [result appendString:@"\""];
        else if ([scanner scanString:@"&lt;" intoString:NULL])
            [result appendString:@"<"];
        else if ([scanner scanString:@"&gt;" intoString:NULL])
            [result appendString:@">"];
        else if ([scanner scanString:@"&#" intoString:NULL]) {
            BOOL gotNumber;
            unsigned charCode;
            NSString *xForHex = @"";
            
            // Is it hex or decimal?
            if ([scanner scanString:@"x" intoString:&xForHex]) {
                gotNumber = [scanner scanHexInt:&charCode];
            }
            else {
                gotNumber = [scanner scanInt:(int*)&charCode];
            }
            
            if (gotNumber) {
                [result appendFormat:@"%C", (unichar)charCode];
                
                [scanner scanString:@";" intoString:NULL];
            }
            else {
                NSString *unknownEntity = @"";
                
                [scanner scanUpToCharactersFromSet:boundaryCharacterSet intoString:&unknownEntity];
                
                
                [result appendFormat:@"&#%@%@", xForHex, unknownEntity];
                
                //[scanner scanUpToString:@";" intoString:&unknownEntity];
                //[result appendFormat:@"&#%@%@;", xForHex, unknownEntity];
                NSLog(@"Expected numeric character entity but got &#%@%@;", xForHex, unknownEntity);
                
            }
            
        }
        else {
            NSString *amp;
            
            [scanner scanString:@"&" intoString:&amp];  //an isolated & symbol
            [result appendString:amp];
            
            /*
             NSString *unknownEntity = @"";
             [scanner scanUpToString:@";" intoString:&unknownEntity];
             NSString *semicolon = @"";
             [scanner scanString:@";" intoString:&semicolon];
             [result appendFormat:@"%@%@", unknownEntity, semicolon];
             NSLog(@"Unsupported XML character entity %@%@", unknownEntity, semicolon);
             */
        }
        
    }
    while (![scanner isAtEnd]);
    
finish:
    return result;
}

-(void) loadData : (NSString *) url
{
    
   
    
    NSString *response = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil];
    if(!response)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Internet Connection Error" message:@"Change internet settings" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    [news removeAllObjects];
    [images removeAllObjects];
    
    parser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
    
    [parser setDelegate:self];
    
    // settiamo alcune proprietà
    [parser setShouldProcessNamespaces:NO];
    [parser  setShouldReportNamespacePrefixes:NO];
    [ parser  setShouldResolveExternalEntities:NO];
    
    // avviamo il parsing del feed RSS
    [parser parse];
    
    [self.collectionView reloadData];
    [self.loadingView setHidden:YES];
    [refreshControl endRefreshing];
}

-(void)viewDidAppear:(BOOL)animated
{
    
    if(load ==0 )
    {
        [self.loadingView setHidden:NO];
        
        load =1;
        pickerRowSelected = 0;
        segmentedControl =0;
        page = 1;
        [self loadData:@"http://www.media.inaf.it/feed/"];
        
    }
}
-(void) segmentChanged : (id) segment
{
    
    
    
    segmentSelected = segmentedControl.selectedSegmentIndex;
    [pickerView reloadAllComponents];
    [pickerView selectRow:0 inComponent:0 animated:YES];
}
-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    pickerRowSelected = row;
}
-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if([segmentedControl selectedSegmentIndex] == 0)
        return [institutes count];
    if([segmentedControl selectedSegmentIndex] == 1)
        return [telescopes count];
    if([segmentedControl selectedSegmentIndex] == 2)
        return [satellites count];
    
    return  0;
}
-(NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if([segmentedControl selectedSegmentIndex] == 0)
        return [institutes objectAtIndex:row];
    if([segmentedControl selectedSegmentIndex] == 1)
        return [telescopes objectAtIndex:row];
    if([segmentedControl selectedSegmentIndex] == 2)
        return [satellites objectAtIndex:row];
    
    return @"";
}
-(CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 300;
}
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"dismis");
     popAperto = 0;
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        NSLog(@"uno");
       
    }
    if(buttonIndex == 1)
    {
        
        NSLog(@"due");

        page=1;
        self.loadingView.hidden=NO;
        
        double delayInSeconds = 0.2;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            if([segmentedControl selectedSegmentIndex] == 0)
            {
                if(pickerRowSelected == 0)
                    [self loadData:@"http://www.media.inaf.it/feed/"];
                else
                    [self loadData:[NSString stringWithFormat:@"http://www.media.inaf.it/tag/%@/feed/",[institutesTag objectAtIndex:pickerRowSelected]]];
            }
            if([segmentedControl selectedSegmentIndex] == 1)
            {
                if(pickerRowSelected == 0)
                    [self loadData:@"http://www.media.inaf.it/feed/"];
                else
                    [self loadData:[NSString stringWithFormat:@"http://www.media.inaf.it/tag/%@/feed/",[telescopesTag objectAtIndex:pickerRowSelected]]];
            }
            if([segmentedControl selectedSegmentIndex] == 2)
            {
                if(pickerRowSelected == 0)
                    [self loadData:@"http://www.media.inaf.it/feed/"];
                else
                    [self loadData:[NSString stringWithFormat:@"http://www.media.inaf.it/tag/%@/feed/",[satellitesTag objectAtIndex:pickerRowSelected]]];
            }
            
            
        });
    }
    
}
-(void) cambiaFiltro
{
    
    [timeBackgroundView removeFromSuperview];
    popAperto =0;
    page=1;
    self.loadingView.hidden=NO;
    
    double delayInSeconds = 0.2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        if([segmentedControl selectedSegmentIndex] == 0)
        {
            if(pickerRowSelected == 0)
                [self loadData:@"http://www.media.inaf.it/feed/"];
            else
                [self loadData:[NSString stringWithFormat:@"http://www.media.inaf.it/tag/%@/feed/",[institutesTag objectAtIndex:pickerRowSelected]]];
        }
        if([segmentedControl selectedSegmentIndex] == 1)
        {
            if(pickerRowSelected == 0)
                [self loadData:@"http://www.media.inaf.it/feed/"];
            else
                [self loadData:[NSString stringWithFormat:@"http://www.media.inaf.it/tag/%@/feed/",[telescopesTag objectAtIndex:pickerRowSelected]]];
        }
        if([segmentedControl selectedSegmentIndex] == 2)
        {
            if(pickerRowSelected == 0)
                [self loadData:@"http://www.media.inaf.it/feed/"];
            else
                [self loadData:[NSString stringWithFormat:@"http://www.media.inaf.it/tag/%@/feed/",[satellitesTag objectAtIndex:pickerRowSelected]]];
        }
        
        
    });
}
-(void) cancelFiltri
{
    [timeBackgroundView removeFromSuperview];
    popAperto =0;
}
-(void) apriFiltri
{
    if(popAperto == 1)
    {
        NSLog(@"chiudi");
        //popAperto =0;
        [self cancelFiltri];
        //[timeBackgroundView removeFromSuperview];
    }
    else if(popAperto == 0)
    {
        
        popAperto = 1;
        [self.view addSubview:timeBackgroundView];


//        timeBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-350, 320, 350)];
//       
//        
//        [timeBackgroundView setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0]];
//        
//        
//        UIButton * cancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        
//        [cancel setTitle:@"Cancel" forState:UIControlStateNormal];
//        cancel.titleLabel.font = [UIFont systemFontOfSize:18.0];
//        cancel.titleLabel.textColor = [UIColor redColor];
//
//    
//        [cancel addTarget:self action:@selector(cancelFiltri) forControlEvents:UIControlEventTouchUpInside];
//        
//        [cancel setFrame:CGRectMake(130, 3, 60, 40)];
//        
//        [timeBackgroundView addSubview:cancel];
//        
//        UIButton * filtra = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        
//        [filtra setTitle:@"Filtra" forState:UIControlStateNormal];
//        filtra.titleLabel.font = [UIFont systemFontOfSize:18.0];
//        filtra.titleLabel.textColor = [UIColor redColor];
//        
//        
//        [filtra addTarget:self action:@selector(cambiaFiltro) forControlEvents:UIControlEventTouchUpInside];
//        
//        [filtra setFrame:CGRectMake(130, 46, 60, 40)];
//        
//        [timeBackgroundView addSubview:filtra];
//
//        
//        
//        segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Sedi",@"Terra",@"Spazio", nil]];
//        
//        segmentedControl.frame = CGRectMake(10, 100, 300, 30);
//        
//        
//        
//    
//            pickerView=[[UIPickerView alloc]initWithFrame:CGRectMake(0,140, 0, 0)];
//    
//            pickerView.delegate=self;
//            pickerView.showsSelectionIndicator=YES;
//    
//            UIDevice *device = [UIDevice currentDevice];
//    
//    
//            if([device.systemVersion hasPrefix:@"6"])
//            {
//                segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
//            }
//            else
//            {
//                segmentedControl.tintColor = [UIColor blackColor];
//            }
//    
//    
//    
//            [segmentedControl addTarget:self action:@selector(segmentChanged:) forControlEvents: UIControlEventValueChanged];
//            segmentedControl.selectedSegmentIndex = segmentSelected;
//            [pickerView selectRow:pickerRowSelected inComponent:0 animated:YES];
//            
//
//        
//        [timeBackgroundView addSubview:segmentedControl];
//        [timeBackgroundView addSubview:pickerView];
        //           [self.view addSubview:timeBackgroundView];

        
//        popAperto = 1;
//        
//        UIActionSheet*  actionSheet =[[UIActionSheet alloc] initWithTitle:@"Seleziona filtro" delegate:self cancelButtonTitle:@"Filtra" destructiveButtonTitle:@"Annulla" otherButtonTitles: nil ];
//        
//        segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Sedi",@"Terra",@"Spazio", nil]];
//        
//        segmentedControl.frame = CGRectMake(10, 165, 300, 30);
//        
//        [actionSheet addSubview:segmentedControl];
//
//        
//        pickerView=[[UIPickerView alloc]initWithFrame:CGRectMake(0,204, 0, 0)];
//        
//        pickerView.delegate=self;
//        pickerView.showsSelectionIndicator=YES;
//        
//        UIDevice *device = [UIDevice currentDevice];
//        
//        
//        if([device.systemVersion hasPrefix:@"6"])
//        {
//            segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
//        }
//        else
//        {
//            segmentedControl.tintColor = [UIColor blackColor];
//        }
//        
//        
//        
//        [segmentedControl addTarget:self action:@selector(segmentChanged:) forControlEvents: UIControlEventValueChanged];
//        segmentedControl.selectedSegmentIndex = segmentSelected;
//        [pickerView selectRow:pickerRowSelected inComponent:0 animated:YES];
//        
//        [actionSheet addSubview:pickerView];
//        
//        [actionSheet showFromTabBar:self.tabBarController.tabBar ];
//        
//        [actionSheet setBounds:CGRectMake(0, 0, 320, 700)];
    }
    
    /*
    if(!popOverController.popoverVisible)
    {
        NSLog(@"apri pop");
        popAperto=1;
        pickerView=[[UIPickerView alloc]init];
        
        toolBar = [[UIToolbar alloc] init];
        
        UIViewController * popOverContent = [[UIViewController alloc] init];
        UIView * popOverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 ,446 , 300)];
        
        
        segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Sedi",@"Progetti da Terra",@"Progetti Spaziali", nil]];
        
        segmentedControl.frame = CGRectMake(41, 68, 364, 30);
        
        
        UIDevice *device = [UIDevice currentDevice];
        
        
        if([device.systemVersion hasPrefix:@"6"])
        {
            segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
        }
        else
        {
            segmentedControl.tintColor = [UIColor blackColor];
        }
        
        
        
        [segmentedControl addTarget:self action:@selector(segmentChanged:) forControlEvents: UIControlEventValueChanged];
        segmentedControl.selectedSegmentIndex = segmentSelected;
        [popOverView addSubview:segmentedControl];
        
        pickerView=[[UIPickerView alloc]initWithFrame:CGRectMake(0,104, 446, 216)];
        pickerView.delegate=self;
        pickerView.dataSource=self;
        pickerView.showsSelectionIndicator=YES;
        [pickerView selectRow:pickerRowSelected inComponent:0 animated:YES];
        [popOverView addSubview:pickerView];
        
        toolBar =[[UIToolbar alloc] initWithFrame:CGRectMake([popOverView frame].origin.x, [popOverView frame].origin.y, [popOverView frame].size.width, 44)];
        
        UIBarButtonItem * flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem * done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(chiudiPop)];
        
        if([[UIDevice currentDevice].systemVersion hasPrefix:@"7"])
        {
            toolBar.tintColor=[UIColor blackColor];
        }
        else
        {
            segmentedControl.frame = CGRectMake(41, 58, 364, 30);
            
            done.tintColor = [UIColor blackColor];
        }
        
        
        [toolBar setItems:[NSArray arrayWithObjects:flexSpace,done, nil]];
        
        [popOverView addSubview:toolBar];
        [popOverContent setView:popOverView];
        
        popOverController = [[UIPopoverController alloc] initWithContentViewController:popOverContent];
        popOverController.popoverContentSize = CGSizeMake(446,300);
        popOverController.delegate=self;
        
        [popOverController presentPopoverFromBarButtonItem:self.navigationItem.leftBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
    else
    {
        
    }
    */
}
-(void) chiudiPop
{
    /*
    [popOverController dismissPopoverAnimated:YES];
    
    [self.loadingView setHidden:NO];
    
    
    page=1;
    
    double delayInSeconds = 0.2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        if([segmentedControl selectedSegmentIndex] == 0)
        {
            if(pickerRowSelected == 0)
                [self loadData:@"http://www.media.inaf.it/feed/"];
            else
                [self loadData:[NSString stringWithFormat:@"http://www.media.inaf.it/tag/%@/feed/",[institutesTag objectAtIndex:pickerRowSelected]]];
        }
        if([segmentedControl selectedSegmentIndex] == 1)
        {
            if(pickerRowSelected == 0)
                [self loadData:@"http://www.media.inaf.it/feed/"];
            else
                [self loadData:[NSString stringWithFormat:@"http://www.media.inaf.it/tag/%@/feed/",[telescopesTag objectAtIndex:pickerRowSelected]]];
        }
        if([segmentedControl selectedSegmentIndex] == 2)
        {
            if(pickerRowSelected == 0)
                [self loadData:@"http://www.media.inaf.it/feed/"];
            else
                [self loadData:[NSString stringWithFormat:@"http://www.media.inaf.it/tag/%@/feed/",[satellitesTag objectAtIndex:pickerRowSelected]]];
        }
        
        
    });
    */
    
    
    
}
-(void) reloadData : (id) selector
{
    
    [self.loadingView setHidden:NO];
    
    load =1;
    pickerRowSelected = 0;
    segmentedControl =0;
    page = 1;
    
    
    [self loadData:@"http://www.media.inaf.it/feed/"];
    
    
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    
    if ([scrollView contentOffset].y >= self.collectionView.contentSize.height-self.view.frame.size.height){
        
        
        NSLog(@"reload");
        
        
        [self.loadingView setHidden:NO];
        
        [self performSelector:@selector(changePage) withObject:nil afterDelay:0.5];
        
        
        
    }
    
}
-(void) changePage
{
    page++;
    
    NSLog(@"page %d",page);
    title = [[NSMutableString alloc] init];
    author = [[NSMutableString alloc] init];
    date = [[NSMutableString alloc] init];
    summary = [[NSMutableString alloc] init];
    content = [[NSMutableString alloc] init];
    link = [[NSMutableString alloc] init];
    
    if([segmentedControl selectedSegmentIndex] == 0)
    {
        if(pickerRowSelected == 0)
            
            parser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://www.media.inaf.it/feed/?paged=%d",page]]];
        
        else
            parser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.media.inaf.it/tag/%@/feed/?paged=%d",[institutesTag objectAtIndex:pickerRowSelected],page]]];
        
        
    }
    if([segmentedControl selectedSegmentIndex] == 1)
    {
        if(pickerRowSelected == 0)
            parser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://www.media.inaf.it/feed/?paged=%d",page]]];
        
        
        else
            parser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.media.inaf.it/tag/%@/feed/?paged=%d",[telescopesTag objectAtIndex:pickerRowSelected],page]]];
        
        
    }
    if([segmentedControl selectedSegmentIndex] == 2)
    {
        if(pickerRowSelected == 0)
            parser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://www.media.inaf.it/feed/?paged=%d",page]]];
        
        else
            parser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.media.inaf.it/tag/%@/feed/?paged=%d",[satellitesTag objectAtIndex:pickerRowSelected],page]]];
        
        
    }
    
    [parser setDelegate:self];
    
    // settiamo alcune proprietà
    [parser setShouldProcessNamespaces:NO];
    [parser  setShouldReportNamespacePrefixes:NO];
    [ parser  setShouldResolveExternalEntities:NO];
    
    // avviamo il parsing del feed RSS
    [parser parse];
    
    [self.collectionView reloadData];
    
    [self.loadingView setHidden:YES];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    
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
    load = NO;
    
    news = [[NSMutableArray alloc] init];
    images = [[NSMutableDictionary alloc] init];

    [self.collectionView setContentOffset:CGPointMake(0, -refreshControl.frame.size.height) animated:YES];
    [refreshControl beginRefreshing];

    
//    UIBarButtonItem * refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(loadData) ];
    
  //  self.navigationItem.rightBarButtonItem= refresh ;
    
    [self.collectionView registerClass:[NewsCell class] forCellWithReuseIdentifier:@"cvCell"];

    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(300, 440)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setMinimumLineSpacing:10];
    [flowLayout setSectionInset:UIEdgeInsetsMake(10,10, 10, 10)];
    // [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    [self.collectionView setCollectionViewLayout:flowLayout];

   // [self.tableView setFrame:CGRectMake(0, 44, 320, 387)];
   // if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
     //   self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    
    telescopes = [NSArray arrayWithObjects:
                  @"Tutte le news",
                  @"Antenna di Medicina (BO)",
                  @"Antenna di Noto (SR)",
                  @"Croce del Nord (Medicina - BO)",
                  @"Large Binocular Telescope",
                  @"Magic",
                  @"Rapid Eye Mount",
                  @"Sardinia Radio Telescope",
                  @"Telescopio Nazionale Galileo",
                  @"VLT Survey Telescope",
                  nil];
    
    // 42
    satellites = [NSArray arrayWithObjects:
                  @"Tutte le news",
                  @"AGILE",
                  @"BepiColombo",
                  @"Boomerang-B2k",
                  @"Cassini-Huygens",
                  @"Chandra",
                  @"CHEOPS",
                  @"CLUSTER",
                  @"CoRoT",
                  @"DAWN",
                  @"EChO",
                  @"EJSM-Laplace/JUICE",
                  @"ExoMars",
                  @"EUCLID",
                  @"Fermi",
                  @"GAIA",
                  @"GReAT",
                  @"Herschel",
                  @"Hinode",
                  @"INTEGRAL",
                  @"James Webb Space Telescope",
                  @"JEM-EUSO",
                  @"LISA/New Gravitational wave Obse",
                  @"LISA-Pathfinder",
                  @"LOFT",
                  @"MarcoPolo-R",
                  @"Mars Express",
                  @"Mars Reconnaissance Orbiter",
                  @"MIRAX",
                  @"Olimpo",
                  @"Phobos-Soil",
                  @"Planck",
                  @"PLATO",
                  @"Proba-3",
                  @"Rosetta",
                  @"SCORE",
                  @"SOHO",
                  @"Solar Orbiter",
                  @"SPICA",
                  @"STEREO",
                  @"Swift",
                  @"Venus Express",
                  @"XMM-Newton",
                  
                  
                  nil];
    
    institutes = [NSArray arrayWithObjects:
                  @"Tutte le news",
                  @"IASF Bologna",
                  @"IAPS Roma",
                  @"IASF Milano",
                  @"IASF Palermo",
                  @"IRA Bologna",
                  @"Osservatorio di Arcetri (FI)",
                  @"Osservatorio di Bologna",
                  @"Osservatorio di Brera",
                  @"Osservatorio di Cagliari",
                  @"Osservatorio di Capodimonte (NA)",
                  @"Osservatorio di Catania",
                  @"Osservatorio di Padova",
                  @"Osservatorio di Palermo",
                  @"Osservatorio di Roma",
                  @"Osservatorio di Teramo",
                  @"Osservatorio di Torino",
                  @"Osservatorio di Trieste", nil];
    
    //,@"IASF Bologna",@"Osservatorio di Arcetri (FI)",@"Osservatorio di Teramo",@"Osservatorio di Roma",@"IAPS Roma",@"Osservatorio di Capodimonte (NA)",@"Osservatorio di Cagliari",@"Osservatorio di Palermo",@"IASF Palermo",@"Osservatorio di Catania"
    
    institutesTag = [NSArray arrayWithObjects:@"",
                     @"iasf_bologna",
                     @"iaps_roma",
                     @"iasf_milano",
                     @"iasf_palermo",
                     @"ira_bologna",
                     @"oa_arcetri",
                     @"oa_bologna",
                     @"oa_brera",
                     @"oa_cagliari",
                     @"oa_napoli",
                     @"oa_catania",
                     @"oa_padova",
                     @"oa_palermo",
                     @"oa_roma",
                     @"oa_teramo",
                     @"oa_torino",
                     @"oa_trieste",
                     nil];
    
    satellitesTag = [NSArray arrayWithObjects:@"",
                     @"agile",
                     @"bepicolombo",
                     @"boomerang",
                     @"cassini",
                     @"chandra",
                     @"cheops",
                     @"cluster",
                     @"corot",
                     @"dawn",
                     @"echo",
                     @"juice",
                     @"exomars",
                     @"euclid",
                     @"fermi",
                     @"gaia",
                     @"great",
                     @"herschel",
                     @"hinode",
                     @"integral",
                     @"jwst",
                     @"jem-euso",
                     @"lisa",
                     @"lisa-pathfinder",
                     @"loft",
                     @"marcopolo-r",
                     @"mars-express",
                     @"Reconnaissance Orbiter mars-orbiter",
                     @"mirax",
                     @"olimpo",
                     @"phobos-soil",
                     @"planck",
                     @"plato",
                     @"proba-3",
                     @"rosetta",
                     @"score",
                     @"soho",
                     @"solar-orbiter",
                     @"spica",
                     @"stereo",
                     @"swift",
                     @"venus-express",
                     @"xmm",
                     nil];
    telescopesTag = [NSArray arrayWithObjects:@"",
                     @"medicina",
                     @"noto",
                     @"croce-del-nord",
                     @"lbt",
                     @"magic",
                     @"rem",
                     @"srt",
                     @"tng_canarie",
                     @"vst",
                     nil];
    
    
    timeBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-350, 320, 350)];
    
    
    [timeBackgroundView setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0]];
    
    
    UIButton * cancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [cancel setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
      cancel.titleLabel.font = [UIFont systemFontOfSize:18.0];
    //cancel.titleLabel.text=@"Cancel";
    
    [cancel addTarget:self action:@selector(cancelFiltri) forControlEvents:UIControlEventTouchUpInside];
    
    [cancel setFrame:CGRectMake(130, 3, 60, 40)];
    
    [timeBackgroundView addSubview:cancel];
    
    UIButton * filtra = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [filtra setTitle:@"Filtra" forState:UIControlStateNormal];
    filtra.titleLabel.font = [UIFont systemFontOfSize:18.0];

    
    
    [filtra addTarget:self action:@selector(cambiaFiltro) forControlEvents:UIControlEventTouchUpInside];
    
    [filtra setFrame:CGRectMake(130, 46, 60, 40)];
    
    [timeBackgroundView addSubview:filtra];
    
    
    
    segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Sedi",@"Terra",@"Spazio", nil]];
    
    segmentedControl.frame = CGRectMake(10, 100, 300, 30);
    
    
    
    
    pickerView=[[UIPickerView alloc]initWithFrame:CGRectMake(0,140, 0, 0)];
    
    pickerView.delegate=self;
    pickerView.showsSelectionIndicator=YES;
    
    UIDevice *device = [UIDevice currentDevice];
    
    
    if([device.systemVersion hasPrefix:@"6"])
    {
        segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    }
    else
    {
        segmentedControl.tintColor = [UIColor blackColor];
    }
    
    
    
    [segmentedControl addTarget:self action:@selector(segmentChanged:) forControlEvents: UIControlEventValueChanged];
    segmentedControl.selectedSegmentIndex = segmentSelected;
    [pickerView selectRow:pickerRowSelected inComponent:0 animated:YES];
    
    
    
    [timeBackgroundView addSubview:segmentedControl];
    [timeBackgroundView addSubview:pickerView];

    NSLog(@"%f",self.view.frame.size.height);
    
    UIImage * iconaFiltri = [UIImage imageNamed:@"Assets/iconaFiltri.png"];
    
    
    UIButton * bottone = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [bottone addTarget:self action:@selector(apriFiltri) forControlEvents:UIControlEventTouchUpInside];
    
    [bottone setImage:iconaFiltri forState:UIControlStateNormal];
    
    
    [bottone setTitle:@" Cerca" forState:UIControlStateNormal];
    
    
    
    if([device.systemVersion hasPrefix:@"6"])
    {
        [bottone setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [bottone setTintColor:[UIColor blackColor]];
    }
    
    [bottone setFrame:CGRectMake(0, 2, 80, 30)];
    
    UIBarButtonItem * buttonBar = [[UIBarButtonItem alloc] initWithCustomView:bottone];
    
    self.navigationItem.leftBarButtonItem=buttonBar;
    
    self.loadingView.image = [UIImage imageNamed:@"Assets/loadingNews.png"];
    self.title = @"News";
    
    self.background.image = [UIImage imageNamed:@"Assets/galileo3.jpg"];
    self.background.alpha = 0.6;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if([news count]>0)
        return  [news count];
    
    return 6 ;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cvCell";
    
    NewsCell *cell = (NewsCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor=[UIColor colorWithWhite:0.9 alpha:0.7];
    
    if([news count]>0)
    {
        
        
        
        
        News * n  = [news objectAtIndex:indexPath.row];
        
        cell.title.textColor=[UIColor blackColor];
        cell.title.text = n.title;
        //sNSLog(@"%lu",(unsigned long)[notizie count]);
        cell.date.text = n.date;
        cell.summary.text = n.summary;
        cell.textLabel.text=n.summary;
        cell.author.text = [NSString stringWithFormat:@"di %@",n.author];
        // [cell.immaginePreview loadImageAtURL:[NSURL URLWithString:[[notizie objectAtIndex:indexPath.row] linkImageSmall]]];
        
        NSString *identifier = [NSString stringWithFormat:@"Cell%ld" ,
                                (long)indexPath.row];
        
        
        if([images objectForKey:identifier] != nil)
        {
            cell.thumbnail.image = [images valueForKey:identifier];
            [cell.indicator stopAnimating];        }
        else
        {
            cell.thumbnail.image = nil;
            [cell.indicator startAnimating];
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,  0ul);
            dispatch_async(queue, ^{
                //This is what you will load lazily
                
                
                if([n.images count]>0)
                {
                    // 354*201
                    
                    NSString * imageUrl =  [n.images objectAtIndex:0] ;
                    
                    NSArray * elements = [ imageUrl componentsSeparatedByString:@"/"];
                    
                    int number = [elements count];
                    
                    NSString * url = [NSString stringWithFormat:@"http://app.media.inaf.it/GetMediaImage.php?sourceYear=%@&sourceMonth=%@&sourceName=%@&width=300&height=149",[elements objectAtIndex:number-3],[elements objectAtIndex:number-2],[elements objectAtIndex:number-1]];
                    
                    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
                    
                    NSData * response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
                    
                    if(response != nil)
                    {
                        
                        NSError * jsonParsingError = nil;
                        
                        NSDictionary * jsonElement = [NSJSONSerialization JSONObjectWithData:response options:0 error:&jsonParsingError];
                        
                        NSDictionary * json = [jsonElement objectForKey:@"response"];
                        
                        NSString * urlImage = [json objectForKey:@"urlResizedImage"];
                        
                        NSData * dataImmagine = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlImage]];
                        
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            
                            //  NSLog(@"%@",[n.images objectAtIndex:0]);
                            
                            
                            
                            UIImage * image = [UIImage imageWithData:dataImmagine];
                            if(image)
                                [images setObject:image forKey:identifier];
                            //cell.thumbnail.image = image;
                            [cell setNeedsLayout];
                            if(indexPath.row  < [news count])
                            {
                                
                                [UIView setAnimationsEnabled:NO];
                                
                                [self.collectionView performBatchUpdates:^{
                                    [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
                                    [cell.indicator stopAnimating];
                                } completion:^(BOOL finished) {
                                    [UIView setAnimationsEnabled:YES];
                                }];
                            }
                            
                        });
                        
                    }
                    else
                    {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            
                            UIImage * image = [UIImage imageNamed:@"Assets/newsDefault.png"];
                            if(image)
                                [images setObject:image forKey:identifier];
                            //cell.thumbnail.image = image;
                            [cell setNeedsLayout];
                            if(indexPath.row  < [news count])
                            {
                                
                                [UIView setAnimationsEnabled:NO];
                                
                                [self.collectionView performBatchUpdates:^{
                                    [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
                                    [cell.indicator stopAnimating];
                                } completion:^(BOOL finished) {
                                    [UIView setAnimationsEnabled:YES];
                                }];
                            }
                            
                        });
                        
                        
                    }
                }
                else
                {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        
                        UIImage * image = [UIImage imageNamed:@"Assets/newsDefault.png"];
                        if(image)
                            [images setObject:image forKey:identifier];
                        //cell.thumbnail.image = image;
                        [cell setNeedsLayout];
                        [UIView setAnimationsEnabled:NO];
                        
                        [self.collectionView performBatchUpdates:^{
                            [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
                            [cell.indicator stopAnimating];
                        } completion:^(BOOL finished) {
                            [UIView setAnimationsEnabled:YES];
                        }];
                        
                    });
                    
                }
                
                
            });
        }
        
    }
    
    //[titleLabel setText:cellData];
    
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"deselect");
    
    if([news count]>0)
    {
    
        NSString *identifier = [NSString stringWithFormat:@"Cell%ld" ,
                                (long)indexPath.row];
        
       
        DetailNewsViewController * d = [[DetailNewsViewController alloc] initWithNibName:@"DetailNewsViewController" bundle:nil];
        
        d.news = [news objectAtIndex:indexPath.row];
        
        [self.navigationController pushViewController:d animated:YES];
        
     
    }
    [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






@end
