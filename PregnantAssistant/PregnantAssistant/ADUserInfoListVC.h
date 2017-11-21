//
//  ADUserInfoListVC.h
//  PregnantAssistant
//
//  Created by yitu on 15/3/30.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADBaseViewController.h"
#import "ADLogoutAlertView.h"

@interface ADUserInfoListVC : ADBaseViewController<UITableViewDataSource,
UITableViewDelegate,
UIAlertViewDelegate
>

//从秘密进入
@property (nonatomic,assign) BOOL fromMonSecret;

@property (nonatomic,assign) BOOL fromLookContent;

@property (nonatomic, copy) NSArray *settingNameArray;
@property (nonatomic, copy) NSArray *contentArray;
@property (nonatomic, retain) UITableView *myTableView;
@property (nonatomic, copy) NSDictionary *resDic;

@end
