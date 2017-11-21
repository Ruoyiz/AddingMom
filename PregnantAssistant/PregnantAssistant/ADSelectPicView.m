//
//  ADSelectPicView.m
//  PregnantAssistant
//
//  Created by D on 14/11/8.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADSelectPicView.h"

@implementation ADSelectPicView

- (id)initWithFrame:(CGRect)frame
             andImg:(UIImage *)aImg
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *picView =
        [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,
                                                     self.frame.size.height, self.frame.size.height)];
        picView.image = aImg;
        [self addSubview:picView];
        _isSelect = NO;
        
        //add gesture
        picView.userInteractionEnabled = YES;
        UITapGestureRecognizer *photoTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapSelect)];
        [picView addGestureRecognizer:photoTap];
        
    }
    return self;
}

- (void)didTapSelect
{
    if (_isSelect == NO) {
        if (selectNum == PIC_NUM_LIMIT) {
            [[[UIAlertView alloc] initWithTitle:@"亲爱的"
                                        message:@"最多只能选择40张哦"
                                       delegate:self
                              cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
            return;
        }
        _isSelect = YES;
        _selectMarkView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.height - 32, 0, 31, 31)];
        _selectMarkView.image = [UIImage imageNamed:@"picCheck"];
        [self addSubview:_selectMarkView];
        
        selectNum += 1;
    } else {
        _isSelect = NO;
        [_selectMarkView removeFromSuperview];
        
        selectNum -= 1;
    }
    
    if (selectNum > 0) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"kChangeDoneEnable" object:nil];
    } else {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"kChangeDoneUnenable" object:nil];
    }
}

- (void)dealloc
{
    selectNum = 0;
}

@end
