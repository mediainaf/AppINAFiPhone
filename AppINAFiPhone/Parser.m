//
//  Parser.m
//  INAF1
//
//  Created by Nicolo' Parmiggiani on 08/05/14.
// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "Parser.h"

@interface Parser ()
{
    NSXMLParser * parser;
    NSString * imPath;
    NSMutableArray * images;

}

@end

@implementation Parser


-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"error %@",parseError.description);
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    
    //NSLog(@"elemento %@",elementName);
    
    //  NSLog(@"%@",attributeDict);
    if([elementName isEqualToString:@"img"]){
        
        //   NSLog(@"elemento2");
        
        imPath=[attributeDict valueForKey:@"src"];
        //   NSLog(@"url %@", imPath );
        [images addObject:imPath];
        //  NSLog(@"%@",imPath);
    }
    
    
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    //   NSLog(@"character %@",string);
}

-(NSMutableArray *)parseText:(NSString *)text
{
    // NSLog(@"inizio1");
    
    images = [[NSMutableArray alloc] init];
    
    
    NSMutableString * textForParsing = [[NSMutableString alloc ] init];
    textForParsing = [NSMutableString stringWithFormat:@" <content:encoded> %@ </content:encoded>",text];
    
    
    [textForParsing replaceOccurrencesOfString:@"&nbsp" withString:@" " options:NSLiteralSearch range:NSMakeRange(0, [textForParsing length])];
    
    //  NSLog(@"text %@",textForParsing);
    NSData* data =[textForParsing dataUsingEncoding:NSUTF8StringEncoding];
    
    parser = [[NSXMLParser alloc] initWithData:data ];
    [parser setShouldProcessNamespaces:NO];
    [parser  setShouldReportNamespacePrefixes:NO];
    [ parser  setShouldResolveExternalEntities:NO];
    parser.delegate = self;
    
    [parser parse];
    
    // NSLog(@"inizio 3 %d",[images count]);
    
    return  images;
}



@end
