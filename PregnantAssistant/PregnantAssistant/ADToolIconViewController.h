//
//  ADToolIconViewController.h
//  PregnantAssistant
//
//  Created by D on 15/3/18.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "ADBaseViewController.h"
#import "ADPopEditView.h"
#import "ADToolBabyTitleView.h"
#import "ADShadowView.h"
#import "ADCollectToolDAO.h"

@interface ADToolIconViewController : ADBaseViewController <
UITableViewDelegate,
UITableViewDataSource,
UICollectionViewDelegate,
UICollectionViewDataSource
>

@property (weak, nonatomic) IBOutlet UILabel *myBarTitle;
@property (strong, nonatomic) UIScrollView *myScrollView;
@property (weak, nonatomic) IBOutlet UIView *myToolBar;

@property (strong, nonatomic) ADPopEditView *aPopView;
@property (nonatomic, retain) UIView *bgView;

@property (nonatomic, retain) NSMutableArray *editToolArray;
@property (nonatomic, retain) NSMutableArray *toRemoveToolArray;

@property (nonatomic, retain) RLMResults *favToolArray;

@property (nonatomic, retain) UICollectionView *myCollectionView;

@property (nonatomic, retain) UIButton *leftBtn;
@property (nonatomic, retain) UIButton *setButton;

@property (nonatomic, retain) UIButton *shadowSetButton;

@property (nonatomic, retain) NSMutableArray *babyData;

@property (nonatomic, retain) ADToolBabyTitleView *aTitleView;

@property (nonatomic, assign) CGFloat collectionViewHeight;

@property (nonatomic, retain) ADShadowView *guideBgView;
@property (nonatomic, retain) UIImageView *tipView;
@property (nonatomic, retain) UIImageView *arrowView;
@property (nonatomic, retain) UILabel *nextLabel;

@property (nonatomic, retain) NSIndexPath *touchIndexPath;

@end
