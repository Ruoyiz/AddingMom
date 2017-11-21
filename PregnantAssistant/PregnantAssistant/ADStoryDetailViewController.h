//
//  ADStoryDetailViewController.h
//  PregnantAssistant
//
//  Created by D on 14/12/5.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADBaseViewController.h"
#import "ADShareView.h"
#import "ADShareContent.h"
#import "CustomStoryTableViewCell.h"
#import "BHInputToolbar.h"
#import "ADTopicTableViewCell.h"
#import "ADCustomImageVC.h"
#import "ADActionSheetView.h"

@protocol ChangeLikeStatusWhenBack <NSObject>

- (void)changeStatusAtIndex:(NSInteger)index withObjc:(NSDictionary *)aSecret;

@end
typedef void(^isdeleteReturnBlock)(BOOL isDelete,NSInteger rowIndex);


@interface ADStoryDetailViewController : ADBaseViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate,BHInputToolbarDelegate,ADActionSheetDelegate>

@property (nonatomic, retain) UITableView *myTableView;
@property (nonatomic, retain) NSMutableArray *commentArray;
@property (nonatomic, retain) ADShareView *aShareView;
@property (nonatomic, retain) UIView *bgView;
@property (nonatomic, retain) ADShareContent *aShareContent;
@property (nonatomic, copy) NSDictionary *aSecret;
@property (nonatomic, assign) int cellHeight;
@property (nonatomic, assign) NSInteger currentPos;

@property (nonatomic, retain) CustomStoryTableViewCell *aStoryCell;

@property (nonatomic, assign) BOOL isComment;
@property (nonatomic, assign) BOOL isLike;

@property (nonatomic, assign) NSInteger localCommentNum;
@property (nonatomic, assign) int localLikeNum;

@property (nonatomic, assign) BOOL haveMoreData;

//@property (nonatomic, assign) BOOL isSending;

@property (nonatomic, assign) NSInteger postId;

@property (nonatomic, assign) BOOL scrollBottom;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, strong) BHInputToolbar *inputToolbar;

@property (nonatomic, copy) NSDictionary *toReplyComment;

//@property (nonatomic, assign) BOOL onlyShowLouzhu;

@property (nonatomic, assign) BOOL isTopic;

@property (nonatomic, assign) BOOL alreadyHaveComment;

@property (nonatomic, retain) ADTopicTableViewCell *aTopicCell;
@property (nonatomic, retain) ADTopic *topic;

@property (nonatomic, retain) UILabel *louzhuLabel;

@property (nonatomic, retain) ADCustomImageVC *aImgVc;

@property (nonatomic,assign) id <ChangeLikeStatusWhenBack> delegate;
@property (nonatomic,assign) NSInteger fromRow;

@property (nonatomic,assign) NSInteger cellIndex;
@property (nonatomic,copy)isdeleteReturnBlock isDeleteReturnBlock;
@property (nonatomic, assign) BOOL comefromMomSec;
- (void)isDeleteReturnBackBlock:(isdeleteReturnBlock)block;


@end
