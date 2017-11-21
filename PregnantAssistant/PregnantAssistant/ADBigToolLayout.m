//
//  ADBigToolLayout.m
//  PregnantAssistant
//
//  Created by ruoyi_zhang on 15/7/30.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADBigToolLayout.h"

@implementation ADBigToolLayout

- (void)prepareLayout{
    [super prepareLayout];
    self.itemWidth = self.collectionView.bounds.size.width/3.0;
    
    CGSize size = self.collectionView.frame.size;
    self.cellCount = [self.collectionView numberOfItemsInSection:0];
    self.center = CGPointMake(size.width/2.0, size.height/2.0);
    

}

@end
