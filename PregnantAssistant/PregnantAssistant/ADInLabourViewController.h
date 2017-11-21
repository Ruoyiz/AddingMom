//
//  ADInLabourViewController.h
//  PregnantAssistant
//
//  Created by D on 14-9-17.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADToolRootViewController.h"
#import "ADCustomButton.h"
#import "ADInLabourDAO.h"

@interface ADInLabourViewController : ADToolRootViewController

@property (nonatomic, retain) ADCustomButton *expectantListBtn;
@property (nonatomic, retain) UILabel *tipLabel;
@property (nonatomic, copy) NSArray *buttons;
@property (nonatomic, copy) NSArray *buttonName;
@property (nonatomic, retain) UIScrollView *myScrollView;

@end