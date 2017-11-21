//
//  ADGestationTitleView.h
//  PregnantAssistant
//
//  Created by ruoyi_zhang on 15/6/18.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol weekIndexChanged <NSObject>
@required
- (void)weekindexChangedToWeek:(NSInteger)weekindex;
@end

@interface ADGestationTitleView : UIView

@property (nonatomic, strong) id<weekIndexChanged>delegate;

- (instancetype)initWithFrame:(CGRect)frame withWeekIndex:(NSInteger)WeekIndex;


@end
