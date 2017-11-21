//
//  ADIcon.h
//  PregnantAssistant
//
//  Created by D on 14-9-16.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADIcon : NSObject <NSCoding>

@property (nonatomic, retain) UIImage *uImg;
@property (nonatomic, retain) UIImage *sImg;
@property (nonatomic, retain) UIImage *smallImg;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL isCollect;
@property (nonatomic, assign) BOOL isWeb;
@property (nonatomic, copy) NSString *myVc;

-(id)initWithTitle:(NSString *)aTitle
           andUImg:(NSString *)uImg
           andSImg:(NSString *)sImg
          andIsWeb:(BOOL)aWeb
             andVC:(NSString *)aVc;

-(id)initWithTitle:(NSString *)aTitle
           andUImg:(NSString *)uImg
           andSImg:(NSString *)sImg
             andVC:(NSString *)aVc;

@end
