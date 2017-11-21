//
//  ADDreamCardView.m
//  PregnantAssistant
//
//  Created by D on 14-9-27.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADDreamCardView.h"
#define LINESPACE 6

@implementation ADDreamCardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(8, 6, 4, 15)];
        imgView.image = [UIImage imageNamed:@"工具大全里面的红色长条"];
        [self addSubview:imgView];

        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 6, SCREEN_WIDTH -72, 15)];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textColor = [UIColor defaultTintColor];
        
        [self addSubview:_nameLabel];
    }
    return self;
}

-(void)setName:(NSString *)name
{
    _nameLabel.text = name;
}

-(void)setContent:(NSString *)content
{
    CGSize sizeHeight = [content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH -44, 2000)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14+3]}
                                              context:nil].size;

    _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 26, SCREEN_WIDTH -44, sizeHeight.height)];
    _contentLabel.font = [UIFont systemFontOfSize:13];
    _contentLabel.textColor = [UIColor font_Brown];
    _contentLabel.numberOfLines = 50;
    
    NSMutableAttributedString *attributedString =
    [[NSMutableAttributedString alloc] initWithString:content];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:LINESPACE];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:paragraphStyle
                             range:NSMakeRange(0, [content length])];
    _contentLabel.attributedText = attributedString;
    
    _contentLabel.lineBreakMode = NSLineBreakByCharWrapping;

    [_contentLabel sizeToFit];
//    _contentLabel.backgroundColor = [UIColor yellowColor];
    
    [self addSubview:_contentLabel];
    
    _addCardHeight = _contentLabel.frame.size.height;
}
@end
