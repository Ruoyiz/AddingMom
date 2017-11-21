//
//  ADLookCommentViewController.h
//  PregnantAssistant
//
//  Created by chengfeng on 15/6/23.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADBaseViewController.h"
#import "ADLookCommentTableViewCell.h"
#import "ADActionSheetView.h"
#import "ADInputBar.h"
#import "ADEmptyView.h"
#import "ADLoadingView.h"
#import "ADFailLodingView.h"

@interface ADLookCommentViewController : ADBaseViewController <UITableViewDataSource,UITableViewDelegate,CommentPraiseDelegate,UIAlertViewDelegate,ADActionSheetDelegate,ADInputBarDelegate,ADFailLoadingDelegate>
{
    //评论以及回复的输入框
    ADInputBar *_myInputBar;
}

@property(nonatomic,strong)ADMomContentInfo *contentModel;
@property(nonatomic,copy) NSString *contentId;
@property (nonatomic,strong) UITableView *myCommentTableView;

@property(nonatomic,copy) NSString *aChannelId;
@property(nonatomic,copy) NSString *aIndex;
@property(nonatomic,copy) NSString *aAdId;
@property(nonatomic,strong) NSString *commentCount;
@property(nonatomic,copy) NSString *shareUrl;

@property (nonatomic,strong) ADEmptyView *emptyView;

@property(nonatomic,retain) ADFailLodingView *failLoadingView;
@property(nonatomic,retain) ADLoadingView *customLoadingView;


@end
