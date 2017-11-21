//
//  ADCanNotEatBtn.m
//  PregnantAssistant
//
//  Created by D on 15/3/24.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADCanNotEatBtn.h"

@implementation ADCanNotEatBtn

- (id)initWithFrame:(CGRect)frame
           andTitle:(NSString *)aTitle
         andImgName:(NSString *)aImgName
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setClipsToBounds:YES];
        [self.layer setCornerRadius:frame.size.width /2];
        self.layer.borderColor = UIColorFromRGB(0xe65463).CGColor;
        self.layer.borderWidth = 1.f;
        
        self.backgroundColor = UIColorFromRGB(0xF3EBE3);

        _titleStr = aTitle;
        [self addTitle:aTitle];

        [self addImage:aImgName];
    }
    return self;
}

- (void)addTitle:(NSString *)aTitle
{
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    title.text = aTitle;
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont systemFontOfSize:16];
    
    title.center = CGPointMake(self.frame.size.width /2, self.frame.size.height /2 +28);
    [self addSubview:title];
}

- (void)addImage:(NSString *)aImg
{
    UIImageView *aImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    aImage.image = [UIImage imageNamed:aImg];
    aImage.contentMode = UIViewContentModeCenter;
    aImage.center = CGPointMake(self.frame.size.width /2, self.frame.size.height /2 -12);

    [self addSubview:aImage];
}

@end
