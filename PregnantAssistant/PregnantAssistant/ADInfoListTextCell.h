//
//  ADInfoListTextCell.h
//  PregnantAssistant
//
//  Created by yitu on 15/3/30.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADInfoListTextCell : UITableViewCell
@property(nonatomic,strong)UIImageView *iconImage;//行icon图
@property(nonatomic,strong)UILabel *titleLabel;//cell标题
@property(nonatomic,strong)UILabel *contentLabel;//cell标题
@property(nonatomic,strong)UIImageView *indicateImage;//指示箭头
@property(nonatomic,strong)UILabel *seperatorLine;//分割线
//@property(nonatomic,strong)UIView *seperatorLineTop;//分割线
//@property(nonatomic,strong)UIView *seperatorLineBottom;//分割线
@end
