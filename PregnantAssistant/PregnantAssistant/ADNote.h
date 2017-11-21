//
//  ADNote.h
//  PregnantAssistant
//
//  Created by D on 14/11/4.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADNote : NSObject <NSCoding>

@property (nonatomic, copy) NSString *cellTitle;
@property (nonatomic, copy) NSString *dateLabelStr;
@property (nonatomic, copy) NSString *dueLabelStr;
@property (nonatomic, copy) NSString *note;
@property (nonatomic, retain) NSMutableArray *photoNames;

-(id)initWithCellTitle:(NSString *)aTitle
          dateLabelStr:(NSString *)aDateStr
           dueLabelStr:(NSString *)aDueStr
                  note:(NSString *)aNote
           photosNames:(NSMutableArray *)aPhotoNamesArray;

@end