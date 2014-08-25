//
//  Parser.h
//  INAF1
//
//  Created by Nicolo' Parmiggiani on 08/05/14.
// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <Foundation/Foundation.h>

@interface Parser : NSObject <NSXMLParserDelegate>

- (NSMutableArray *) parseText : (NSString * ) text;



@end
