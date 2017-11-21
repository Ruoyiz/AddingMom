//
//  ADHaveLabourThingCell.m
//  PregnantAssistant
//
//  Created by D on 14-9-19.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADHaveLabourThingCell.h"


@implementation ADHaveLabourThingCell

- (void)awakeFromNib {
//    self.thingLabel.textColor = [UIColor font_Brown];
    self.thingLabel.textColor = [UIColor font_btn_color];
    self.thingLabel.font = [UIFont systemFontOfSize:14];
    
//    self.numLabel.textColor = [UIColor font_Brown];
    self.numLabel.textColor = [UIColor font_btn_color];
    self.numLabel.font = [UIFont systemFontOfSize:14];
    
    if (_aSelectBtn == nil) {
        _aSelectBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 64, 2, 60, 30)];
        [_aSelectBtn setSelected:NO];
        [_aSelectBtn setImage:[UIImage imageNamed:@"待产包未打勾"]
                     forState:UIControlStateNormal];
        [_aSelectBtn setImage:[UIImage imageNamed:@"待产包打勾"]
                     forState:UIControlStateSelected];
        [_aSelectBtn addTarget:self
                        action:@selector(didCheck:)
              forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_aSelectBtn];
    }
}

- (void)didCheck:(id)sender {
    [self setCheck:_aSelectBtn.selected];
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

- (void)setCheck:(BOOL)status
{
    if(status) {
        [_aSelectBtn setSelected:NO];
    }else{
        [_aSelectBtn setSelected:YES];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
