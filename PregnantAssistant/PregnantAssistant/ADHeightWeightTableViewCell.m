//
//  ADHeightWeightTableViewCell.m
//  WeightDemo
//
//  Created by 加丁 on 15/5/27.
//  Copyright (c) 2015年 加丁. All rights reserved.
//

#import "ADHeightWeightTableViewCell.h"
#import "ADBabyBirthdayCalendar.h"

#define TOP_LEFT_DISTANCE 18
#define TOP_DISTANCE 11
#define TOP_RIGHT_DISTANCE 10
#define BETWEEN_CELL_DISTANCE 0

#define BABYAGE_HEIGHT 16
#define BABYAGE_WEIGHT 110

#define LEFT_HEIGHT_HEIGHT 18
#define LEFT_HEIGHT_WIDTH 95
#define HEIGHT_WIDTH 50

#define COMEND_BODY_BOTTOM 15
#define EDEINT_BUTTON_WIDTH 36

@interface ADHeightWeightTableViewCell (){

    UILabel *_myData;
    UILabel *_myBabyAge;
    UILabel *_myConmendBody;
    UIView *_bgView;
    
    UILabel *_heightLabel;
    UILabel *_weightLabel;
    
    NSInteger _indexY;
    
    NSDate *_cellDate;

}

@end

@implementation ADHeightWeightTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self layoutselfUI];
    }
    return self;
}

- (void)layoutselfUI{
    _imageButton = [[UIButton alloc] init];
    [_imageButton setBackgroundColor:[UIColor clearColor]];
    [self addSubview:_imageButton];
    
    _myData = [[UILabel alloc] init ];
    _myData.textColor =  UIColorFromRGB(0x86828f);
    _myData.font = [UIFont systemFontOfSize:12];
    [self addSubview:_myData];
    
    _myBabyAge = [[UILabel alloc] init];
    _myBabyAge.textColor = UIColorFromRGB(0x86828f);
    _myBabyAge.font = [UIFont systemFontOfSize:12];
    _myBabyAge.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_myBabyAge];
    
    
    _heightLabel = [[UILabel alloc] init];
    [self addSubview:_heightLabel];
    
    _addHeightLabel = [[UILabel alloc] init];
    _addHeightLabel.textAlignment = NSTextAlignmentLeft;
    _addHeightLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_addHeightLabel];
    
    _weightLabel = [[UILabel alloc] init];
    [self addSubview:_weightLabel];
    
    _addWidthLabel = [[UILabel alloc] init];
    _addWidthLabel.textAlignment = NSTextAlignmentLeft;
    _addWidthLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_addWidthLabel];
    
    _myConmendBody = [[UILabel alloc] init];
    _myConmendBody.numberOfLines = 0;
    _myConmendBody.lineBreakMode = NSLineBreakByCharWrapping;
    [self addSubview:_myConmendBody];
    
}

- (void)setRefreshModel:(ADWeightHeightModel *)refreshModel{

    _indexY = 0;
    _height = 0;
    NSDate *mydate = [NSDate dateWithTimeIntervalSince1970:[refreshModel.time doubleValue]];
    _cellDate =mydate;
    
    _imageButton.frame = CGRectMake(SCREEN_WIDTH - BETWEEN_CELL_DISTANCE -EDEINT_BUTTON_WIDTH, _indexY, EDEINT_BUTTON_WIDTH, EDEINT_BUTTON_WIDTH);
    [_imageButton setImage:[UIImage imageNamed:@"EDIT"] forState:UIControlStateNormal];
    //[_imageButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];

    _indexY += BETWEEN_CELL_DISTANCE/2 + TOP_DISTANCE;
    _myData.text = [NSString stringWithFormat:@"%ld.%ld.%ld",(long)mydate.year,(long)mydate.month,(long)mydate.day];
    _myData.frame = CGRectMake(TOP_LEFT_DISTANCE, TOP_DISTANCE, BABYAGE_WEIGHT, 16);
    
    _myBabyAge.text = [self getBabyAgeWithDate:mydate];
    _myBabyAge.frame = CGRectMake(TOP_LEFT_DISTANCE +BABYAGE_WEIGHT - 20 , TOP_DISTANCE, BABYAGE_WEIGHT, 16);
    _indexY += 16;
    _indexY += BETWEEN_CELL_DISTANCE;
    
    NSInteger indexX;
    indexX = TOP_LEFT_DISTANCE;
    _heightLabel.attributedText = [self getMutableAttributedStringWithString:[NSString stringWithFormat:@"身高:%@cm",refreshModel.height ]];
    _heightLabel.frame = CGRectMake(indexX, _indexY, LEFT_HEIGHT_WIDTH, LEFT_HEIGHT_HEIGHT);
    indexX += LEFT_HEIGHT_WIDTH;
    
    _addHeightLabel.frame = CGRectMake(indexX , _indexY, HEIGHT_WIDTH, LEFT_HEIGHT_HEIGHT);
    indexX += HEIGHT_WIDTH;
    
    _weightLabel.attributedText =[self getMutableAttributedStringWithString:[NSString stringWithFormat:@"体重:%@kg",refreshModel.weight]];
    _weightLabel.frame = CGRectMake(indexX, _indexY, LEFT_HEIGHT_WIDTH, LEFT_HEIGHT_HEIGHT);
    indexX += LEFT_HEIGHT_WIDTH - 10;

    _addWidthLabel.frame = CGRectMake(indexX, _indexY, HEIGHT_WIDTH, LEFT_HEIGHT_HEIGHT);
    _indexY += LEFT_HEIGHT_HEIGHT;
    _indexY += BETWEEN_CELL_DISTANCE;
    _myConmendBody.attributedText = [self getMutableAttributedStringWithString:[NSString stringWithFormat:@"评价:%@",[self getCommendBodyWithNormalHeight:refreshModel.height normalWeight:refreshModel.weight]]];
   // CGSize topTextSize = [[self getCommendBodyWithNormalHeight:refreshModel.height normalWeight:refreshModel.weight] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 2*TOP_LEFT_DISTANCE, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    _myConmendBody.frame = CGRectMake(TOP_LEFT_DISTANCE, _indexY,SCREEN_WIDTH - 2*TOP_LEFT_DISTANCE ,40);
//    _indexY += topTextSize.height;
//    _indexY += 15;
//    _height += _indexY;
}
//- (void)setHeightRefreshModel:(ADWeightHeightModel *)heightRefreshModel{
//    //[self getCommendBodyWithNormalHeight:heightRefreshModel.height normalWeight:heightRefreshModel.weight]
//    CGSize topTextSize = [@"宝宝长得足够高，但身体体重低于最低值，速找原因来改善" boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 2*TOP_LEFT_DISTANCE, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
//    _myConmendBody.frame = CGRectMake(TOP_LEFT_DISTANCE, _indexY,SCREEN_WIDTH - 2*TOP_LEFT_DISTANCE ,topTextSize.height);
//    _height = 45 + topTextSize.height;
//    _height += 15;
////    _indexY += topTextSize.height;
////    _indexY += 15;
////    _height += _indexY;
//
//}

- (NSString *)getBabyAgeWithDate:(NSDate *)date{
    ADAppDelegate *myapp = APP_DELEGATE;
    if ([date isEarlierThanDate:[myapp.babyBirthday dateByAddingDays:-1]]) {
        return @"宝宝还未出生";
    }
    ADBabyBirthdayCalendar *bc = [[ADBabyBirthdayCalendar alloc] initWithBirthdayDate:myapp.babyBirthday endDaysDate:date];
    if (bc.years) {
        if (bc.month) {
            if (bc.days) {
                return [NSString stringWithFormat:@"宝宝%ld岁%ld个月%ld天",(long)bc.years,(long)bc.month,(long)bc.days];
            }else{
                return [NSString stringWithFormat:@"宝宝%ld岁%ld个月",(long)bc.years,(long)bc.month];
            }
        }else{
            if (bc.days) {
                return [NSString stringWithFormat:@"宝宝%ld岁%ld天",(long)bc.years,(long)bc.days];
            }else{
                return [NSString stringWithFormat:@"宝宝%ld岁",(long)bc.years];
            }
        }
    }
    if (bc.month) {
        if (bc.days) {
            return [NSString stringWithFormat:@"宝宝%ld个月%ld天",(long)bc.month,(long)bc.days];
        }else{
            return [NSString stringWithFormat:@"宝宝%ld个月",(long)bc.month];
        }
    }
    return [NSString stringWithFormat:@"宝宝%ld天",(long)bc.days];
}
- (NSString *)getCommendBodyWithNormalHeight:(NSString *)normalHeight normalWeight:(NSString *)normalWeight{
    
    NSString *babySex = @"boy";
    ADAppDelegate *myApp = APP_DELEGATE;
    if (myApp.babySex == ADBabySexBoy) {
        babySex = @"boy";
    }else if(myApp.babySex == ADBabySexGirl){
        babySex = @"girl";
    }
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"WHData" ofType:@"plist"];
    NSDictionary *commendDict  = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSArray *commendArray =  commendDict[@"command"];
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSMonthCalendarUnit|NSDayCalendarUnit fromDate:myApp.babyBirthday toDate:[_cellDate dateByAddingDays:1] options:0];

    NSInteger month = components.month;
    NSInteger day = components.day;
    NSInteger monthIndex = [self getMonthIndexWithMonth:month];
    CGFloat lowHeight,bigHeight,lowWeight,bigWeight;
    CGFloat lowHeight1 = 0.0,bigHeight1 = 0.0,lowWeight1 = 0.0,bigWeight1 = 0.0;
    lowWeight = [commendDict[@"weight"][babySex][@"lowWeight"][monthIndex] floatValue];
    bigWeight = [commendDict[@"weight"][babySex][@"bigWeight"][monthIndex] floatValue];
    lowHeight = [commendDict[@"height"][babySex][@"lowHeight"][monthIndex] floatValue];
    bigHeight = [commendDict[@"height"][babySex][@"bigHeight"][monthIndex] floatValue];

    if (monthIndex < 15) {
        lowWeight1 = [commendDict[@"weight"][babySex][@"lowWeight"][monthIndex + 1] floatValue];
        bigWeight1 = [commendDict[@"weight"][babySex][@"bigWeight"][monthIndex + 1] floatValue];
        lowHeight1 = [commendDict[@"height"][babySex][@"lowHeight"][monthIndex + 1] floatValue];
        bigHeight1 = [commendDict[@"height"][babySex][@"bigHeight"][monthIndex + 1] floatValue];
    }
    
    if (month < 6) {
        lowWeight += (lowWeight1 - lowWeight) * day/30.0;
        bigWeight += (bigWeight1 - bigWeight) * day/30.0;
        lowHeight += (lowHeight1 - lowHeight) * day/30.0;
        bigHeight += (bigHeight1 - bigHeight) * day/30.0;
    }else if(month < 12){
        lowWeight += (lowWeight1 - lowWeight) * day/60.0;
        bigWeight += (bigWeight1 - bigWeight) * day/60.0;
        lowHeight += (lowHeight1 - lowHeight) * day/60.0;
        bigHeight += (bigHeight1 - bigHeight) * day/60.0;
        if (month%2 == 1) {
            lowHeight += (lowHeight1 - lowHeight)/2.0;
            bigHeight += (bigHeight1 - bigHeight)/2.0;
            lowWeight += (lowWeight1 - lowWeight)/2.0;
            bigWeight += (bigWeight1 - bigWeight)/2.0;
        }

    }else if(month < 24){
        lowWeight += (lowWeight1 - lowWeight) * day/90.0;
        bigWeight += (bigWeight1 - bigWeight) * day/90.0;
        lowHeight += (lowHeight1 - lowHeight) * day/90.0;
        bigHeight += (bigHeight1 - bigHeight) * day/90.0;
        if (month % 3) {
            lowHeight += (lowHeight1 - lowHeight)/(3/(float)(month % 3));
            bigHeight += (bigHeight1 - bigHeight)/(3/(float)(month % 3));
            lowWeight += (lowWeight1 - lowWeight)/(3/(float)(month % 3));
            bigWeight += (bigWeight1 - bigWeight)/(3/(float)(month % 3));
        }
    }else{
        if (lowHeight1 > lowHeight) {
            lowWeight += (lowWeight1 - lowWeight) * day/180.0;
            bigWeight += (bigWeight1 - bigWeight) * day/180.0;
            lowHeight += (lowHeight1 - lowHeight) * day/180.0;
            bigHeight += (bigHeight1 - bigHeight) * day/ 180.0;
        }
        if (month % 6) {
            lowHeight += (lowHeight1 - lowHeight)/(6/(float)(month % 6));
            bigHeight += (bigHeight1 - bigHeight)/(6/(float)(month % 6));
            lowWeight += (lowWeight1 - lowWeight)/(6/(float)(month % 6));
            bigWeight += (bigWeight1 - bigWeight)/(6/(float)(month % 6));
        }
    }
    NSInteger comendbodyIndex = [self getCommendBodyTextIndexWithLowHeight:lowHeight bigHeight:bigHeight lowWeight:lowWeight bigWeight:bigWeight nomalHeight:[normalHeight floatValue] normalWeight:[normalWeight floatValue]];
//    NSLog(@"month == %d,day == %d,monthIndex == %d",month,day,monthIndex);
//    NSLog(@"normalHeight == %f,lowHeight == %f,bigHeight === %f",[normalHeight floatValue],lowHeight,bigHeight);
    return commendArray[comendbodyIndex];
}
#pragma mark 取得评论数据index
- (NSInteger)getCommendBodyTextIndexWithLowHeight:(CGFloat)lowHeight bigHeight:(CGFloat)bigHeight lowWeight:(CGFloat)lowWeight bigWeight:(CGFloat)bigWeight nomalHeight:(CGFloat)nowHeight normalWeight:(CGFloat)nowWeight{
    if (nowHeight <= lowHeight) {
        if (nowWeight <= lowWeight) {
            return 0;
        }else if(nowWeight <= lowWeight*1.05){
            return 1;
        }else if(nowWeight < bigWeight*0.95){
            return 2;
        }else if(nowWeight < bigWeight){
            return 3;
        }
        return 4;
    }else if(nowHeight <= lowHeight*1.05){
        if (nowWeight <= lowWeight) {
            return 5;
        }else if(nowWeight <= lowWeight*1.05){
            return 6;
        }else if(nowWeight < bigWeight*0.95){
            return 7;
        }else if(nowWeight < bigWeight){
            return 8;
        }
        return 9;
    }else if (nowHeight < bigHeight){
        if (nowWeight <= lowWeight) {
            return 10;
        }else if(nowWeight <= lowWeight*1.05){
            return 11;
        }else if(nowWeight < bigWeight*0.95){
            return 12;
        }else if(nowWeight < bigWeight){
            return 13;
        }
        return 14;
    }
    if (nowWeight <= lowWeight) {
        return 15;
    }else if(nowWeight <= lowWeight*1.05){
        return 16;
    }else if(nowWeight < bigWeight*0.95){
        return 17;
    }else if(nowWeight < bigWeight){
        return 18;
    }
    return 19;
    
}
#pragma mark - 获取第几周
- (NSInteger)getMonthIndexWithMonth:(NSInteger)month{
    if (month < 0) {
        return 0;
    }
    if (month <= 6) {
        return month;
    }else if(month <= 12){
        return 6 + (month - 6)/2;
    }else if(month <= 24){
        return 9 + (month - 12)/3;
    }else if(month <= 36){
        return 13 + (month - 24)/6;
    }
    return 15;
}

- (NSString *)getDateTextWithDate:(NSDate *)date{

    return [NSString stringWithFormat:@"%ld.%ld.%ld",(long)date.year,(long)date.month,(long)date.day];
}

- (NSMutableAttributedString *)getMutableAttributedStringWithString:(NSString *)string{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    NSInteger strLenth = string.length;
    [str addAttribute:NSFontAttributeName value:[UIFont parentToolTitleViewDetailFontWithSize:15] range:NSMakeRange(0, 3)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(3, strLenth - 3)];
    [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x4d4587) range:NSMakeRange(0, 3)];
    [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x352f44) range:NSMakeRange(3, strLenth - 3)];

    return str;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
