//
//  ADCanNotEatBtn.h
//  PregnantAssistant
//
//  Created by D on 15/3/24.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADCanNotEatBtn : UIButton

- (id)initWithFrame:(CGRect)frame
           andTitle:(NSString *)aTitle
         andImgName:(NSString *)aImgName;

@property (nonatomic, copy) NSString *titleStr;

@end
