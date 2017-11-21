//
//  ADFeedDetailsViewController.h
//  PregnantAssistant
//
//  Created by ruoyi_zhang on 15/6/23.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ADFeedDetailsViewController : ADBaseViewController
@property (nonatomic, strong) NSString *mediaId;
@property (nonatomic, copy) void(^disMissNavBlock)(void);
@end
