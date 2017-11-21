//
//  ADDreamCardView.h
//  PregnantAssistant
//
//  Created by D on 14-9-27.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADDreamCardView : UIView

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *content;

@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *contentLabel;

@property (nonatomic, assign) float addCardHeight;

@end
