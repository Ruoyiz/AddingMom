//
//  ADInfoListImageCell.m
//  PregnantAssistant
//
//  Created by yitu on 15/3/31.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADInfoListImageCell.h"
#define CELL_WIDTH self.frame.size.width
#define CELL_HEIGHT 76
#define kMargin 30/2
#define ICON_HEIGNT 50
#define ICON_WIDTH 50
#define kLineMargin 10
@implementation ADInfoListImageCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self createCustomCell];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}
//配置cell内容
- (void)createCustomCell
{
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMargin,(CELL_HEIGHT - ICON_HEIGNT)/2, 120, ICON_HEIGNT)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = UIColorFromRGB(0x333333);
    _titleLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_titleLabel];
    
    self.iconImage = [[UIImageView alloc] initWithFrame: CGRectMake(SCREEN_WIDTH - ICON_WIDTH - kMargin, (CELL_HEIGHT - ICON_HEIGNT)/2,
                                     ICON_WIDTH, ICON_HEIGNT)];
    [self.contentView addSubview:_iconImage];

    [self.iconImage setClipsToBounds:YES];
    [self.iconImage.layer setCornerRadius:self.iconImage.frame.size.height /2];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
