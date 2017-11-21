//
//  ADShareContent.m
//  PregnantAssistant
//
//  Created by D on 14/11/13.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADShareContent.h"

@implementation ADShareContent

-(id)initWithTitle:(NSString *)aTitle
            andDes:(NSString *)aDes
            andUrl:(NSString *)aUrl
            andImg:(UIImage *)aImg
{
    if (self = [super init]) {
        _title = aTitle;
        _des = aDes;
        _url = aUrl;
        _img = aImg;
    }
    return self;
}

@end
