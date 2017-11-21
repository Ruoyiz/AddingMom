//
//  MyLabel.h
//  TonyRun
//
//  Created by yitu on 14-11-25.
//  Copyright (c) 2014年 addinghome. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    VerticalAlignmentTop=0,//default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
    
}VerticalAlignment;

@interface VerticalAlignmentLabel : UILabel
{
@private
    VerticalAlignment _verticalAlignment;
}

@property(nonatomic,assign)VerticalAlignment verticalAlignment;

@end
