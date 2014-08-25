//
//  ViewControllerTre.m
//  INAF1
//
//  Created by Nicolo' Parmiggiani on 12/02/14.
// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "ViewControllerTre.h"
#import "NewsCell.h"
#import "DetailEventsViewController.h"


#import "Parser.h"



@interface ViewControllerTre ()
{
    NSXMLParser * parser;
    
    int load;
    
    NSMutableArray * news;
    
    NSMutableDictionary *images;
    
    NSMutableArray * contentArray;
    
    NSMutableString * title, *author, * date, *summary ,*content, *link, *currentElement;}
- (void)parseXMLFileAtURL:(NSString *)URL;

@end

@implementation ViewControllerTre

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
    // NSLog(@"%@",elementName);
    
    
    
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
        
        
        Parser * parserImages = [[Parser alloc] init];
               // NSString * imageLinkBig = [parserThree parse:cdata];
        
        // NSLog(@"img piccola %@ ",imageLinkSmall );
        // NSLog(@"img grande %@ ",imageLinkBig );
        
        NSMutableArray * imagesArray = [[NSMutableArray alloc] init];
        imagesArray = [parserImages parseText:content];
        
        NSLog(@" titolo %@",title);
        
        News * n = [[News alloc] init];
        // manca autore data link
        n.title = title;
        n.images = imagesArray;
        
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
        
        
        NSArray * elements = [ content componentsSeparatedByString:@"</b></p>"];
        
        NSString * contentTwo = [elements objectAtIndex:1];
        
        components = [contentTwo componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
        
        componentsToKeep = [NSMutableArray array];
        
        for (int i = 0; i < [components count]; i = i + 2) {
            [componentsToKeep addObject:[components objectAtIndex:i]];
        }
        
        n.content = [componentsToKeep componentsJoinedByString:@""];
        
        [news addObject:n];
        
        
        
        //
        // NSLog(@"autore %@",imageLinkBig);
        
        
        
        
        //  news.titolo =
        
    }
    
}

-(void) loadData
{
    
    NSString * url = @"http://www.media.inaf.it/category/eventi/feed/";
    
    parser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
    
    [parser setDelegate:self];
    
    // settiamo alcune proprietà
    [parser setShouldProcessNamespaces:NO];
    [parser  setShouldReportNamespacePrefixes:NO];
    [ parser  setShouldResolveExternalEntities:NO];
    
    // avviamo il parsing del feed RSS
    [parser parse];
    
    [self.collectionView reloadData];
    
}



-(void)viewDidAppear:(BOOL)animated
{
    if(load == 0)
        
    {
        load = 1;
        [self loadData];
    }

}
- (void)viewDidLoad
{
    
    UIBarButtonItem * refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(loadData) ];
    
    self.navigationItem.rightBarButtonItem= refresh ;
    load = 0;
    self.title = @"Events";
    
    [self.collectionView registerClass:[NewsCell class] forCellWithReuseIdentifier:@"cvCell"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(300, 440)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setMinimumLineSpacing:10.0];
    [flowLayout setSectionInset:UIEdgeInsetsMake(10, 10, 10, 10)];
    // [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    [self.collectionView setCollectionViewLayout:flowLayout];
    
    
    news = [[NSMutableArray alloc] init];
    images = [[NSMutableDictionary alloc] init];
    
    self.sfondoView.image = [UIImage imageNamed:@"Assets/sunset1.jpg"];
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
        
        
        NSLog(@"cel");
        
        News * n  = [news objectAtIndex:indexPath.row];
        
        cell.title.textColor=[UIColor blackColor];
        cell.title.text = n.title;
        //sNSLog(@"%lu",(unsigned long)[notizie count]);
        cell.date.text = n.date;
        cell.summary.text = n.summary;
        cell.author.text = [NSString stringWithFormat:@"di %@",n.author];
        // [cell.immaginePreview loadImageAtURL:[NSURL URLWithString:[[notizie objectAtIndex:indexPath.row] linkImageSmall]]];
        NSString *identifier = [NSString stringWithFormat:@"Cell%ld" ,
                                (long)indexPath.row];
        
        if([images objectForKey:identifier] != nil)
        {
            cell.thumbnail.image = [images valueForKey:identifier];
            [cell.indicator stopAnimating];
        }
        else
        {
            cell.thumbnail.image = nil;
            [cell.indicator startAnimating];
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,  0ul);
            dispatch_async(queue, ^{
                //This is what you will load lazily
                
                NSData   *data = [NSData dataWithContentsOfURL:[NSURL URLWithString: [n.images objectAtIndex:0]]];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                    UIImage * image = [UIImage imageWithData:data];
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
            });
            
        }
        
        
    }
    
    //[titleLabel setText:cellData];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"deselect");
    
    
    DetailEventsViewController * detail = [[DetailEventsViewController alloc] initWithNibName:@"DetailEventsViewController" bundle:nil];
    
    detail.news = [news objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:detail animated:YES];

    
    
    [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
