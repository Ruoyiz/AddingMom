//
//  ADAllToolViewController.h
//  PregnantAssistant
//
//  Created by D on 15/3/19.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "ADBaseViewController.h"

@interface ADAllToolViewController : ADBaseViewController <
UICollectionViewDelegate,
UICollectionViewDataSource
>

@property (nonatomic, retain) UIScrollView *bgScrollView;

@property (nonatomic, copy) NSArray *titleArray;

@property (nonatomic, copy) NSArray *iconArray;

@property (nonatomic, retain) NSMutableArray *collectionViewArray;

@property (nonatomic, retain) NSMutableArray *favArray;
@property (weak, nonatomic) IBOutlet UILabel *toastTitle;
@property (weak, nonatomic) IBOutlet UIImageView *toastImageView;
@property (strong, nonatomic) IBOutlet UIView *toastBar;

@end
