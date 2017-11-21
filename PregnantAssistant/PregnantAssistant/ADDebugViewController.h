//
//  ADDebugViewController.h
//  PregnantAssistant
//
//  Created by D on 15/4/20.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADDebugViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, copy) NSArray *syncItemNameArray;
@property (nonatomic, retain) NSMutableArray *sTimeArray;
@property (nonatomic, retain) NSMutableArray *cTimeArray;

@end
