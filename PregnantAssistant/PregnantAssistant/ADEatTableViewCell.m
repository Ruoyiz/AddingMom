//
//  ADEatTableViewCell.m
//  PregnantAssistant
//
//  Created by D on 14-9-26.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADEatTableViewCell.h"

#define LINESPACE 4
@implementation ADEatTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        NSLog(@"custom Cell");
        _name = [[UILabel alloc]initWithFrame:CGRectMake(16, 8, SCREEN_WIDTH - 32, 14)];
        _name.font = [UIFont systemFontOfSize:14];
        _name.textColor = [UIColor defaultTintColor];
        [self addSubview:_name];
        
    }
    return self;
}

- (void)setDetailStr:(NSString *)detailStr
{
    _detail = [[UILabel alloc]initWithFrame:CGRectMake(16, 14 +16, SCREEN_WIDTH -32, 100)];
    
    NSMutableAttributedString *attributedString =
    [[NSMutableAttributedString alloc] initWithString:detailStr];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:LINESPACE];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:paragraphStyle
                             range:NSMakeRange(0, [detailStr length])];
    _detail.attributedText = attributedString;
    
    _detail.lineBreakMode = NSLineBreakByCharWrapping;
    _detail.numberOfLines = 4;

    _detail.font = [UIFont systemFontOfSize:13];
    _detail.textColor = [UIColor font_Brown];
    
    [_detail sizeToFit];
    [self addSubview:_detail];
    
    _customBtn =
    [[ADCustomButton alloc]initWithFrame:
     CGRectMake(64, _detail.frame.origin.y +_detail.frame.size.height +4, SCREEN_WIDTH -128, 32)];
    [_customBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _customBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_customBtn setBackgroundColor:[UIColor defaultTintColor]];
    
    [_customBtn setTitleStr:@"参考食谱"];
    [self addSubview:_customBtn];
    
    _cellHeight = _customBtn.frame.origin.y + _customBtn.frame.size.height +8;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
