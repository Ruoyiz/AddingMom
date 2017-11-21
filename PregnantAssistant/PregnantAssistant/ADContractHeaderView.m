//
//  ADContractHeaderView.m
//  
//
//  Created by D on 14/10/22.
//
//

#import "ADContractHeaderView.h"

@implementation ADContractHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 7, 175, 21)];
        
        //style
        [_titleLabel setFont:[UIFont systemFontOfSize:17]];
        
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
//        _titleLabel.textColor = [UIColor defaultTintColor];
        _titleLabel.textColor = [UIColor dark_green_Btn];
        
        [self addSubview:_titleLabel];
        
        UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(12, self.frame.size.height -0.5, SCREEN_WIDTH -24, 0.5)];
        bottomView.backgroundColor = [UIColor font_LightBrown];
        [self addSubview:bottomView];
    }
    
    return self;
}

@end
