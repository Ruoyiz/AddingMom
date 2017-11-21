//
//  ADCustomEatButton.m
//  PregnantAssistant
//
//  Created by D on 14-9-27.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADCustomEatButton.h"

@implementation ADCustomEatButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"btn width:%f",frame.size.width);
        UIImageView *titleImgView =
        [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width - 10 -12, 22, 10, 58/3)];
        titleImgView.image = [UIImage imageNamed:@"粉红箭头"];
        [self addSubview:titleImgView];
        
        self.backgroundColor = [UIColor whiteColor];
        [self setClipsToBounds:YES];
        [self.layer setCornerRadius:8];
    }
    return self;
}

- (void)setTitleImage:(UIImage *)titleImage
{
    _titleImage = titleImage;
    UIImageView *titleImgView =
    [[UIImageView alloc]initWithFrame:CGRectMake(6, 6, 52, 52)];
    titleImgView.image = titleImage;
    [self addSubview:titleImgView];
}

- (void)setTitleStr:(NSString *)titleStr
{
    _titleStr = titleStr;
    _myTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(62, 24, 60, 16)];
    _myTitleLabel.text = titleStr;
    _myTitleLabel.font = [UIFont systemFontOfSize:15];
    _myTitleLabel.textColor = [UIColor defaultTintColor];
//    _myTitleLabel.backgroundColor = [UIColor greenColor];
    
    [self addSubview:_myTitleLabel];
}

@end
