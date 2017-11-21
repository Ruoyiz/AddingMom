//
//  ADActionSheetView.h
//  PregnantAssistant
//
//  Created by chengfeng on 15/4/9.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ADActionSheetView;

@protocol ADActionSheetDelegate <NSObject>

- (void)actionSheet:(ADActionSheetView *)actionSheet clickedCustomButtonAtIndex:(NSNumber *)buttonIndex;

@end

@interface ADActionSheetView : UIView

@property (nonatomic,assign) id <ADActionSheetDelegate> delegate;
@property (nonatomic,strong)NSMutableArray *titleArray;

//@property (nonatomic,assign) NSInteger actionIndex;

- (id)initWithTitleArray:(NSArray *)titleArray cancelTitle:(NSString *)cancelTitle actionSheetTitle:(NSString *)actionSheetTitle;

- (void)show;

@end
