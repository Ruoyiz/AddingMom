//
//  ADHeightCurveView.m
//  PregnantAssistant
//
//  Created by 加丁 on 15/6/5.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADHeightCurveView.h"
#import "ADWHDataManager.h"
#import "ADHWCurveTitleView.h"
#import "ADWeightHeightModel.h"

@interface ADHeightCurveView (){
    NSMutableArray *_bigHeightArray;
    NSMutableArray *_lowHeightArray;
    NSMutableArray *_normalHeightArray;
    NSMutableArray *_userHeightDataArray;
    NSMutableArray *_userTimeDateArray;
    
    CGFloat _heightXY;
    CGFloat _weightXY;
    CGRect _myRect;
    
    ADHWCurveTitleView *_curveTitleView;
    UIButton *_popTitleView;
    UIColor *_userCurveColor;
    BOOL _isHeight;
    
    NSString *_imageName;
    
}

@end

@implementation ADHeightCurveView

#define CURVEVIEW_TITLEVIEW_WIDTH 6
#define TOP_LEFT_DISTANCE 40
#define TOP_TOP_DISTANCE 70


- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title YArray:(NSArray *)Yarray XArray:(NSArray *)XArray patterImageName:(NSString *)imageName isHeight:(BOOL)isheight userCurveColor:(UIColor *)userCurveColor
{
    self = [super initWithFrame:frame];
    if (self) {
        _myRect = frame;
        _isHeight = isheight;
        _userCurveColor = userCurveColor;
        _imageName = imageName;
        [self loadData];
        [self layoutTitleAndBottomViewWithFrame:frame title:title];
        [self layoutYLabelWithFrame:_myRect withArray:Yarray];
        [self layoutXLabelWithFrame:_myRect withArray:XArray];
    }
    return self;
}
 
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawXYLineWithContext:context frame:rect];
    [self drawBackgroundImageWithContext:context];
    [self drawUserHeightCurveWithContect:context frame:rect];
    [self drawHeightCurveWithContext:context frame:rect];
    
}

#pragma mark - 填充图片
- (void)drawBackgroundImageWithContext:(CGContextRef)context{
    CGImageRef imageRef = CGImageRetain([UIImage imageNamed:_imageName].CGImage);
    CGRect imageRect;
    imageRect.origin = CGPointMake(TOP_LEFT_DISTANCE,_myRect.size.height - TOP_TOP_DISTANCE);
    imageRect.size = CGSizeMake( _weightXY, _heightXY);
    CGContextClipToRect(context, CGRectMake(TOP_LEFT_DISTANCE,TOP_TOP_DISTANCE - 15 , _myRect.size.width - TOP_LEFT_DISTANCE -30, _myRect.size.height - TOP_TOP_DISTANCE * 2 + 15));
    CGContextDrawTiledImage(context, imageRect, imageRef);
    CGImageRelease(imageRef);
}

#pragma mark - 绘制用户数据曲线

- (void)drawUserHeightCurveWithContect:(CGContextRef)context frame:(CGRect)rect{
    
    CGFloat indexX = TOP_LEFT_DISTANCE;
    CGFloat indexY;
    for (int i = 0; i < _userHeightDataArray.count; i ++) {
        indexX = [self getIndexXWithArrarCount:_userTimeDateArray.count - i - 1];
        indexY = [self getIndexYWithArrarCount:_userHeightDataArray.count - i - 1];
        _curveTitleView  = [[ADHWCurveTitleView alloc] initWithFrame:CGRectMake(indexX - CURVEVIEW_TITLEVIEW_WIDTH/2, indexY - CURVEVIEW_TITLEVIEW_WIDTH/2, CURVEVIEW_TITLEVIEW_WIDTH,CURVEVIEW_TITLEVIEW_WIDTH) radiusOfOutside:0 andCGColor:[UIColor whiteColor] insideRadius:CURVEVIEW_TITLEVIEW_WIDTH/2 andCGColor:_userCurveColor];
        CGContextMoveToPoint(context,  _curveTitleView.center.x, _curveTitleView.center.y);
        _curveTitleView.tag = 100 + _userHeightDataArray.count - i - 1;
        [self addSubview:_curveTitleView];
//        NSLog(@"toptime === %@ height == %@",_userTimeDateArray[_userTimeDateArray.count - i - 2],_userHeightDataArray[_userHeightDataArray.count - i - 2]);
        
        if ([_userHeightDataArray[_userHeightDataArray.count - i - 2] floatValue]) {
            indexX = [self getIndexXWithArrarCount:_userTimeDateArray.count - i - 2];
            indexY = [self getIndexYWithArrarCount:_userHeightDataArray.count - i - 2];
            CGContextAddLineToPoint(context, indexX , indexY);
            [_userCurveColor setStroke];
            CGContextSetLineWidth(context,1.2);
            CGContextDrawPath(context, kCGPathStroke);
        }
    }
}
#pragma mark - 高中低标准曲线
- (void)drawHeightCurveWithContext:(CGContextRef)context frame:(CGRect)rect{
    /*  高曲线 */
    CGFloat indexX = TOP_LEFT_DISTANCE,indexY = rect.size.height - TOP_TOP_DISTANCE + _heightXY*3;
    CGFloat scalY =  _heightXY/10;
    if (!_isHeight) {
        scalY = scalY * 2;
        indexY = rect.size.height - TOP_TOP_DISTANCE;
    }
    CGContextMoveToPoint(context, TOP_LEFT_DISTANCE, rect.size.height - TOP_TOP_DISTANCE);
    for (int i = 0; i < _bigHeightArray.count; i++) {
        CGContextAddLineToPoint(context, indexX,indexY - [_bigHeightArray[i] floatValue]*scalY);
        indexX += _weightXY;
    }
    CGFloat lengths[] = {8, 6};
    CGContextSetLineDash(context, 0, lengths, 2);
    [[UIColor whiteColor]setStroke];
    CGContextDrawPath(context, kCGPathStroke);
    /*  正常标准线 */
    indexX = TOP_LEFT_DISTANCE;
    CGContextMoveToPoint(context, TOP_LEFT_DISTANCE, rect.size.height - TOP_TOP_DISTANCE);
    for (int i = 0; i < _normalHeightArray.count; i++) {
        CGContextAddLineToPoint(context, indexX, indexY - [_normalHeightArray[i] floatValue]*scalY);
        indexX += _weightXY;
    }
    CGContextSetLineDash(context, 0, lengths, 2);
    [[UIColor yellowColor]setStroke];
    CGContextDrawPath(context, kCGPathStroke);
    
    /*   低曲线    */
    indexX = TOP_LEFT_DISTANCE;
    CGContextMoveToPoint(context, TOP_LEFT_DISTANCE, rect.size.height - TOP_TOP_DISTANCE);
    for (int i = 0; i < _lowHeightArray.count; i++) {
        CGContextAddLineToPoint(context, indexX, indexY - [_lowHeightArray[i] floatValue]*scalY);
        indexX += _weightXY;
    }
    CGContextSetLineDash(context, 0, lengths, 2);
    [[UIColor whiteColor]setStroke];
    CGContextDrawPath(context, kCGPathStroke);
    
}

#pragma mark - 绘制XY直线
- (void)drawXYLineWithContext:(CGContextRef)context frame:(CGRect)rect{
    
    CGFloat height = rect.size.height;
    CGFloat width = rect.size.width;

    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, TOP_LEFT_DISTANCE, TOP_TOP_DISTANCE - 20);
    CGPathAddLineToPoint(path, nil,TOP_LEFT_DISTANCE, height - TOP_TOP_DISTANCE);
    CGPathAddLineToPoint(path, nil, width - 10, height - TOP_TOP_DISTANCE);
    CGContextAddPath(context, path);
    CGPathRelease(path);
    //设置上下文状态属性
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1);//笔触颜色
    CGContextSetLineWidth(context, 1);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextDrawPath(context, kCGPathStroke);
}
#pragma mark - 横竖坐标
- (void)layoutXLabelWithFrame:(CGRect)frame withArray:(NSArray *)array{
    _weightXY = (frame.size.width - TOP_LEFT_DISTANCE -30)/(array.count);
    CGFloat indexX = TOP_LEFT_DISTANCE +_weightXY/2;
    for (int i = 0; i < array.count; i ++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(indexX, frame.size.height - TOP_TOP_DISTANCE, _weightXY, 20)];
        indexX += _weightXY;
        label.textColor = [UIColor whiteColor];
        label.text = [NSString stringWithFormat:@"%@个月",array[i]];
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
    }
    
}
- (void)layoutYLabelWithFrame:(CGRect)frame withArray:(NSArray *)array{
    
    _heightXY = (frame.size.height - TOP_TOP_DISTANCE*2 + 15)/(array.count-1);
    CGFloat indexY =frame.size.height - TOP_TOP_DISTANCE - _heightXY/2.0;
    for (int i = 0; i < array.count; i ++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, indexY, TOP_LEFT_DISTANCE*3/4, _heightXY)];
        if (i == 0) {
            label.frame = CGRectMake(0, indexY - 5, TOP_LEFT_DISTANCE*3/4, _heightXY);
        }
        indexY -= _heightXY;
        label.textColor = [UIColor whiteColor];
        label.text = [NSString stringWithFormat:@"%@",array[array.count - i -1]];
        label.textAlignment = NSTextAlignmentRight;
        [self addSubview:label];
    }
}

#pragma mark - 绘制头部底部视图

- (void)layoutTitleAndBottomViewWithFrame:(CGRect)frame title:(NSString *)title{

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 200)/2, 0, 200, TOP_TOP_DISTANCE -10)];
    titleLabel.attributedText = [self getMutableAttributedStringWithString:title];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];

    UIButton *bottomLable = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 200)/2, frame.size.height - 50, 200, 30)];
    [bottomLable setImage:[UIImage imageNamed:@"左"] forState:UIControlStateNormal];
    [bottomLable setImageEdgeInsets:UIEdgeInsetsMake(9, 50, 9, 130)];
    [bottomLable setTitle:@"滑动查看更多" forState:UIControlStateNormal];
    [bottomLable setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    bottomLable.titleLabel.font = [UIFont systemFontOfSize:13];
    bottomLable.alpha = 0.8;
    [self addSubview:bottomLable];
}

#pragma mark - 加载数据
- (void)loadData{
    
    ADAppDelegate *myApp = APP_DELEGATE;
    NSString *babySex = @"boy";
    if (myApp.babySex == ADBabySexGirl) {
        babySex = @"girl";
    }
    
    _bigHeightArray = [NSMutableArray array];
    _normalHeightArray = [NSMutableArray array];
    _lowHeightArray = [NSMutableArray array];
    _userHeightDataArray = [NSMutableArray array];
    _userTimeDateArray = [NSMutableArray array];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"WHData" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    RLMResults *results = [ADWHDataManager readAllModel];
    if (_isHeight) {
        _bigHeightArray = dict[@"height"][babySex][@"bigHeight"];
        _normalHeightArray = dict[@"height"][babySex][@"normalHeight"];
        _lowHeightArray  = dict[@"height"][babySex][@"lowHeight"];
        for (ADWeightHeightModel *model in results) {
            [_userHeightDataArray addObject:model.height];
            [_userTimeDateArray addObject:[NSDate dateWithTimeIntervalSince1970:[model.time doubleValue]]];
        }
    }else{
        _bigHeightArray = dict[@"weight"][babySex][@"bigWeight"];
        _normalHeightArray = dict[@"weight"][babySex][@"normalWeight"];
        _lowHeightArray  = dict[@"weight"][babySex][@"lowWeight"];
        for (ADWeightHeightModel *model in results) {
            [_userHeightDataArray addObject:model.weight];
            [_userTimeDateArray addObject:[NSDate dateWithTimeIntervalSince1970:[model.time doubleValue]]];
        }
    }
}


- (NSInteger)getIndexXWithArrarCount:(NSInteger)arrayIndex{
    CGFloat scalX = 1;
    ADAppDelegate *myApp = APP_DELEGATE;
    NSInteger month = [myApp.babyBirthday distanceMonthToDate:[_userTimeDateArray[arrayIndex] dateByAddingDays:1]];
    NSInteger monthIndex = [self getMonthIndexWithMonth:month];
    scalX = [self getScalYwithMonth:month monthDay:30.0 nowDay:[myApp.babyBirthday distanceBesideMonthDaysToDate:[_userTimeDateArray[arrayIndex] dateByAddingDays:1]]];
    return _weightXY*(scalX + monthIndex)>0?TOP_LEFT_DISTANCE + _weightXY*(scalX + monthIndex):TOP_LEFT_DISTANCE;
//    return  TOP_LEFT_DISTANCE + _weightXY*(scalX + monthIndex);
}

- (NSInteger)getIndexYWithArrarCount:(NSInteger)arrayIndex{
    CGFloat scalY =  _heightXY/10;
    CGFloat height = [_userHeightDataArray[arrayIndex] floatValue];
    if (!_isHeight) {
        scalY *= 2;
        return  _myRect.size.height - TOP_TOP_DISTANCE  - height*scalY;
    }
    return  _myRect.size.height - TOP_TOP_DISTANCE + _heightXY*3 - height*scalY;
    
}



- (NSInteger)getMonthIndexWithMonth:(NSInteger)month{
    
    if (month < 6) {
        return month;
    }else if(month < 12){
        return 6 + (month - 6)/2 ;
    }else if(month < 24){
        return 9 + (month - 12)/3 ;
    }else{
        return 13 +(month - 24)/6;
    }
    
    return 15;
}

- (CGFloat)getScalYwithMonth:(NSInteger)month monthDay:(CGFloat)monthDay nowDay:(CGFloat)nowDay{
    
    if (month < 6) {
        return nowDay/monthDay;
    }else if(month < 12){
        if (month % 2 == 1) {
            return 1/2.0 * (1 + nowDay/monthDay);
        }
        return 1/2.0 * nowDay/monthDay;
    }else if(month < 24){
        if (month % 3 == 1) {
            return 1/3.0 + 1/3.0 * nowDay/month;
        }
        if (month % 3 == 2) {
            return 2/3.0 + 1/3.0 * nowDay/monthDay;
        }
        return 1/3.0 *nowDay/monthDay;
    }
    if (month % 6 == 1) {
        return 1/6.0 * (1 + nowDay/month);
    }else if(month % 6 == 2){
        return 1/6.0 * (2 + nowDay/month);
    }else if(month % 6 == 3){
        return 1/6.0 * (3 + nowDay/month);
    }else if(month % 6 == 4){
        return 1/6.0 * (4 + nowDay/month);
    }else if(month % 6 == 5){
        return 1/6.0 * (5 + nowDay/month);
    }
    
    return 1/6.0 *nowDay/monthDay;
}

- (NSMutableAttributedString *)getMutableAttributedStringWithString:(NSString *)string{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    NSInteger strLenth = string.length;
    [str addAttribute:NSFontAttributeName value:[UIFont parentToolTitleViewDetailHeiFontWithSize:17] range:NSMakeRange(0, 5)];
    [str addAttribute:NSFontAttributeName value:[UIFont parentToolTitleViewDetailHeiFontWithSize:14] range:NSMakeRange(5, strLenth-5)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, strLenth)];
    return str;
}

@end
