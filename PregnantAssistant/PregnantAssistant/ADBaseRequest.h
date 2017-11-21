//
//  ADBaseRequest.h
//  
//
//  Created by D on 15/8/7.
//
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface ADBaseRequest : NSObject

@property (nonatomic, retain) AFHTTPRequestOperationManager *manager;

+ (ADBaseRequest *)shareInstance;

- (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(id)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(id)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
