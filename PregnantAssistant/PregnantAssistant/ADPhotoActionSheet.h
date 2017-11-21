//
//  ADPhotoActionSheet.h
//  PregnantAssistant
//
//  Created by ruoyi_zhang on 15/7/10.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ADPhotoActionSheet;
@protocol photoActionSheetClickedDelegate <NSObject>
- (void)photoActionSheetClicked:(ADPhotoActionSheet *)photoActionSheet atIndex:(NSInteger)index;
@end


@interface ADPhotoActionSheet : UIView
@property (nonatomic, assign) id<photoActionSheetClickedDelegate> deletege;
- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray;
- (void)show;
- (void)hide;
@end
