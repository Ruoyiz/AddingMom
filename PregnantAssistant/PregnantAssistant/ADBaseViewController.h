//
//  ADBaseViewController.h
//  PregnantAssistant
//
//  Created by D on 14-9-15.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADAppDelegate.h"

@interface ADBaseViewController : UIViewController

//@property (assign, nonatomic) BOOL     reachable;
@property (nonatomic, retain) UINavigationBar *selfNavBar;
@property (nonatomic, retain) UINavigationItem *selfNaviItem;

@property (nonatomic, copy) NSString *myTitle;

@property (nonatomic, strong) ADAppDelegate *appDelegate;
//@property (nonatomic, strong) UIButton *louzhuButton;
@property (nonatomic, retain) UIButton *collectBtn;
@property (nonatomic, strong) UIButton *syncBtn;

@property (nonatomic, retain) UIView *loginView;

- (void)setLeftBackItemWithImage:(UIImage *)aImage
                  andSelectImage:(UIImage *)sImage;
- (void)setRightItemWithImage:(UIImage *)aImage andSelectImage:(UIImage *)sImage;

- (void)setRightItemWithTxt:(NSString *)aStr andColor:(UIColor *)aColor;
- (void)setRightItemWithStrEdit;
- (void)setRightItemWithImgCollect;
//- (void)setRightItemWithImgSystemRecommend;
- (void)setRightItemWithImgFav;

- (void)setRightItemWithStrDone;

//- (void)setRightItemWithShareAndLookBtn;

- (void)setRightItemWithStrPublish;

//- (void)setRightItemCollectAndShare;

- (void)setRightItemWithImgCollectAndSync;

- (void)setRightItemSecertShare;

- (void)setRightItemWithAddHeightWeight;

- (void)setStyleNaviWithTitle:(NSString *)aTitle
                     andTrans:(BOOL)trans
                   andBgColor:(UIColor *)aBgColor
                andTitleColor:(UIColor *)aTitleColor;

//设置导航的自定义titleView居中
- (void)setADCustomTitleViewWithTitle:(NSString *)title;
- (void)leftItemMethod;

- (void)setZFLeftBackItemWithImage:(UIImage *)aImage
                    andSelectImage:(UIImage *)sImage;


- (void)rotateSyncBtn;
- (void)stopRotateSyncBtn;
- (void)setNeedUploadBtn;
- (void)syncMethod:(UIButton *)sender;

- (void)addLoginBtnIsSecert:(BOOL)isSecert;

@end