//
//  UINavigationItem+CustomItem.h
//  BaseProject
//
//  Created by tyl on 2017/4/24.
//  Copyright © 2017年 tyl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BACustomBarItem.h"
@interface UINavigationItem (CustomItem)

- (BACustomBarItem *)setItemWithTitle:(NSString *)title textColor:(UIColor *)color fontSize:(CGFloat)font itemType:(ItemType)type;

- (BACustomBarItem *)setItemWithImage:(NSString *)imageName highImage:(NSString *)highImage size:(CGSize)size type:(ItemType)type;

- (BACustomBarItem *)setItemWithCustomView:(UIView *)customView itemType:(ItemType)type;

@end
