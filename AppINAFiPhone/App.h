//
//  App.h
//  AppINAFiPhone
//
//  Created by Nicolo' Parmiggiani on 29/08/14.
// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <Foundation/Foundation.h>

@interface App : NSObject

@property ( nonatomic,strong) NSString * ID;
@property ( nonatomic,strong) NSString * name;
@property ( nonatomic,strong) NSString * authors ;
@property ( nonatomic,strong) NSString * desciption ;
@property ( nonatomic,strong) NSString * iconUrl;
@property ( nonatomic,strong) NSString * infoURL;
@property ( nonatomic,strong) NSString * androidURL;
@property ( nonatomic,strong) NSString * iosURL;


@end
