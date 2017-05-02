//
//  BAWebViewController.h
//  BaseProject
//
//  Created by tyl on 2017/4/24.
//  Copyright © 2017年 tyl. All rights reserved.
//

#import "BaseViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSObjcDelegate <JSExport>
- (void)call;
- (void)getCall:(NSString *)callString;

@end

@interface BAWebViewController : BaseViewController<JSObjcDelegate>

@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) JSContext *jsContext;

@end
