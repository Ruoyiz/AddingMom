//
//  ADCanNotEatTableViewCell.m
//  PregnantAssistant
//
//  Created by D on 14-9-29.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADCanNotEatTableViewCell.h"

#define LINESPACE 4

@implementation ADCanNotEatTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(98, 15, SCREEN_WIDTH - 32, 16)];
        _nameLabel.font = [UIFont title_font];
        _nameLabel.textColor = [UIColor defaultTintColor];
        _nameLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_nameLabel];
        
        self.backgroundColor = [UIColor bg_lightYellow];
        
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH -98 -12, 112)];
        [self addSubview:_contentLabel];
        _contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _contentLabel.numberOfLines = 14;
        
        _contentLabel.font = [UIFont systemFontOfSize:12];
//        _contentLabel.textColor = [UIColor font_Brown];
        _contentLabel.textColor = [UIColor font_tip_color];
        _contentLabel.backgroundColor = [UIColor clearColor];
        
        _moreBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH -16 -24 -4, 70, 28, 14)];
        [_moreBtn setTitle:@"更多" forState:UIControlStateNormal];
        _moreBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_moreBtn setBackgroundColor:[UIColor clearColor]];
        [_moreBtn setTitleColor:[UIColor defaultTintColor] forState:UIControlStateNormal];
        
        [self addSubview:_moreBtn];           
        _moreBtn.hidden = YES;
        
        _logoImgView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 10, 80, 80)];
        _logoImgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_logoImgView];
        
        _bottomLine = [[UIImageView alloc]initWithFrame:CGRectMake(8, _logoImgView.frame.size.height +24 -1,
                                                                   SCREEN_WIDTH -16, 0.5)];
        _bottomLine.backgroundColor = [UIColor defaultTintColor];
        [self addSubview:_bottomLine];

    }
    return self;
}

- (void)setLogo:(UIImage *)logo
{
    _logo = logo;
    _logoImgView.image = logo;
}

- (void)setContent:(NSString *)content
{
    _subContent = content;
//    if (content.length > 53) {
//    if ([ADHelper getStrLength:_subContent] > 26) {
        if (content.length > 48) {
        _subContent = [NSString stringWithFormat:@"%@...", [content substringToIndex:47]];
//        NSLog(@"subcontent:%@",_subContent);
        _moreBtn.hidden = NO;
//        }
    } else {
        _moreBtn.hidden = YES;
    }
    _content = content;
    CGRect textRect = [_subContent boundingRectWithSize:CGSizeMake(SCREEN_WIDTH -98 -12, 240)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName:[UIFont tip_font]}
                                                context:nil];
    textRect.origin.x = 98;
    textRect.origin.y = 40;

    _contentLabel.frame = textRect;
    
    _contentLabel.text = _subContent;
    
    [_contentLabel sizeToFit];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.frame.size.height >100.0) {
        CGRect textRect = [_content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH -98 -12, 240)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}
                                                 context:nil];
        textRect.origin.x = 98;
        textRect.origin.y = 40;
        _contentLabel.frame = textRect;
        _contentLabel.text = _content;
        NSLog(@"changed");
        
        [_contentLabel sizeToFit];

//        _contentLabel.backgroundColor = [UIColor yellowColor];
        _moreBtn.hidden = YES;
    }
    
    _bottomLine.frame = CGRectMake(8, self.frame.size.height -1, SCREEN_WIDTH -16, 0.5);
//    _height = _contentLabel.frame.origin.y + _contentLabel.frame.size.height + 4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
