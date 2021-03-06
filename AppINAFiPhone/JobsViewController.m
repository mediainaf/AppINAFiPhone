//
//  JobsViewController.m
//  INAF1
//
//  Created by Nicolo' Parmiggiani on 15/02/14.
// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "JobsViewController.h"

#import "JobsCell.h"

#import "Job.h"
#import "InternetNewsViewController.h"


@interface JobsViewController ()
{
    
    NSMutableArray * jobs;
    int load;
    NSXMLParser * parser;
    
    NSMutableString *title,*description,*link,*date,*currentElement;

}

@end

@implementation JobsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    NSLog(@"current element %@",currentElement);
    currentElement = [elementName copy];
    if ([elementName isEqualToString:@"item"]) {
        
        title = [[NSMutableString alloc] init];
        
        date = [[NSMutableString alloc] init];
        description = [[NSMutableString alloc] init];
        
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
    }
    else if ([currentElement isEqualToString:@"dc:date"]) {
        [date appendString:string];
    } else if ([currentElement isEqualToString:@"description"]) {
        [description appendString:string];
    }
    
    
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"item"]) {
        /* salva tutte le proprietà del feed letto nell'elemento "item", per
         poi inserirlo nell'array "elencoFeed" */
        
        
        
        Job * j = [[Job alloc] init];
        
        j.title = title;
        
        
        NSString  * desc = [description stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        
        j.descriptionText = desc ;
        
        
        NSString * link2  = link;
        
        
        link2 = [link2 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        link2 = [link2 stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        j.link = link2;
        
        NSString * date2 = [date  substringToIndex:10];
        
        NSLog(@"link %@",link2);
        
        j.date = date2;
        
        [jobs addObject:j];
        
        //
        // NSLog(@"autore %@",imageLinkBig);
        
        
        
        
        //  news.titolo =
        
    }
    
}
-(void) loadData : (NSString *) url
{
    NSString *response1 = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil];
    if(!response1)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Internet Connection Error" message:@"Change internet settings" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    
    [jobs removeAllObjects];
    
    parser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
    
    [parser setDelegate:self];
    
    // settiamo alcune proprietà
    [parser setShouldProcessNamespaces:NO];
    [parser  setShouldReportNamespacePrefixes:NO];
    [ parser  setShouldResolveExternalEntities:NO];
    
    // avviamo il parsing del feed RSS
    [parser parse];
    
    [self.tableView reloadData];
    //[self.loadingView setHidden:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    if(load == 0)
    {
        load = 1;
        
        [self loadData:@"http://www.inaf.it/it/lavora-con-noi/concorsi-inaf/RSS"];
        
        
    }
    
}
- (void)viewDidLoad
{
    load = 0;

    jobs = [[NSMutableArray alloc] init];
    
    self.sfondoView.image = [UIImage imageNamed:@"Assets/galileo6.jpg"];
    self.sfondoView.alpha = 0.5;
    
    self.tableView.rowHeight = 200;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if([jobs count] >0)
        return [jobs count];
    return 10;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    JobsCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil)
    {
        cell= [[JobsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    cell.backgroundColor = [UIColor clearColor];
    //cell.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
    //cell.backgroundColor=[UIColor colorWithWhite:0.9 alpha:0.7];
    
    [cell.title setFont: [UIFont systemFontOfSize:18.0]];
    
    if([jobs count] >0)
    {
        
        
        Job * j = [jobs objectAtIndex:indexPath.row];
        
        cell.date.text = j.date;
        cell.title.text = j.title;
        // cell.description.text = j.description;
        // cell.detailTextLabel.text = j.description;
        
    }
    
    
    
    return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if([jobs count]>0)
    {
        InternetNewsViewController * detailJobsViewController = [[InternetNewsViewController alloc] initWithNibName:@"InternetNewsViewController" bundle:nil];
        
        Job * j = [jobs objectAtIndex:indexPath.row];
        
        detailJobsViewController.link = j.link;
        
        
        [self.navigationController pushViewController:detailJobsViewController animated:YES];

    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
