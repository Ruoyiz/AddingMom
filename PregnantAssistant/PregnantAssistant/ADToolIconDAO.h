//
//  ADToolIconDAO.h
//  
//
//  Created by D on 15/7/15.
//
//

#import <Foundation/Foundation.h>

@interface ADToolIconDAO : NSObject

+ (NSArray *)getRecommandToolsForPreMomAtWeek:(NSInteger)week;
+ (NSArray *)getRecommandToolsForAlreadyMom;
+ (NSArray *)getToolInAllToolTabIsAlreadyMom:(BOOL)isMom;

@end
