//
//  ADTopicTableViewCell.h
//  PregnantAssistant
//
//  Created by D on 14/12/29.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADTopic.h"

@interface ADTopicTableViewCell : UITableViewCell

@property (nonatomic, copy) NSString *buttonTitle;
//@property (nonatomic, retain) UIButton *topicBtn;
@property (nonatomic, retain) UIView *bottomLine;
@property (nonatomic, retain) UIImageView *bgImgView;
@property (nonatomic, retain) UIViewController *parentVC;
@property (nonatomic, assign) NSInteger postId;
@property (nonatomic, assign) NSInteger uId;
@property (nonatomic, retain) ADTopic *aTopic;

@property (nonatomic, retain) UILabel *placeAndDueLabel;
@property (nonatomic, retain) UILabel *likeLabel;
@property (nonatomic, retain) UILabel *commentLabel;
@property (nonatomic, retain) UIButton *likeBtn;
@property (nonatomic, retain) UIImageView *commentImgView;
@property (nonatomic, assign) BOOL isShowDetail;
@property (nonatomic, copy) NSString *isLike;
@property (nonatomic, assign) BOOL isComment;

@property (nonatomic, copy) NSString *topic;

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                        topic:(ADTopic *)topic
                   showDetail:(BOOL)isShowDetail;

@end
