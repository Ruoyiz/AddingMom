//
//  ADSettingViewController.h
//  PregnantAssistant
//
//  Created by D on 14-9-16.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADBaseViewController.h"

@interface ADSettingViewController : ADBaseViewController <
UITableViewDataSource,
UITableViewDelegate,
UIAlertViewDelegate
>

@property (nonatomic, copy) NSArray *settingNameArray;
@property (nonatomic, retain) UITableView *myTableView;
@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UIImageView *iconImage;

@property (nonatomic, retain) UIImage *userImg;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *addingToken;

//添加和移除消息的小红点
- (void)showMessageBadge;
- (void)removeMessageBadge;

- (void)logout;

@end
