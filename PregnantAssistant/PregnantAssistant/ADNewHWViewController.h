//
//  ADNewHWViewController.h
//  PregnantAssistant
//
//  Created by 加丁 on 15/6/2.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADBaseViewController.h"
@class ADWeightHeightModel;
@interface ADNewHWViewController : ADBaseViewController
@property (nonatomic, assign) BOOL isComefromParentHW;
@property (nonatomic, strong) ADWeightHeightModel *fromParentModel;
@end
