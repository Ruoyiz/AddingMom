//
//  ADShareContent.h
//  PregnantAssistant
//
//  Created by D on 14/11/13.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADShareContent : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *des;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, retain) UIImage *img;

-(id)initWithTitle:(NSString *)aTitle
            andDes:(NSString *)aDes
            andUrl:(NSString *)aUrl
            andImg:(UIImage *)aImg;

@end
