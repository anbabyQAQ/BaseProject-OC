//
//  BAUserModel.h
//  BaseProject
//
//  Created by tyl on 2017/4/27.
//  Copyright © 2017年 tyl. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BAUSERSHARE [BAUserModel sharedBAUserModel]

@interface BAUserModel : NSObject

/*！电话号码 */
@property (nonatomic, copy  ) NSString  *phone;

/*！昵称 */
@property (nonatomic, copy  ) NSString  *nickName;

/*！密码 */
@property (nonatomic, copy  ) NSString  *pwd;

/*！用户识别码：唯一【登录后才有】 */
@property (nonatomic, copy  ) NSString  *userCode; //token

@property (nonatomic, assign) BOOL       isLogin;


+ (BAUserModel *)sharedBAUserModel;

@end
