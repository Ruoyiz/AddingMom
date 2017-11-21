//
//  ADInfoListTextCell.m
//  PregnantAssistant
//
//  Created by yitu on 15/3/30.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADInfoListTextCell.h"
#define CELL_WIDTH self.frame.size.width
#define CELL_HEIGHT self.frame.size.height
#define kMargin (iPhone6Plus?20:15)
#define ICON_HEIGNT 27
#define kLineMargin 10
@implementation ADInfoListTextCell
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
    
    self.indicateImage = [[UIImageView alloc] initWithFrame:
                          CGRectMake(SCREEN_WIDTH - 14/2 - kMargin, (CELL_HEIGHT -11)/2, 4, 11)];
    _indicateImage.image = [UIImage imageNamed:@"gogrey"];
    [self.contentView addSubview:_indicateImage];
    
    self.contentLabel = [[UILabel alloc] initWithFrame:
                         CGRectMake((SCREEN_WIDTH - 200 - 2*kMargin - _indicateImage.frame.size.width),
                                    0, 200, CELL_HEIGHT)];
    _contentLabel.textAlignment = NSTextAlignmentRight;
    _contentLabel.backgroundColor = [UIColor clearColor];
    _contentLabel.textColor = [UIColor lightGrayColor];
    _contentLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_contentLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
