//
//  ADTimeCheckViewController.h
//  PregnantAssistant
//
//  Created by D on 14-9-19.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADBaseViewController.h"
#import "ADCheckDetial.h"

@interface ADTimeCheckViewController : ADBaseViewController

@property (nonatomic, copy) NSString *time;
@property (nonatomic, assign) int aTime;
@property (nonatomic, retain) ADCheckDetial *aDetial;
@property (nonatomic, copy) NSArray *checkContentArray;

@end
