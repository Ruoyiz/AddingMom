//
//  ADWebActionSheetView.h
//  PregnantAssistant
//
//  Created by chengfeng on 15/6/25.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADWebActionSheetDelegate <NSObject>

- (void)clickItemAtIndex:(NSInteger)index;

@end

@interface ADWebActionSheetView : UIView

@property(nonatomic,strong) id <ADWebActionSheetDelegate>delegate;

- (void)show;
- (instancetype)initWithShareTitleArray:(NSArray *)shareTitleArray shareImageArray:(NSArray *)shareImageArray titleArray:(NSArray *)titleArray titleImageArray:(NSArray *)titleImageArray;
@end
