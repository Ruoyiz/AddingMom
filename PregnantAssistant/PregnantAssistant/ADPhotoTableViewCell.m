//
//  ADPhotoTableViewCell.m
//  PregnantAssistant
//
//  Created by D on 14/10/31.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADPhotoTableViewCell.h"

@implementation ADPhotoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        ADShadowBgView *aBg =
//        [[ADShadowBgView alloc]initWithFrame:CGRectMake(22, 0, 434/2, 170)];
        [[ADShadowBgView alloc]initWithFrame:CGRectMake(22, 0, (SCREEN_WIDTH +114)/2, 170)];
        
//        [[ADShadowBgView alloc]initWithFrame:CGRectMake(22, 0, (SCREEN_WIDTH +214)/2, 170)];
        CGPoint newCenter = aBg.center;
        
        [self addSubview:aBg];
        newCenter.x = SCREEN_WIDTH /2;
        aBg.center = newCenter;
        
        _photoView = [[UIImageView alloc]initWithFrame:CGRectMake(2, 2, (SCREEN_WIDTH +78)/2, 150)];
        _photoView.center = aBg.center;
        [self addSubview:_photoView];
        
        self.backgroundColor = [UIColor bg_lightYellow];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
