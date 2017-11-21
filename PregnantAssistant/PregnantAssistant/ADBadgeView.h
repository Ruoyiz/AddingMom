//
//  ADBadgeView.h
//  PregnantAssistant
//
//  Created by D on 14/12/6.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADBadgeView : UIView

@property (nonatomic, retain) UILabel *badgeLabel;

- (id)initWithFrame:(CGRect)frame
             andNum:(int)aNum
         andBgColor:(UIColor *)aColor;

- (void)clearBadgeNo;

@end
