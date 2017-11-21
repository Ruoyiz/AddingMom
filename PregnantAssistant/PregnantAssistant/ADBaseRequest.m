//
//  ADBaseRequest.m
//  
//
//  Created by D on 15/8/7.
//
//

#import "ADBaseRequest.h"

@implementation ADBaseRequest

+ (ADBaseRequest *)shareInstance {
    
    static dispatch_once_t onceToken;
    static ADBaseRequest *sharedClient = nil;

    dispatch_once(&onceToken, ^{
        sharedClient = [[ADBaseRequest alloc] init];

        // init Http HEADER
        sharedClient.manager = [AFHTTPRequestOperationManager manager];
        [self setHttpHeaderForManager:sharedClient.manager];
    });
    
    return sharedClient;
}

+ (void)setHttpHeaderForManager:(AFHTTPRequestOperationManager *)manager
{
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"idfv=%@;uidenc=%@",[ADHelper getIdfv], [ADHelper getUId]]
                     forHTTPHeaderField:@"Cookie"];
    NSString *newUserAgent =
    [NSString stringWithFormat:@"PregnantAssistant/%@ iOS/%@", [ADHelper getVersion],[ADHelper getIOSVersion]];
    
    [manager.requestSerializer setValue:newUserAgent
                     forHTTPHeaderField:@"User-Agent"];
}

- (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(id)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    return [self.manager POST:URLString parameters:parameters success:success failure:failure];
}

- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(id)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    return [self.manager POST:URLString parameters:parameters success:success failure:failure];
}
@end
