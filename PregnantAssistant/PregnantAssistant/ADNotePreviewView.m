//
//  ADNotePreviewView.m
//  PregnantAssistant
//
//  Created by D on 14/11/8.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADNotePreviewView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation ADNotePreviewView

- (id)initWithFrame:(CGRect)frame
            andNote:(NSString *)aNote
        andImgArray:(NSArray *)aImgArray
{
    self = [super initWithFrame:frame];
    if (self) {
        _imgArray = aImgArray;
        _note = aNote;
        [self addScrollView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
            andNote:(NSString *)aNote
     andImgUrlArray:(NSArray *)aImgUrlArray
{
    self = [super initWithFrame:frame];
    if (self) {
        _imgUrlsArray = aImgUrlArray;
        _note = aNote;
        NSLog(@"url: %@ self:%@", _imgUrlsArray, aImgUrlArray);
//        [self addScrollView];
        [self addScrollViewWithUrl];
    }
    return self;
}

- (void)addScrollView
{
    UIScrollView *aScrollView =
    [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:aScrollView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH -40, 20)];
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [UIColor font_Brown];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentLeft;
    
    CGRect textRect = [_note boundingRectWithSize:CGSizeMake(label.frame.size.width, MAXFLOAT)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{NSFontAttributeName:label.font}
                                          context:nil];

    [label setFrame:CGRectMake(10, 4, SCREEN_WIDTH -40, textRect.size.height)];
    label.text = _note;
    [aScrollView addSubview:label];
    
    //add images
    float posPic = label.frame.size.height +12;
    if (_imgArray.count > 0) {
        for (int i = 0; i < _imgArray.count; i++) {
            UIImage *aImg = _imgArray[i];
            float radio = aImg.size.height / aImg.size.width;
            UIImageView *aImgView =
            [[UIImageView alloc]initWithFrame:CGRectMake(10, posPic, SCREEN_WIDTH -40, (SCREEN_WIDTH -40) *radio)];
            aImgView.image = aImg;
            [aScrollView addSubview:aImgView];
            
            posPic += (SCREEN_WIDTH -40) *radio + 12;
        }
    }
    
    aScrollView.contentSize = CGSizeMake(SCREEN_WIDTH -20, posPic +8);
}

- (void)addScrollViewWithUrl
{
    UIScrollView *aScrollView =
    [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:aScrollView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH -40, 20)];
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [UIColor font_Brown];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentLeft;
    
    CGRect textRect = [_note boundingRectWithSize:CGSizeMake(label.frame.size.width, MAXFLOAT)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{NSFontAttributeName:label.font}
                                          context:nil];
    
    [label setFrame:CGRectMake(10, 4, SCREEN_WIDTH -40, textRect.size.height)];
    label.text = _note;
    [aScrollView addSubview:label];
    
    //add images
    __block float posPic = label.frame.size.height +12;
    if (_imgUrlsArray.count > 0) {
        for (int i = 0; i < _imgUrlsArray.count; i++) {
            NSString *aImgUrl = _imgUrlsArray[i];
            NSLog(@"imgUrl:%@", aImgUrl);
            
            UIImageView *aImgView = [[UIImageView alloc]init];
            aImgView.contentMode = UIViewContentModeScaleAspectFill;
            aImgView.clipsToBounds = YES;

            [aImgView sd_setImageWithURL:[NSURL URLWithString:aImgUrl]
                               completed:
             ^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                 if (image) {
                     float radio = image.size.height / image.size.width;
                     NSLog(@"imageheight:%f",(SCREEN_WIDTH -40) *radio);
                     aImgView.frame = CGRectMake(10, posPic, SCREEN_WIDTH -40, (SCREEN_WIDTH -40) *radio);
                     
                     [aScrollView addSubview:aImgView];
                     
                     posPic += (SCREEN_WIDTH -40) *radio + 12;
                     
                     aScrollView.contentSize = CGSizeMake(SCREEN_WIDTH -20, posPic +8);
                 }
             }];

            
//            [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:aImgUrl]
//                                                                options:0
//                                                               progress:
//             ^(NSInteger receivedSize, NSInteger expectedSize) {
//             }
//                                                              completed:
//             ^(UIImage *aImg, NSData *data, NSError *error, BOOL finished) {
//                 if (aImg && finished) {
//                     float radio = aImg.size.height / aImg.size.width;
//                     UIImageView *aImgView =
//                     [[UIImageView alloc]initWithFrame:CGRectMake(10, posPic, SCREEN_WIDTH -40, (SCREEN_WIDTH -40) *radio)];
//                     
//                     aImgView.image = aImg;
//                     [aScrollView addSubview:aImgView];
//                     
//                     posPic += (SCREEN_WIDTH -40) *radio + 12;
//                     
//                     aScrollView.contentSize = CGSizeMake(SCREEN_WIDTH -20, posPic +8);
//                 }
//             }];
        }
    }
    
//    aScrollView.contentSize = CGSizeMake(SCREEN_WIDTH -20, posPic +8);
}

@end
