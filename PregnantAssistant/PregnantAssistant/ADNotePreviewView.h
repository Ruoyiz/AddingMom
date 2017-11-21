//
//  ADNotePreviewView.h
//  PregnantAssistant
//
//  Created by D on 14/11/8.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADNotePreviewView : UIView

@property (nonatomic, copy) NSString *note;
@property (nonatomic, copy) NSArray *imgArray;
@property (nonatomic, copy) NSArray *imgUrlsArray;

- (id)initWithFrame:(CGRect)frame
            andNote:(NSString *)aNote
        andImgArray:(NSArray *)aImgArray;

- (id)initWithFrame:(CGRect)frame
            andNote:(NSString *)aNote
     andImgUrlArray:(NSArray *)aImgUrlArray;

@end
