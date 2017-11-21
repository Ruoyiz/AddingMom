//
//  ADMomLookContentTableViewCell.m
//  PregnantAssistant
//
//  Created by D on 15/3/2.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADMomLookContentTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define kLineMargin 10
#define LINESPACE_5 7
#define LINESPACE_6 7
@implementation ADMomLookContentTableViewCell
{
    UILabel *_tagLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _palceImgView = [[UIImageView alloc]init];
//        _palceImgView.backgroundColor = [UIColor cell_placeHolder_image_color];
        _palceImgView.image = [UIImage imageNamed:@"加丁号文章默认"];
        [self addSubview:_palceImgView];
        
        _thumbImgView = [[UIImageView alloc]init];
        [self addSubview:_thumbImgView];
        
        _subTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 28, 12)];
//        _subTitleLabel.textColor = [UIColor cell_subTitle_color];
        
        [self addSubview:_subTitleLabel];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 140, 40)];

        //_titleLabel.textColor = [UIColor blackColor];

        _titleLabel.numberOfLines = 2;

        
        [self addSubview:_titleLabel];
        
        _publishTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 28, 12)];
        _publishTimeLabel.textColor = [UIColor cell_subTitle_color];

        [self addSubview:_publishTimeLabel];
        
//        _titleLabel.font = [UIFont momLookCell_title_font];
//        _subTitleLabel.font = [UIFont momLookCell_subTitle_font];
        _publishTimeLabel.font = [UIFont momLookCell_subTitle_font];
        
        [self loadTagLabel];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _thumbImgView.frame = CGRectMake(14, 17, 80, 80);
    
    _palceImgView.frame = _thumbImgView.frame;

    _thumbImgView.contentMode = UIViewContentModeScaleAspectFill;
    _thumbImgView.clipsToBounds = YES;
    
    CGFloat originX = _thumbImgView.frame.origin.x + _thumbImgView.frame.size.width +10;
    _titleLabel.frame = CGRectMake(originX, 36, SCREEN_WIDTH - originX -12, 40);
    
    if (!([_aMomLookInfo.title isEqual:[NSNull null]] || _aMomLookInfo.title == nil)) {
        NSMutableAttributedString *attributedString = [ADHelper getEMAttributeStringFromEmString:_aMomLookInfo.title font:[UIFont ADTraditionalFontWithSize:15] color:[UIColor blackColor] highlightColor:[UIColor btn_green_bgColor]];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        if (iPhone6 || iPhone6Plus) {
            [paragraphStyle setLineSpacing:LINESPACE_6];//调整行间距
        } else {
            [paragraphStyle setLineSpacing:LINESPACE_5];//调整行间距
        }

        [attributedString addAttribute:NSParagraphStyleAttributeName
                                 value:paragraphStyle
                                 range:NSMakeRange(0, [attributedString.string length])];

        _titleLabel.attributedText = attributedString;
        [_titleLabel sizeToFit];
    }
    
    _subTitleLabel.attributedText = [ADHelper getEMAttributeStringFromEmString:_aMomLookInfo.mediaSource font:[UIFont ADTraditionalFontWithSize:13] color:[UIColor cell_subTitle_color] highlightColor:[UIColor btn_green_bgColor]];

    _subTitleLabel.frame = CGRectMake(originX, 17, 160, 13);
    
    if (self.fromSearch) {
        _publishTimeLabel.frame = CGRectMake(originX, _thumbImgView.frame.size.height +4, SCREEN_WIDTH - originX - 30, 13);
        _publishTimeLabel.hidden = NO;
        _publishTimeLabel.attributedText = [ADHelper getEMAttributeStringFromEmString:_aMomLookInfo.aDescription font:[UIFont ADTraditionalFontWithSize:13] color:[UIColor cell_subTitle_color] highlightColor:[UIColor btn_green_bgColor]];
    }else{
        if (_aMomLookInfo.aPublishTime.length > 0) {
            _publishTimeLabel.hidden = NO;
            _publishTimeLabel.frame = CGRectMake(originX, _thumbImgView.frame.size.height +4, 160, 13);
            _publishTimeLabel.text = [ADHelper getAmongTimeByTimeSp:_aMomLookInfo.aPublishTime];
        } else {
            _publishTimeLabel.hidden = YES;
        }
    }
    
}

- (UIImageView *)buildLabelWithType:(momLookCellLabelType)aMomLookCellLabelType
{
    UIImageView *tipImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 28, 11)];
    switch (aMomLookCellLabelType) {
        case cellLabelNewType:
            tipImgView.image = [UIImage imageNamed:@"new"];
            break;
        case cellLabelAdType:
            tipImgView.image = [UIImage imageNamed:@"推广"];
            break;
        default:
            break;
    }
    return tipImgView;
}

- (void)setShowAdView:(BOOL)showAdView
{
    _showAdView = showAdView;
}

- (void)setTagLabelStr:(NSString *)tagLabelStr
{
    if ([tagLabelStr isEqual:[NSNull null]] || tagLabelStr == nil) {
        _tagLabel.hidden = YES;
    }else{
        if ([tagLabelStr isEqualToString:@"推广"]) {
            _tagLabel.backgroundColor = [UIColor tagRedColor];
        }else{
            _tagLabel.backgroundColor = [UIColor tagGreenColor];
        }
        _tagLabel.hidden = NO;
        _tagLabel.text = tagLabelStr;
    }
}

- (void)loadTagLabel
{
    _tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 65, 7, 50, 18)];
    _tagLabel.font = [UIFont ADTitleFontWithSize:13];
    _tagLabel.textColor = [UIColor whiteColor];
    _tagLabel.textAlignment = NSTextAlignmentCenter;
    _tagLabel.hidden = YES;
    [self addSubview:_tagLabel];
}

@end