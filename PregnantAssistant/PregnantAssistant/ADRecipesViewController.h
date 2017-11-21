//
//  ADRecipesViewController.h
//  PregnantAssistant
//
//  Created by D on 14-9-27.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADBaseViewController.h"

@interface ADRecipesViewController : ADBaseViewController

@property (nonatomic, assign) int weekNo;
@property (nonatomic, copy) NSArray *dataArray;
@property (nonatomic, retain) UIScrollView *myScrollView;

@property (nonatomic, assign) float positionY;

@end
