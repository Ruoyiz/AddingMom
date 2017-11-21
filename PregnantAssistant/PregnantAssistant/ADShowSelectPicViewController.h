//
//  ADShowSelectPicViewController.h
//  PregnantAssistant
//
//  Created by D on 14/11/7.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADSelectPicView.h"
#import "ADShareContent.h"

@interface ADShowSelectPicViewController : UIViewController

@property (nonatomic, retain) NSMutableArray *photoArray;
@property (nonatomic, retain) UIScrollView *myScrollView;
@property (nonatomic, retain) NSMutableArray *photoImgViewArray;

@property (strong, nonatomic) ADShareContent *aShareContent;

@end
