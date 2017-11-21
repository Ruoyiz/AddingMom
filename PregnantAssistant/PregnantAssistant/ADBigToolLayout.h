//
//  ADBigToolLayout.h
//  PregnantAssistant
//
//  Created by ruoyi_zhang on 15/7/30.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADBigToolLayout : UICollectionViewLayout{

    float x;
    float leftY;
    float rightY;
    float YY;
    
}

@property float itemWidth;
@property (nonatomic, assign) NSInteger cellCount;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGPoint center;

@property (nonatomic, strong) NSMutableArray* allItemAttributes;

@property (nonatomic, assign) UIEdgeInsets sectionInset;

@property (nonatomic, assign) BOOL orientation;


@end
