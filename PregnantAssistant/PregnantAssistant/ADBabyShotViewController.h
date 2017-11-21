//
//  ADBabyShotViewController.h
//  PregnantAssistant
//
//  Created by D on 14/10/31.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADToolRootViewController.h"
#import "SCNavigationController.h"
#import "ADShadowBgView.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "UzysImageCropperViewController.h"
#import "ADShotPhoto.h"
#import "ADShareContent.h"

@interface ADBabyShotViewController : ADToolRootViewController <
UzysImageCropperDelegate,
SCNavigationControllerDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic, retain) SCNavigationController *aShotVc;
@property (nonatomic, retain) UITableView *myTableView;
@property (nonatomic, retain) UIButton *showEgBtn;
//@property (nonatomic, retain) NSMutableArray *allBabyPhotoArray;
@property (nonatomic, retain) UIImageView *emptyImgView;
@property (nonatomic, retain) UIView *lineView;
@property (nonatomic, retain) UIImagePickerController *myPicker;
@property (nonatomic, retain) ALAssetsLibrary *aLibrary;
@property (nonatomic, retain) UzysImageCropperViewController *imgCropperViewController;
@property (nonatomic, retain) UIView *biggerimageBgView;
@property (nonatomic, retain) UIButton *delBtn;
@property (nonatomic, retain) UIButton *shareBtn;

@property (nonatomic, assign) int toDelIndex;
@property (nonatomic, retain) NSURL *toDelUrl;
//@property (nonatomic, retain) NSMutableArray *imgUrlArray;
//@property (nonatomic, retain) NSMutableArray *imgDateArray;

@property (nonatomic, retain) NSDate *selectPicDate;

@property (nonatomic, retain) UIView *exBgView;
@property (nonatomic, retain) UIImageView *shotCommentView;

@property (nonatomic, retain) UIView *sheetView;

@property (nonatomic, retain) RLMResults *allBabyPhotoRLMArray;

@property (nonatomic, retain) NSMutableArray *allBabyPhotoDataArray;

@property (strong, nonatomic) ADShareContent *aShareContent;

@property (strong, nonatomic) UIImageView *biggerImgView;

@property (strong, nonatomic) UIImageView *egImgView;

@end
