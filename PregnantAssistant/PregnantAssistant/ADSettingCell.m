//
//  ADSettingCell.m
//  FetalMovement
//
//  Created by wangpeng on 14-3-14.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import "ADSettingCell.h"

#define CELL_WIDTH self.frame.size.width
#define CELL_HEIGHT self.frame.size.height
#define kMargin (iPhone6Plus?20:15)
//#define ICON_HEIGNT 27
#define kLineMargin 10

@interface ADSettingCell (){
    CGFloat _cellHeight;
}

@property (nonatomic, assign) CGFloat iconHeight;

@end

@implementation ADSettingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
      andIconHeight:(CGFloat)aHeight cellHeight:(CGFloat)cellHeight
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.iconHeight = aHeight;
        _cellHeight = cellHeight;
        [self createCustomCell];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCustomCell];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

//配置cell内容
- (void)createCustomCell
{
    self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(kMargin, (_cellHeight - self.iconHeight)/2, self.iconHeight, self.iconHeight)];
    [self.contentView addSubview:_iconImage];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconImage.frame.origin.x + _iconHeight + 12,0, 120, _cellHeight)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = UIColorFromRGB(0x333333);
    _titleLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_titleLabel];
    
    _redDotImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_titleLabel.frame.origin.x + 65, 0, 6, 6)];
    _redDotImageView.center = CGPointMake(_redDotImageView.frame.origin.x + 3, _cellHeight/2.0);
    _redDotImageView.layer.cornerRadius = 3;
    _redDotImageView.layer.masksToBounds = YES;
    _redDotImageView.backgroundColor = [UIColor red_Dot_color];
    _redDotImageView.hidden = YES;
    [self.contentView addSubview:_redDotImageView];
    
    self.indicateImage = [[UIImageView alloc] initWithFrame:
                          CGRectMake(SCREEN_WIDTH - 14/2 - kMargin, (_cellHeight - 11)/2, 4, 11)];
    _indicateImage.image = [UIImage imageNamed:@"gogrey"];
    [self.contentView addSubview:_indicateImage];
    
    self.contentLabel = [[UILabel alloc] initWithFrame:
                         CGRectMake((SCREEN_WIDTH - 200 - 2*kMargin - _indicateImage.frame.size.width),0, 200, _cellHeight)];
    _contentLabel.textAlignment = NSTextAlignmentRight;
    _contentLabel.backgroundColor = [UIColor clearColor];
    //_contentLabel.textColor = UIColorFromRGB(0x737373);
    _contentLabel.textColor = [UIColor lightGrayColor];
    _contentLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_contentLabel];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
