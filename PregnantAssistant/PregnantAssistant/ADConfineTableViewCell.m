//
//  ADConfineTableViewCell.m
//  PregnantAssistant
//
//  Created by D on 14-9-26.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADConfineTableViewCell.h"

#define LINESPACE 6
@implementation ADConfineTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _name = [[UILabel alloc]initWithFrame:CGRectMake(16, 8, SCREEN_WIDTH - 32, 14)];
        _name.font = [UIFont systemFontOfSize:14];
//        _name.backgroundColor = [UIColor greenColor];
        _name.textColor = [UIColor defaultTintColor];
        [self addSubview:_name];
        
        _detail = [[UILabel alloc]init];
        _detail.font = [UIFont systemFontOfSize:13];
//        _detail.textColor = [UIColor font_Brown];
        _detail.textColor = [UIColor font_tip_color];
        [self addSubview:_detail];
    }
    return self;
}

- (void)setDetailStr:(NSString *)detailStr
{
    CGSize sizeHeight = [detailStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 1000)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12+3]}
                                                context:nil].size;

    _detail.frame = CGRectMake(15, 30, SCREEN_WIDTH - 32, sizeHeight.height);
    
    NSMutableAttributedString *attributedString =
    [[NSMutableAttributedString alloc] initWithString:detailStr];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:LINESPACE];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:paragraphStyle
                             range:NSMakeRange(0, [detailStr length])];
    self.detail.attributedText = attributedString;
    
    self.detail.lineBreakMode = NSLineBreakByCharWrapping;
    self.detail.numberOfLines = 6;
    [self.detail sizeToFit];
    
    _detailHeight = self.detail.frame.size.height;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
