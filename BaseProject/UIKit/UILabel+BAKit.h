//
//  UILabel+BAKit.h
//  BaseProject
//
//  Created by tyl on 2017/4/25.
//  Copyright © 2017年 tyl. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "UIFont+BAKit.h"
/**
 *  给UILabel类添加许多有用的方法
 */
@interface UILabel (STKit)

/**
 *  初始化UILael
 */
+ (UILabel *)initWithFrame:(CGRect)frame                // 结构
                      text:(NSString *)text             // 标题
                      font:(FontName)fontName           // 字体
                      size:(CGFloat)size                // 尺寸
                     color:(UIColor *)color             // 颜色
                 alignment:(NSTextAlignment)alignment   // 对齐方式
                     lines:(NSInteger)lines;            // 行数

/**
 *  初始化UILael
 */
+ (UILabel *)initWithFrame:(CGRect)frame                // 结构
                      text:(NSString *)text             // 标题
                      font:(FontName)fontName           // 字体
                      size:(CGFloat)size                // 尺寸
                     color:(UIColor *)color             // 颜色
                 alignment:(NSTextAlignment)alignment   // 对齐方式
                     lines:(NSInteger)lines             // 行数
               shadowColor:(UIColor *)colorShadow;      // 阴影颜色

/**
 *  Remove the commment to this line if you want to use an UILabel to show the progress of an operation in AFNetworking
 */
//- (void)setProgressWithUploadProgressOfOperation:(AFURLConnectionOperation *)operation;
@end
