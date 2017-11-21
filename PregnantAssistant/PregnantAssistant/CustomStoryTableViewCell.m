//
//  CustomStoryTableViewCell.m
//  CustomCellDemo
//
//  Created by D on 14/12/1.
//  Copyright (c) 2014年 D. All rights reserved.
//

#import "CustomStoryTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ADStoryDetailViewController.h"
#import "UIImage+FixOrientation.h"
//#import "UIFont+ADFont.h"
@implementation CustomStoryTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _summaryStory = [[UILabel alloc]init];
       
        _summaryStory.font = [UIFont momSecretCell_title_font];
        _summaryStory.lineBreakMode = NSLineBreakByCharWrapping;
        _summaryStory.numberOfLines = 20;
        _summaryStory.textColor = UIColorFromRGB(0x383245);

        [self addSubview:_summaryStory];
        
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
        _commentLabel.numberOfLines = 10;
        _commentLabel.font = [UIFont systemFontOfSize:12];
        _commentLabel.textColor = _placeAndDueLabel.textColor;
        [self addSubview:_commentLabel];
        
        _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_likeBtn setImage:[UIImage imageNamed:@"赞过的"] forState:UIControlStateSelected];
        [_likeBtn setImage:[UIImage imageNamed:@"赞"] forState:UIControlStateNormal];
        [self addSubview:_likeBtn];
        
        _commentImgView = [[UIImageView alloc]init];
        [self addSubview:_commentImgView];
        
        _recommandView = [[UIImageView alloc]initWithFrame:CGRectMake(20, self.frame.size.height -50, 25, 25)];
        _recommandView.image = [UIImage imageNamed:@"momSecertRec"];
        
        _recommandView.hidden = YES;
        
        [self addSubview:_recommandView];
        
        _bottomBg = [self getBottomBgWithWidth:self.frame.size.width];
        [self addSubview:_bottomBg];
        
        _delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_delBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_delBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
//        _delBtn.backgroundColor = [UIColor yellowColor];
        [_delBtn setTitleColor:UIColorFromRGB(0xFF6A80) forState:UIControlStateNormal];
        [self addSubview:_delBtn];
        _delBtn.hidden = YES;
        
        _showReportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showReportBtn setImage:[UIImage imageNamed:@"举报"] forState:UIControlStateNormal];
        [self addSubview:_showReportBtn];
        _showReportBtn.hidden = YES;
    }
    return self;
}

- (void)setIsLike:(NSString *)isLike
{
    _isLike = isLike;
    [_likeBtn setSelected:isLike.boolValue];
}

- (void)setShowDelBtn:(BOOL)showDelBtn
{
    _showDelBtn = showDelBtn;
    _delBtn.hidden = !showDelBtn;
}

//-(void)setIsHot:(BOOL)isHot
//{
//    _isHot = isHot;
//    if (isHot == YES) {
//        [_likeBtn setImage:[UIImage imageNamed:@"hotGoodPressed"] forState:UIControlStateSelected];
//        [_likeBtn setImage:[UIImage imageNamed:@"hotGood"] forState:UIControlStateNormal];
//        [_likeBtn setImage:[UIImage imageNamed:@"goodPressed"] forState:UIControlStateSelected];
//        [_likeBtn setImage:[UIImage imageNamed:@"good"] forState:UIControlStateNormal];
//
//    } else {
//        [_likeBtn setImage:[UIImage imageNamed:@"goodPressed"] forState:UIControlStateSelected];
//        [_likeBtn setImage:[UIImage imageNamed:@"good"] forState:UIControlStateNormal];
//    }
//}

- (void)setIsComment:(BOOL)isComment
{
    _isComment = isComment;
    if (_isComment == YES) {
//        _commentImgView.image = [UIImage imageNamed:@"commentPressed"];
        _commentImgView.image = [UIImage imageNamed:@"评论过的"];
    }else {
//        _commentImgView.image = [UIImage imageNamed:@"comment"];
        _commentImgView.image = [UIImage imageNamed:@"评论"];
    }
}

-(void)setIsRecommand:(BOOL)isRecommand
{
    _isRecommand = isRecommand;
    if (_isRecommand == YES) {
        _recommandView.hidden = NO;
    }else {
        _recommandView.hidden = YES;
    }
}

- (void)setShowReport:(BOOL)showReport
{
    _showReport = showReport;
    if (_showReport) {
        _showReportBtn.hidden = NO;
    } else {
        _showReportBtn.hidden = YES;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_contentBg removeFromSuperview];

    CGRect textRect = [_summaryStory.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH -36, 1200)
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                        attributes:@{NSFontAttributeName: [UIFont momSecretCell_title_font]}
                                                           context:nil];
    
    _summaryStory.frame = CGRectMake(18, 21, self.frame.size.width -36, textRect.size.height);
    
//    [[_likeBtn imageView]setContentMode:UIViewContentModeCenter];
//    if (_isHot == YES) {
//        _likeBtn.frame = CGRectMake(SCREEN_WIDTH -62, self.frame.size.height -12 -32, 26, 26);
//    } else {
//        _likeBtn.frame = CGRectMake(SCREEN_WIDTH -62, self.frame.size.height -12 -32, 26, 26);
//    }
    
    _bottomBg.frame = CGRectMake(0, self.frame.size.height -0.25 -12 +1, self.frame.size.width, 12);
    _recommandView.frame = CGRectMake(20, self.frame.size.height -45, 25, 25);
    
    _likeBtn.frame = CGRectMake(SCREEN_WIDTH -18 -22, self.frame.size.height -24 -30, 40, 40);
    _likeLabel.frame = CGRectMake(_likeBtn.frame.origin.x -30 -8, 0, 40, 30);
    _likeLabel.center = CGPointMake(_likeLabel.center.x, _likeBtn.center.y);
    
    _commentImgView.frame = CGRectMake(SCREEN_WIDTH -76, 0, 11, 11);
    _commentImgView.center = CGPointMake(_commentImgView.center.x, _likeBtn.center.y);
    
    _commentLabel.frame = CGRectMake(_commentImgView.frame.origin.x -10 -28, 0, 28, 28);
    _commentLabel.center = CGPointMake(_commentLabel.center.x, _likeBtn.center.y);
    
    _placeAndDueLabel.frame = CGRectMake(SCREEN_WIDTH - 210 -106, 0, 200, 24);
    _placeAndDueLabel.center = CGPointMake(_placeAndDueLabel.center.x, _likeBtn.center.y);
    
    _showReportBtn.frame = CGRectMake(_commentLabel.frame.origin.x -30, 0, 40, 40);
    if (_showReport == YES) {
        _placeAndDueLabel.center = CGPointMake(_placeAndDueLabel.center.x - 30, _likeBtn.center.y);
    }
    _showReportBtn.center = CGPointMake(_showReportBtn.center.x, _likeBtn.center.y);
    
    _delBtn.frame = CGRectMake(2, self.frame.size.height -44, 60, 28);
    _delBtn.center = CGPointMake(_delBtn.center.x, _likeBtn.center.y);

//    _commentLabel.backgroundColor = [UIColor yellowColor];
//    _momLookReportBtn.frame = CGRectMake(_likeLabel.frame.origin.x -16, self.frame.size.height -38, 40, 40);
}

- (UIView *)getLineViewWithWidth:(float)aWidth
{
    UIView *aLineView = [[UIView alloc]initWithFrame:CGRectMake(16, 0, aWidth, 1)];
    aLineView.backgroundColor = UIColorFromRGB(0xEBEAEA);
    return aLineView;
}

- (UIView *)getBottomBgWithWidth:(float)aWidth
{
    UIView *aLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, aWidth, 12)];
    aLineView.backgroundColor = [UIColor dirty_yellow];
    return aLineView;
}

-(void)setImageUrlArray:(NSArray *)imageUrlArray
{
    _imageUrlArray = imageUrlArray;
    //size
    CGFloat size = (SCREEN_WIDTH -8*2 -18*2) /3;
    //add images
    int index= 0;
    CGRect textRect = [_summaryStory.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH -36, 1000)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName:[UIFont momSecretCell_title_font]}
                                                    context:nil];
    
    _summaryStory.frame = CGRectMake(18, 0, SCREEN_WIDTH -36, textRect.size.height);
    
    for (int i = 0; i < _imageViewArray.count; i++) {
        UIImageView *imageView = _imageViewArray[i];
        [imageView removeFromSuperview];
    }
    _imageViewArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    for (NSString *aUrl in _imageUrlArray) {
        @autoreleasepool {
            if ([aUrl isKindOfClass:[NSString class]] && aUrl.length > 0) {
                float rowPos = textRect.size.height + index /3 *(size +8) +12 +21; //21 顶部文字间距 12-文字图片间距
                float colPos = 18 + index %3 *(size +8);
                UIImageView *aImgView = [[UIImageView alloc]initWithFrame:CGRectMake(colPos, rowPos, size, size)];
                aImgView.tag = 20 +index;
                
                if (_passThoughTouch == YES) {
                    aImgView.userInteractionEnabled = NO;
                } else {
                    aImgView.userInteractionEnabled = YES;
                }
                UITapGestureRecognizer *aGes =
                [[UITapGestureRecognizer alloc]initWithTarget:self.parentVC action:@selector(touchImg:)];
                [aImgView addGestureRecognizer:aGes];
                
                NSString *smallImgUrl = [NSString stringWithFormat:@"%@!small180", aUrl];
//                NSLog(@"aSmallUrl:%@", aUrl);
                aImgView.backgroundColor = UIColorFromRGB(0xf2ece4);
                
                UIImageView *placeImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 108/3.0, 100/3.0)];
                placeImgView.image = [UIImage imageNamed:@"pic_loading_background"];
                placeImgView.center = CGPointMake(size /2., size /2.);
                [aImgView addSubview:placeImgView];
                
                [aImgView sd_setImageWithURL:[NSURL URLWithString:smallImgUrl]
                            placeholderImage:nil
                                     options:0
                                    progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    [placeImgView removeFromSuperview];
                }];
                
                [self addSubview:aImgView];
                [_imageViewArray addObject:aImgView];
                index++;
            }
        }
    }
}

- (void)touchImg:(UITapGestureRecognizer *)aGes
{
}

@end