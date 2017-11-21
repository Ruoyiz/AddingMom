//
//  ADVaccineDetailViewController.h
//  PregnantAssistant
//
//  Created by chengfeng on 15/6/5.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADBaseViewController.h"
#import "ADVaccineTableViewCell.h"
#import "ADSetVaccineNotePicker.h"

@interface ADVaccineDetailViewController : ADBaseViewController<VaccineCellDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) ADVaccine *vaccineModel;

@property (nonatomic,strong) NSString *cellType;

@end
