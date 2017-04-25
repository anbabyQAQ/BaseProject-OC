//
//  UINavigationItem+CustomItem.m
//  BaseProject
//
//  Created by tyl on 2017/4/24.
//  Copyright © 2017年 tyl. All rights reserved.
//

#import "UINavigationItem+CustomItem.h"

@implementation UINavigationItem (CustomItem)

- (BACustomBarItem *)setItemWithTitle:(NSString *)title textColor:(UIColor *)color fontSize:(CGFloat)font itemType:(ItemType)type
{
    BACustomBarItem *item = [BACustomBarItem itemWithTitle:title textColor:color fontSize:font itemType:type];
    [item setItemWithNavigationItem:self itemType:type];
    return item;
}

- (BACustomBarItem *)setItemWithImage:(NSString *)imageName highImage:(NSString *)highImage size:(CGSize)size type:(ItemType)type
{
    BACustomBarItem *item = [BACustomBarItem itemWithImage:imageName highImage:highImage size:size type:type];
    [item setItemWithNavigationItem:self itemType:type];
    return item;
}

- (BACustomBarItem *)setItemWithCustomView:(UIView *)customView itemType:(ItemType)type
{
    BACustomBarItem *item = [BACustomBarItem itemWithCustomeView:customView type:type];
    [item setItemWithNavigationItem:self itemType:type];
    return item;
}
@end
