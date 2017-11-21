//
//  ADHistoryCell.m
//  PregnantAssistant
//
//  Created by D on 14-9-23.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADHistoryCell.h"

@implementation ADHistoryCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    for (UIView *subview in self.subviews) {
        
        //8
        if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationView"]) {
            //your color
            ((UIView*)[subview.subviews firstObject]).backgroundColor=[UIColor darkTintColor];
            break;
        }
        // 7
        for(UIView *subview2 in subview.subviews){
            if ([NSStringFromClass([subview2 class]) isEqualToString:@"UITableViewCellDeleteConfirmationView"]) {
                //your color
                ((UIView*)[subview2.subviews firstObject]).backgroundColor=[UIColor darkTintColor];
                break;
            }
        }
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
    }
    return self;
}

@end
