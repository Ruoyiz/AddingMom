//
//  ADEditToolTableViewCell.m
//  PregnantAssistant
//
//  Created by D on 15/3/19.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADEditToolTableViewCell.h"

@implementation ADEditToolTableViewCell

- (void)awakeFromNib {
    self.backgroundColor = [UIColor dirty_yellow];
    self.cellTitle.textColor = UIColorFromRGB(0x5F4D4C);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    self.editing = YES;
    UIView *cellSubview = self.subviews[0];

    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        cellSubview = self;
    }
    
    for(UIView *view in cellSubview.subviews) {
        NSLog(@"view: %@", view);
        if([[[view class] description] isEqualToString:@"UITableViewCellReorderControl"]) {
            
            for (UIControl *someObj in view.subviews) {
                if ([someObj isMemberOfClass:[UIImageView class]]) {
                    UIImage *img = [UIImage imageNamed:@"iconEdit"];
                    ((UIImageView*)someObj).frame = CGRectMake(0, 0, 50, 50);
                    ((UIImageView*)someObj).image = img;
                }
            }
        }
    }
}

@end
