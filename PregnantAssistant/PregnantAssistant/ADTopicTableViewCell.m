//
//  ADTopicTableViewCell.m
//  PregnantAssistant
//
//  Created by D on 14/12/29.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADTopicTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation ADTopicTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                        topic:(ADTopic *)topic
                   showDetail:(BOOL)isShowDetail
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _aTopic = topic;
        _buttonTitle = _aTopic.topicTitle;
 
        _bgImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _bgImgView.frame =
        CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH *(1012 /1080.0));
        [_bgImgView sd_setImageWithURL:[NSURL URLWithString:_aTopic.imgUrl]
                      placeholderImage:[UIImage imageNamed:@""]
                               options:SDWebImageProgressiveDownload];
        
        [self addSubview:_bgImgView];
        
//        [self addSubview:_topicBtn];
        
        _isShowDetail = isShowDetail;
        if (isShowDetail == YES) {
            _placeAndDueLabel = [[UILabel alloc]init];
            _placeAndDueLabel.textAlignment = NSTextAlignmentRight;
            _placeAndDueLabel.font = [UIFont systemFontOfSize:12];
            _placeAndDueLabel.textColor = UIColorFromRGB(0x85818D);
            [self addSubview:_placeAndDueLabel];
            
            _likeLabel = [[UILabel alloc]init];
            _likeLabel.textAlignment = NSTextAlignmentRight;
            _likeLabel.font = [UIFont systemFontOfSize:12];
            _likeLabel.textColor = _placeAndDueLabel.textColor;
            [self addSubview:_likeLabel];
            
            _commentLabel = [[UILabel alloc]init];
            _commentLabel.textAlignment = NSTextAlignmentRight;
            _commentLabel.numberOfLines = 5;
            _commentLabel.font = [UIFont systemFontOfSize:12];
            _commentLabel.textColor = _placeAndDueLabel.textColor;
            [self addSubview:_commentLabel];
            
            _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self addSubview:_likeBtn];
            
            [_likeBtn setImage:[UIImage imageNamed:@"赞过的"] forState:UIControlStateSelected];
            [_likeBtn setImage:[UIImage imageNamed:@"赞"] forState:UIControlStateNormal];
            
            _commentImgView = [[UIImageView alloc]init];
            [self addSubview:_commentImgView];
        }
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    UIFont *font = [UIFont systemFontOfSize:18];
//    CGSize stringSize = [_buttonTitle sizeWithAttributes:@{NSFontAttributeName:font}];
//    CGFloat width = stringSize.width;
//    [_topicBtn setFrame:CGRectMake(0, 0, width +72, 40)];
//    _topicBtn.center = CGPointMake(self.frame.size.width /2, self.frame.size.height -50);

    //line and bg
    _bottomLine = [self getLineViewWithWidth:self.frame.size.width];
    [self addSubview:_bottomLine];
    _bottomLine.center = CGPointMake(self.frame.size.width /2, self.frame.size.height -0.25 -12);
    
    UIView *bottomBg = [self getBottomBgWithWidth:self.frame.size.width];
    [self addSubview:bottomBg];
    
    if (_isShowDetail) {
//        _placeAndDueLabel.frame = CGRectMake(18, self.frame.size.height -12 -14- 20, self.frame.size.width -40, 28);
//        _commentLabel.frame = CGRectMake(20, self.frame.size.height -12 -14 -20, self.frame.size.width - 112, 28);
//        _likeLabel.frame = CGRectMake(20, self.frame.size.height -12 -14 -20, self.frame.size.width - 56, 28);
        
//        _placeAndDueLabel.frame = CGRectMake(SCREEN_WIDTH - 210,
//                                             self.frame.size.height -12 -14- 20, 100, 28);
//        _commentLabel.frame = CGRectMake(20, self.frame.size.height -12 -14 -20, SCREEN_WIDTH - 80, 28);
//        _likeLabel.frame = CGRectMake(20, self.frame.size.height -12 -14 -21, SCREEN_WIDTH - 36, 28);
//
//        _likeBtn.frame = CGRectMake(SCREEN_WIDTH -62, self.frame.size.height -12 -33, 26, 26);
//        _commentImgView.frame = CGRectMake(SCREEN_WIDTH -112, self.frame.size.height -12 -14 -20, 31, 26);
        
//        _likeBtn.frame = CGRectMake(SCREEN_WIDTH -18 -14, self.frame.size.height -24 -15, 14, 11);
        _likeBtn.frame = CGRectMake(SCREEN_WIDTH -18 -22, self.frame.size.height -24 -30, 40, 40);
        _likeLabel.frame = CGRectMake(_likeBtn.frame.origin.x -30 -8, 0, 40, 30);
        _likeLabel.center = CGPointMake(_likeLabel.center.x, _likeBtn.center.y);
        
        _commentImgView.frame = CGRectMake(SCREEN_WIDTH -76, 0, 11, 11);
        _commentImgView.center = CGPointMake(_commentImgView.center.x, _likeBtn.center.y);
        
        _commentLabel.frame = CGRectMake(_commentImgView.frame.origin.x -10 -28, 0, 28, 28);
        _commentLabel.center = CGPointMake(_commentLabel.center.x, _likeBtn.center.y);
        
        _placeAndDueLabel.frame = CGRectMake(SCREEN_WIDTH - 210 -106, 0, 200, 24);
        _placeAndDueLabel.center = CGPointMake(_placeAndDueLabel.center.x, _likeBtn.center.y);

    }
}

//-(void)setButtonTitle:(NSString *)buttonTitle
//{
//}

- (UIView *)getBottomBgWithWidth:(float)aWidth
{
    UIView *aLineView = [[UIView alloc]initWithFrame:CGRectMake(0, _bottomLine.frame.origin.y +1, aWidth, 12)];
    aLineView.backgroundColor = [UIColor bg_lightYellow];
    return aLineView;
}

- (UIView *)getLineViewWithWidth:(float)aWidth
{
    UIView *aLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, aWidth, 1)];
    aLineView.backgroundColor = UIColorFromRGB(0xEBEAEA);
    return aLineView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setIsLike:(NSString *)isLike
{
    _isLike = isLike;
    [_likeBtn setSelected:isLike.boolValue];
}

- (void)setIsComment:(BOOL)isComment
{
    _isComment = isComment;
    if (_isComment == YES) {
        _commentImgView.image = [UIImage imageNamed:@"评论过的"];
    }else {
        _commentImgView.image = [UIImage imageNamed:@"评论"];
    }
}

@end
