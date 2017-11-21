//
//  ADBackgroundView.m
//  PregnantAssistant
//
//  Created by D on 14-9-18.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADBackgroundView.h"
static int LINESPACE = 8;

@implementation ADBackgroundView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *img = [UIImage imageNamed:@"暂无记录绿色"];
        _imgView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH -105)/2 -12, 0, 105, 161)];
        _imgView.image = img;
        CGPoint newCenter = self.center;
        newCenter.y -= [ADHelper getNavigationBarHeight] +24;
        _imgView.center = newCenter;
        [self addSubview:_imgView];
    }
    return self;
}

-(void)setATip:(NSString *)aTip
{
    UILabel *aLabel = [[UILabel alloc]initWithFrame:
     CGRectMake(22, _imgView.frame.origin.y +_imgView.frame.size.height +12, SCREEN_WIDTH -44, 64)];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:aTip];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:LINESPACE];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:paragraphStyle
                             range:NSMakeRange(0, [aTip length])];
    aLabel.attributedText = attributedString;
    
    aLabel.lineBreakMode = NSLineBreakByCharWrapping;
    aLabel.numberOfLines = 2;
    aLabel.font = [UIFont systemFontOfSize:13];
    aLabel.backgroundColor = [UIColor clearColor];
    aLabel.textColor = [UIColor font_Brown];
//    CGPoint newCenter = self.center;
//    newCenter.y = 570/2;
//    aLabel.center = newCenter;
    [self addSubview:aLabel];
}

@end
