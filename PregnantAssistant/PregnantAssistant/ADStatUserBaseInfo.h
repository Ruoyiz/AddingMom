//
//  ADStatUserBaseInfo.h
//  PregnantAssistant
//
//  Created by D on 15/3/4.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADStatUserBaseInfo : NSObject

@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *event;
@property (nonatomic, copy) NSString *osType;
@property (nonatomic, copy) NSString *osSubType;
@property (nonatomic, copy) NSString *appVersion;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;

@end
