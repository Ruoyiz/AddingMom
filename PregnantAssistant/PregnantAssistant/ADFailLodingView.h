//
//  ADFailLodingView.h
//  PregnantAssistant
//
//  Created by D on 15/4/9.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADFailLoadingDelegate <NSObject>

- (void)emptyAreaTaped;

@end

@interface ADFailLodingView : UIView

@property (nonatomic,assign) id <ADFailLoadingDelegate> delegate;

-(instancetype)initWithFrame:(CGRect)frame tapBlock:(void (^) (void))tapActionBlock;

- (void)showInView:(UIView *)view;

- (void)reloadAction;

@end
