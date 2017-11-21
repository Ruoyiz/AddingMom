//
//  ADNoteCell.h
//  PregnantAssistant
//
//  Created by D on 14-9-22.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADShadowBgView.h"

@interface ADNoteCell : UITableViewCell

@property (nonatomic, retain) UILabel *aNote;
@property (nonatomic, copy) NSString *aNoteStr;
@property (nonatomic, retain) ADShadowBgView *aBg;

@end
