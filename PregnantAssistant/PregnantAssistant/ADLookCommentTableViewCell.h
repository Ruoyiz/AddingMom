//
//  ADLookCommentTableViewCell.h
//  PregnantAssistant
//
//  Created by chengfeng on 15/5/7.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADMomLookCommentModel.h"

@class ADLookCommentTableViewCell;

@protocol CommentPraiseDelegate <NSObject>
//
//- (void)clickedMoreButton:(UIButton *)buton;
//
//- (void)clickedCommentButton:(UIButton *)button;

- (void)commentCell:(ADLookCommentTableViewCell *)cell clickedPraiseButton:(UIButton *)button;

@end

@interface ADLookCommentTableViewCell : UITableViewCell

@property (nonatomic,assign) id <CommentPraiseDelegate> commentDelegate;

//显示头像
@property (nonatomic,strong) UIImageView *iconImageView;

//显示时钟图标
@property (nonatomic,strong) UIImageView *clockImageView;

//显示评论人
@property (nonatomic,strong) UILabel *userNameLabel;

//显示评论内容
@property (nonatomic,strong) UILabel *commentContentLabel;

//用来存放更多操作的view （更多，点赞，评论数）
@property (nonatomic,strong) UIButton *moreOperateButton;

////显示更多的图标
//@property (nonatomic,strong) UIButton *moreButton;
//
////显示评论图标
//@property (nonatomic,strong) UIButton *commentButton;
//
////显示点赞图标
//@property (nonatomic,strong) UIButton *linkButton;

//显示更新时间
@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) UIImageView *priseImageView;

@property (nonatomic,strong) UILabel *priseCountLabel;

//显示子评论
@property (nonatomic,strong) UIView *subCommentView;

//判断热评全部评论
//@property (nonatomic,assign) ADCommentStyle commentStyle;

//保存数据模型
@property (nonatomic,strong) ADMomLookCommentModel *model;

//获取cell内容
//- (void)setCommentModel:(ADMomLookCommentModel *)commentModel comentStyle:(ADCommentStyle)commentStyle;

//获取cell高度
+ (CGFloat)cellHeightFromModel:(ADMomLookCommentModel *)model;

@end
