//
//  ADMoreContentVC.h
//  PregnantAssistant
//
//  Created by chengfeng on 15/8/10.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADBaseViewController.h"

@interface ADMoreContentVC : ADBaseViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)NSString *currentKeyword;
@property (nonatomic,assign) BOOL isMedia;

@end
