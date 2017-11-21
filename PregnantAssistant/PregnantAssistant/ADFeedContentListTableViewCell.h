//
//  ADFeedContentListTableViewCell.h
//  PregnantAssistant
//
//  Created by ruoyi_zhang on 15/6/19.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADFeedContentListModel.h"
#import "ADNoticeInfo.h"
#import "ADSecrertNoticeinfoModel.h"
@interface ADFeedContentListTableViewCell : UITableViewCell

@property (nonatomic, strong) ADFeedContentListModel *refModel;
@property (nonatomic, strong) ADNoticeInfo *refNoticeModel;
@property (nonatomic, strong) ADSecrertNoticeinfoModel *refSecrertNotiModel;
//@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) BOOL isSeen;
+ (CGFloat)getCellHeightWithModel:(ADFeedContentListModel *)model;
+ (CGFloat)getNoticeCellHeightWithModel:(ADNoticeInfo *)model;
+ (CGFloat)getSecrertCellHeightWithModel:(ADSecrertNoticeinfoModel *)model;
@end
