//
//  BANavigationBar.m
//  BaseProject
//
//  Created by tyl on 2017/4/24.
//  Copyright © 2017年 tyl. All rights reserved.
//

#import "BANavigationBar.h"

@implementation BANavigationBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        for (UIView *view in self.subviews) {
            if([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")])
                self.bgView = view;
        }
    }
    return self;
}

/** 显示导航条背景颜色 */
- (void)BA_showNaviBar
{
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.hidden = NO;
        [self setTranslucent:NO]; // 半透明
    }];
}

/** 隐藏 */
- (void)BA_hiddenNaviBar
{
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.hidden = YES;
        [self setTranslucent:YES]; // 半透明
    }];}

@end
