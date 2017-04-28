//
//  PostLoginThread.m
//  BaseProject
//
//  Created by tyl on 2017/4/27.
//  Copyright © 2017年 tyl. All rights reserved.
//

#import "PostLoginThread.h"
#define kRegisterString @"mts-ci/v210/isregister"

#define kPostLoginUrl [[NSString stringWithFormat:@"%@/%@/%@",@"http://118.85.200.78:60008",kRegisterString,@"13311097869"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]

@implementation PostLoginThread

+ (id)postLoginDataWithParameters:(NSDictionary *)parameters
                             prev:(void (^)())prev
                          success:(void (^)(id model))success
               unavaliableNetwork:(void (^)())unavaliableNetwork
                          timeout:(void (^)())timeout
                        exception:(void (^)(NSError* error))exception{
    
    prev();
    
        
        return [BaseNetManager ba_requestWithType:BAHttpRequestTypeGet
                                        urlString:@"http://192.9.100.76:60001/mts-ci/v250/tag/feed/13311097869"
                                       parameters:nil
                               networkStatusBlock:^(BANetworkStatus status) {
                                   unavaliableNetwork();
                               } successBlock:^(id response) {
                                   success(response);
                               } failureBlock:^(NSError *error) {
                                   exception(error);
                               } timeoutBlock:^(NSError *error) {
                                   timeout();
                               } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                               }];

}


@end
