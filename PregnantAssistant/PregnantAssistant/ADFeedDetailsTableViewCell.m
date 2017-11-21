//
//  ADFeedDetailsTableViewCell.m
//  PregnantAssistant
//
//  Created by ruoyi_zhang on 15/6/23.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADFeedDetailsTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface ADFeedDetailsTableViewCell (){
    UIImageView *_titleImage;
    UILabel *_desLabel;
    UILabel *_timeLabel;
    
}
@end
@implementation ADFeedDetailsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(14, 0, SCREEN_WIDTH - 28, 0.5)];
        [lineView setBackgroundColor:[UIColor separator_gray_line_color]];
        [self addSubview:lineView];
        _titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(14, 16,  80, 80)];
        [_titleImage setBackgroundColor:[UIColor cell_placeHolder_image_color]];
        _titleImage.contentMode = UIViewContentModeScaleAspectFill;
        _titleImage.clipsToBounds = YES;
        [self addSubview:_titleImage];
        _desLabel = [[UILabel alloc] init];
        _desLabel.textAlignment = NSTextAlignmentJustified;
        _desLabel.numberOfLines = 2;
        _desLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:_desLabel];
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(103, 112 - 31 + 4.5, SCREEN_WIDTH - 99, 15)];
        
        [self addSubview:_timeLabel];
    }
    return self;
}

- (void)setRefreshModel:(ADFeedDetailModel *)refreshModel{
//    [_titleImage sd_setImageWithURL:[NSURL URLWithString:[refreshModel.images firstObject]]];
    [_titleImage sd_setImageWithURL:[NSURL URLWithString:[refreshModel.images firstObject]] placeholderImage:[UIImage imageNamed:@"加丁号文章默认"]];
    NSMutableParagraphStyle *paragraphstyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphstyle setLineSpacing:10];
    _desLabel.attributedText = [[NSAttributedString alloc] initWithString:refreshModel.title attributes:@{NSFontAttributeName:[UIFont parentToolTitleViewDetailHeiFontWithSize:14],NSForegroundColorAttributeName:UIColorFromRGB(0x333333),NSParagraphStyleAttributeName:paragraphstyle}];
    CGSize size = [refreshModel.title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 113, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont parentToolTitleViewDetailHeiFontWithSize:14],NSParagraphStyleAttributeName:paragraphstyle} context:nil].size;
    _desLabel.frame = size.height >70 ?  CGRectMake(103, 16, size.width, 70): CGRectMake(99, 16, size.width, size.height);
    _timeLabel.attributedText = [[NSAttributedString alloc] initWithString:[self getTimeStringWithTimer:refreshModel.publishTime] attributes:@{NSFontAttributeName:[UIFont parentToolTitleViewDetailHeiFontWithSize:9],NSForegroundColorAttributeName:UIColorFromRGB(0x737373)}];

}

- (NSString *)getTimeStringWithTimer:(NSString *)timer{
    
    return [ADHelper getAmongTimeByTimeSp:timer];
}

+ (CGFloat)getCellHeightWithModel:(ADFeedDetailModel *)model{
    NSMutableParagraphStyle *paragraphstyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphstyle setLineSpacing:10];
    CGSize size = [model.title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 109, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont parentToolTitleViewDetailHeiFontWithSize:14],NSParagraphStyleAttributeName:paragraphstyle} context:nil].size;
    return size.height + 50;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
