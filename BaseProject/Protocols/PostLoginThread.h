//
//  PostLoginThread.h
//  BaseProject
//
//  Created by tyl on 2017/4/27.
//  Copyright © 2017年 tyl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostLoginThread : NSObject

+ (id)postLoginDataWithParameters:(NSDictionary *)parameters
                             prev:(void (^)())prev
                          success:(void (^)(id model))success
               unavaliableNetwork:(void (^)())unavaliableNetwork
                          timeout:(void (^)())timeout
                        exception:(void (^)(NSError* error))exception;



@end
