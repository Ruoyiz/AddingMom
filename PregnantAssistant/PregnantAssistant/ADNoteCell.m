//
//  ADNoteCell.m
//  PregnantAssistant
//
//  Created by D on 14-9-22.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADNoteCell.h"

#define LINESPACE 4

@implementation ADNoteCell

-(void)setANoteStr:(NSString *)aNoteStr
{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:aNoteStr];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:LINESPACE];//调整行间距
    
    [attrStr addAttribute:NSParagraphStyleAttributeName
                    value:paragraphStyle
                    range:NSMakeRange(0, [aNoteStr length])];
    
    int height = self.frame.size.height -12;

    // add shadow view
    if (_aBg == nil) {
        _aBg =
        [[ADShadowBgView alloc]initWithFrame:CGRectMake(22, 0, SCREEN_WIDTH -32, height)];
        
        [self addSubview:_aBg];
        
        self.aNote = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH -32 -24, height)];
        
        [_aBg addSubview:self.aNote];
    } else {
        _aBg.frame = CGRectMake(22, 0, SCREEN_WIDTH -32, height);
        _aNote.frame = CGRectMake(12, 0, SCREEN_WIDTH -32 -24, height);
    }

    self.aNote.attributedText = attrStr;
    
    self.aNote.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
    self.aNote.numberOfLines = 3;
    self.aNote.font = [UIFont systemFontOfSize:14];
    self.aNote.backgroundColor = [UIColor clearColor];
    self.aNote.textColor = [UIColor font_Brown];
    
    _aNoteStr = aNoteStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
