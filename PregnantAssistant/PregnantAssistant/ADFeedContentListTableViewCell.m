//
//  ADFeedContentListTableViewCell.m
//  PregnantAssistant
//
//  Created by ruoyi_zhang on 15/6/19.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADFeedContentListTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIFont+ADFont.h"
#import "ADLable.h"
#import "UIImage+Tint.h"
@interface ADFeedContentListTableViewCell (){
    
    UIImageView *_topImageView;
    ADLable *_authorLable;
    UIButton *_timeButton;
    UILabel *_desLabel;
    NSInteger _indexY;
    UIView *_lineView;
    UIView *_dotShow;
}
@end

@implementation ADFeedContentListTableViewCell

- (void)awakeFromNib {
    // Initialization code
} 

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _isSeen = NO;
        [self layoutUI];
    }
    return self;
}
#define TOP_DISTANCE 17
#define LEFT_DISTANCE 14
#define TOPIMAGE_WIDTH 42
#define AUTHORLABEL_HEIGHT 20
#define DOTSHOW_WIDTh 9
- (void)layoutUI{
    NSInteger indexX;
    _indexY = TOP_DISTANCE;
    
    _topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_DISTANCE, _indexY, TOPIMAGE_WIDTH, TOPIMAGE_WIDTH)];
    [self addSubview:_topImageView];
    indexX = LEFT_DISTANCE + TOPIMAGE_WIDTH + 10;
    
    _authorLable = [[ADLable alloc] initWithFrame:CGRectMake(indexX , _indexY, SCREEN_WIDTH - indexX, AUTHORLABEL_HEIGHT)];
    _authorLable.verticalAlignment = VerticalAlignmentTop;
    [self addSubview:_authorLable];
    _indexY += AUTHORLABEL_HEIGHT + 5;
    
    _timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _timeButton.frame = CGRectMake(indexX, _indexY, 60, 10);
    [_timeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 2, 60 - 8)];
    _timeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_timeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
    _timeButton.titleLabel.font = [UIFont parentToolTitleViewDetailHeiFontWithSize:9];
    [self addSubview:_timeButton];
    
    _indexY += 29;
    _desLabel = [[UILabel alloc] init];
    _desLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _desLabel.numberOfLines = 0;
    [self addSubview:_desLabel];
    
    _dotShow = [[UIView alloc] init];
    _dotShow.frame = CGRectMake(42, TOP_DISTANCE, DOTSHOW_WIDTh, DOTSHOW_WIDTh);
    _dotShow.layer.masksToBounds = YES;
    _dotShow.layer.cornerRadius = DOTSHOW_WIDTh/2.0;
    _dotShow.backgroundColor = UIColorFromRGB(0xF23739);
    _dotShow.hidden = YES;
    [self addSubview:_dotShow];

    
}

- (void)setRefModel:(ADFeedContentListModel *)refModel{
    if (refModel) {
        if (refModel.dotShow) {
            if ([refModel.dotShow integerValue]) {
               // _dotShow.hidden = NO;
            }
        }
        _topImageView.layer.masksToBounds = YES;
        _topImageView.layer.cornerRadius = TOPIMAGE_WIDTH/2;
        [_topImageView sd_setImageWithURL:[NSURL URLWithString:refModel.logoUrl] placeholderImage:[UIImage imageNamed:@"feedTitle100"]];
        _authorLable.attributedText = [[NSAttributedString alloc] initWithString:refModel.mediaName attributes:@{NSFontAttributeName:[UIFont parentToolTitleViewDetailHeiFontWithSize:14],NSForegroundColorAttributeName:UIColorFromRGB(0x333333)}];
        if ([refModel.newestPublishTime integerValue]) {
            _timeButton.hidden = NO;
            [_timeButton setImage:[[UIImage imageNamed:@"clock-circular-outline"] imageWithTintColor:UIColorFromRGB(0x737373)] forState:UIControlStateNormal];
            [_timeButton setAttributedTitle:[[NSAttributedString alloc] initWithString:[self getTimeStringWithTimer:refModel.newestPublishTime] attributes:@{NSFontAttributeName:[UIFont parentToolTitleViewDetailHeiFontWithSize:9],NSForegroundColorAttributeName:UIColorFromRGB(0x737373)}] forState:UIControlStateNormal];

        }else{
            _timeButton.hidden = YES;
        }
        if (refModel.title) {
            _desLabel.attributedText = [[NSAttributedString alloc] initWithString:refModel.title attributes:@{NSFontAttributeName:[UIFont parentToolTitleViewDetailHeiFontWithSize:12],NSForegroundColorAttributeName:UIColorFromRGB(0x737373)}];
        }
        NSInteger indexX = LEFT_DISTANCE + TOPIMAGE_WIDTH + 10;
        CGSize desLabelSize = [refModel.title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - indexX - LEFT_DISTANCE, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
        _desLabel.frame = CGRectMake(indexX, _indexY, desLabelSize.width, desLabelSize.height);
        _lineView.frame = CGRectMake(14, desLabelSize.height + 77, SCREEN_WIDTH - 28, 0.5);
    }
}
#define NOTICE_IMAGE_HEIGHT 20
- (void)setRefNoticeModel:(ADNoticeInfo *)refNoticeModel{
    
    _topImageView.frame = CGRectMake(LEFT_DISTANCE, TOP_DISTANCE, NOTICE_IMAGE_HEIGHT, NOTICE_IMAGE_HEIGHT);
    if ([refNoticeModel.type intValue] <= 4) {
        _topImageView.image = _isSeen ? [[UIImage imageNamed:@"消息－秘密"]imageWithTintColor:[UIColor colorWithWhite:0.8 alpha:1]]:[UIImage imageNamed:@"消息－秘密"];
    }else{
        _topImageView.image = _isSeen ? [[UIImage imageNamed:@"消息－看看"]imageWithTintColor:[UIColor colorWithWhite:0.8 alpha:1]]:[UIImage imageNamed:@"消息－看看"];
    }
    NSInteger indexX = LEFT_DISTANCE + NOTICE_IMAGE_HEIGHT + 10;
    _authorLable.frame = CGRectMake(indexX , TOP_DISTANCE, SCREEN_WIDTH - indexX, AUTHORLABEL_HEIGHT);
    if (refNoticeModel.message) {
        _authorLable.attributedText = [[NSAttributedString alloc] initWithString:refNoticeModel.message attributes:@{NSFontAttributeName:[UIFont parentToolTitleViewDetailHeiFontWithSize:14]}];
    }
    _timeButton.frame = CGRectMake(indexX, TOP_DISTANCE + AUTHORLABEL_HEIGHT + 5, 60, 10);
    if ([refNoticeModel.updateTime integerValue]) {
        [_timeButton setTitle:[self getTimeStrFromTimestamp:[refNoticeModel.updateTime integerValue]]  forState:UIControlStateNormal];
    }
    if (refNoticeModel.quote) {
        _desLabel.attributedText = [[NSAttributedString alloc] initWithString:refNoticeModel.quote attributes:@{NSFontAttributeName:[UIFont parentToolTitleViewDetailHeiFontWithSize:12],NSForegroundColorAttributeName:UIColorFromRGB(0x333333)}];
    }
    CGSize desLabelSize = [refNoticeModel.quote boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - indexX - LEFT_DISTANCE, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    _desLabel.frame = CGRectMake(indexX, _indexY, desLabelSize.width, desLabelSize.height);
    if (_isSeen) {
        _authorLable.textColor = [UIColor colorWithWhite:0.8 alpha:1];
        _desLabel.textColor = [UIColor colorWithWhite:0.8 alpha:1];
        [_timeButton setImage:[[UIImage imageNamed:@"clock-circular-outline"] imageWithTintColor:[UIColor colorWithWhite:0.8 alpha:1] ] forState:UIControlStateNormal];
        [_timeButton setTitleColor:[UIColor colorWithWhite:0.8 alpha:1] forState:UIControlStateNormal];
    } else {
        _authorLable.textColor = UIColorFromRGB(0x333333);
        _desLabel.textColor = UIColorFromRGB(0x333333);
        [_timeButton setImage:[[UIImage imageNamed:@"clock-circular-outline"] imageWithTintColor: UIColorFromRGB(0x333333)] forState:UIControlStateNormal];
        [_timeButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    }
}

- (void)setRefSecrertNotiModel:(ADSecrertNoticeinfoModel *)refSecrertNotiModel{
    _topImageView.frame = CGRectMake(LEFT_DISTANCE, TOP_DISTANCE, NOTICE_IMAGE_HEIGHT, NOTICE_IMAGE_HEIGHT);
    NSArray *titleArray = @[@"有人回复了你的秘密",@"有人赞了你的秘密",@"有人回复了你的秘密评论",@"有人赞了你的秘密评论"];
    _topImageView.image = _isSeen ? [[UIImage imageNamed:@"消息－秘密"]imageWithTintColor:[UIColor colorWithWhite:0.8 alpha:1]]:[UIImage imageNamed:@"消息－秘密"];
    NSString *titleString = [titleArray firstObject];
    switch ([refSecrertNotiModel.type integerValue]) {
        case 2:
            titleString = [refSecrertNotiModel.commentCount integerValue] > 1 ? [NSString stringWithFormat:@"有%@人回复了你的秘密",refSecrertNotiModel.commentCount]:titleArray[0];
            break;
        case 1:
            titleString = [refSecrertNotiModel.praiseCount integerValue] > 1 ? [NSString stringWithFormat:@"有%@人赞了你的秘密",refSecrertNotiModel.praiseCount]:titleArray[1];
            break;
        case 3:
            titleString = [refSecrertNotiModel.commentCount integerValue] > 1 ? [NSString stringWithFormat:@"有%@人回复了你的秘密评论",refSecrertNotiModel.commentCount]:titleArray[2];
            break;
        case 4:
            titleString = [refSecrertNotiModel.praiseCount integerValue] > 1 ? [NSString stringWithFormat:@"有%@人赞了你的秘密评论",refSecrertNotiModel.praiseCount]:titleArray[3];
            break;
        default:
            break;
    }
    NSInteger indexX = LEFT_DISTANCE + NOTICE_IMAGE_HEIGHT + 10;
    _authorLable.frame = CGRectMake(indexX , TOP_DISTANCE, SCREEN_WIDTH - indexX, AUTHORLABEL_HEIGHT);
    _authorLable.attributedText = [[NSAttributedString alloc] initWithString:titleString attributes:@{NSFontAttributeName:[UIFont parentToolTitleViewDetailHeiFontWithSize:14]}];
    _timeButton.frame = CGRectMake(indexX, TOP_DISTANCE + AUTHORLABEL_HEIGHT + 5, 60, 10);
    if ([refSecrertNotiModel.creatTime integerValue]) {
        [_timeButton setTitle:[self getTimeStrFromTimestamp:[refSecrertNotiModel.creatTime integerValue]] forState:UIControlStateNormal];
     }
    if (refSecrertNotiModel.postbody) {
        _desLabel.attributedText = [[NSAttributedString alloc] initWithString:refSecrertNotiModel.postbody attributes:@{NSFontAttributeName:[UIFont parentToolTitleViewDetailHeiFontWithSize:12],NSForegroundColorAttributeName:[UIColor colorWithWhite:0.3 alpha:1]}];
    }
    CGSize desLabelSize = [refSecrertNotiModel.postbody boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - indexX - LEFT_DISTANCE, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    _desLabel.frame = CGRectMake(indexX, _indexY, desLabelSize.width, desLabelSize.height);
    if (_isSeen) {
        _authorLable.textColor = [UIColor colorWithWhite:0.8 alpha:1];
        _desLabel.textColor = [UIColor colorWithWhite:0.8 alpha:1];
        [_timeButton setImage:[[UIImage imageNamed:@"clock-circular-outline"] imageWithTintColor:[UIColor colorWithWhite:0.8 alpha:1] ] forState:UIControlStateNormal];
        [_timeButton setTitleColor:[UIColor colorWithWhite:0.8 alpha:1] forState:UIControlStateNormal];
    } else {
        _authorLable.textColor = UIColorFromRGB(0x333333);
        _desLabel.textColor = UIColorFromRGB(0x333333);
        [_timeButton setImage:[[UIImage imageNamed:@"clock-circular-outline"] imageWithTintColor: UIColorFromRGB(0x333333)] forState:UIControlStateNormal];
        [_timeButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    }

}

+ (CGFloat)getCellHeightWithModel:(ADFeedContentListModel *)model{
    CGSize desLabelSize = [model.title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - TOPIMAGE_WIDTH - 2 * LEFT_DISTANCE, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    return  71 + desLabelSize.height + 17;
}

+ (CGFloat)getNoticeCellHeightWithModel:(ADNoticeInfo *)model{
    CGSize size = [model.quote boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - TOPIMAGE_WIDTH - 2 * LEFT_DISTANCE,  MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    return 71 + size.height + 17;
}


+ (CGFloat)getSecrertCellHeightWithModel:(ADSecrertNoticeinfoModel *)model{
    CGSize size = [model.postbody boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - TOPIMAGE_WIDTH - 2 * LEFT_DISTANCE,  MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    return 71 + size.height + 17;
}

- (NSString *)getTimeStringWithTimer:(NSString *)timerString{
    double timer = [timerString doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timer];
    NSInteger month = [date month];
    NSInteger day = [date day];
    return [NSString stringWithFormat:@"%ld月%ld日",(long)month,(long)day];
}
- (NSString *)getTimeStrFromTimestamp:(NSInteger)timestamp
{
    NSDate *today = [NSDate date];
    NSDate *time = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    NSInteger day = [today daysAfterDate:time];
    NSInteger hour = [today hoursAfterDate:time] % 24;
    NSInteger minute = [today minutesAfterDate:time] % 60;
    
    if (day > 0) {
        return [NSString stringWithFormat:@"%ld天前",(long)day];
    }else if (hour > 0){
        return [NSString stringWithFormat:@"%ld小时前",(long)hour];
    }else if (minute > 0){
        return [NSString stringWithFormat:@"%ld分钟前",(long)minute];
    }
    
    return @"1分钟前";
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
