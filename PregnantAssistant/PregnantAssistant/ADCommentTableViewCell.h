//
//  ADCommentTableViewCell.h
//  PregnantAssistant
//
//  Created by D on 14/12/5.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADCommentTableViewCell : UITableViewCell

@property (nonatomic, retain) UILabel *userLabel;
@property (nonatomic, retain) UILabel *commentLabel;
@property (nonatomic, retain) UILabel *floorAndHourLabel;
@property (nonatomic, retain) UILabel *likeLabel;
@property (nonatomic, retain) UIButton *likeBtn;
@property (nonatomic, retain) UIView *bottomLine;

@property (nonatomic, retain) UIButton *momLookReportBtn;
//@property (nonatomic, retain) UIButton *commentBtn;

@property (nonatomic, assign) BOOL isLike;
@property (nonatomic, assign) BOOL isHot;


@end