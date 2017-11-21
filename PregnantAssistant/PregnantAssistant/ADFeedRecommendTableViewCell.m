//
//  ADFeedRecommendTableViewCell.m
//  PregnantAssistant
//
//  Created by ruoyi_zhang on 15/6/24.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADFeedRecommendTableViewCell.h"

@interface ADFeedRecommendTableViewCell (){
    UIImageView *_titleImage;
    UILabel *_desLabel;
    UILabel *_mediaNameLabel;
    UIView * _lineView;
    UIButton *_rssButton;
 }
@end
@implementation ADFeedRecommendTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(14, 17, 42, 42)];
        _titleImage.layer.masksToBounds = YES;
        _titleImage.layer.cornerRadius = 21;
        [self addSubview:_titleImage];
        _mediaNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(66, 17, SCREEN_WIDTH - 160, 20)];
        [self addSubview:_mediaNameLabel];
        _desLabel = [[UILabel alloc] initWithFrame:CGRectMake(66, 47, SCREEN_WIDTH - 160, 20)];
        _desLabel.numberOfLines = 1;
        [self addSubview:_desLabel];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(14, 20 + 66, SCREEN_WIDTH - 28, 0.5)];
        [_lineView setBackgroundColor:[UIColor separator_gray_line_color]];
        [self addSubview:_lineView];
        
        _rssButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 90, 40)];
        _rssButton.center = CGPointMake(SCREEN_WIDTH - 14 - 45, _mediaNameLabel.center.y);
        _rssButton.backgroundColor = [UIColor clearColor];
        _rssButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_rssButton setImage:[UIImage imageNamed:@"加订阅小"] forState:UIControlStateNormal];
        [_rssButton setImage:[UIImage imageNamed:@"取消订阅小"] forState:UIControlStateSelected];
        [_rssButton addTarget:self action:@selector(rssButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_rssButton];
    }
    return self;
}

- (void)setRefreshModel:(ADFeedContentListModel *)refreshModel{
    _refreshModel = refreshModel;
    
    _mediaNameLabel.attributedText = [ADHelper getEMAttributeStringFromEmString:refreshModel.mediaName font:[UIFont ADTraditionalFontWithSize:15] color:UIColorFromRGB(0x333333) highlightColor:[UIColor btn_green_bgColor]];
    [_titleImage sd_setImageWithURL:[NSURL URLWithString:refreshModel.logoUrl] placeholderImage:[UIImage imageNamed:@"feedTitle100"]];
    _desLabel.attributedText = [ADHelper getEMAttributeStringFromEmString:refreshModel.myDescription font:[UIFont parentToolTitleViewDetailHeiFontWithSize:13] color:UIColorFromRGB(0x737373) highlightColor:[UIColor btn_green_bgColor]];
    
    if ([refreshModel.isRss isEqualToString:@"0"]) {
        _rssButton.selected = NO;
    }else{
        _rssButton.selected = YES;
    }
}

- (void)rssButtonClicked:(UIButton *)button
{
//    button.selected = !button.selected;
    if ([self.delegate respondsToSelector:@selector(tableViewCell:didClickedRssButton:)]) {
        [self.delegate tableViewCell:self didClickedRssButton:button];
    }
}

+ (CGFloat)getFeedRecommendWithModel:(ADFeedContentListModel *)model
{
    return 87;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
