//
//  UIWebView+BAKit.h
//  BaseProject
//
//  Created by tyl on 2017/4/25.
//  Copyright © 2017年 tyl. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  给UIWebView类添加许多有用的方法
 */
@interface UIWebView (BAKit)

/**
 *  移除背景阴影
 */
- (void)removeBackgroundShadow;

/**
 *  加载网页
 */
- (void)loadWebsite:(NSString *)website;

/**
 Set TRUE_END_REPORT to YES to get notified only when the page has *fully* loaded, and not when every single element loads. (still not fully tested). When this is set to NO, it will work exactly like the UIWebViewDelegate. (Default behavior)
 */
#define TRUE_END_REPORT NO

/**
 Load a request and get notified when a web page is loaded successfully or fails to load
 
 @param request NSURLRequest to load
 @param loadedBlock Callback block called when loading is done
 @param failureBlock Callback block called when loading
 
 @return The generated UIWebView
 */
+ (UIWebView *) loadRequest: (NSURLRequest *) request
                     loaded: (void (^)(UIWebView *webView)) loadedBlock
                     failed: (void (^)(UIWebView *webView, NSError *error)) failureBlock;

/**
 Load a request and get notified when a web page is loaded successfully, fails to load, or started to load. Also, set whether or not a certain page should be loaded.
 
 @param request NSURLRequest to load
 @param loadedBlock Callback block called when loading is done
 @param failureBlock Callback block called when loading
 @param loadStartedBlock Callback block called when loading started
 @param shouldLoadBlock Callback block determining whether or not a specific page should be loaded.
 
 @return The generated UIWebView
 */
+ (UIWebView *) loadRequest: (NSURLRequest *) request
                     loaded: (void (^)(UIWebView *webView)) loadedBlock
                     failed: (void (^)(UIWebView *webView, NSError *error)) failureBlock
                loadStarted: (void (^)(UIWebView *webView)) loadStartedBlock
                 shouldLoad: (BOOL (^)(UIWebView *webView, NSURLRequest *request, UIWebViewNavigationType navigationType)) shouldLoadBlock;

/**
 Load a HTML string and get notified when the web page is loaded successfully or failed to load.
 
 @param htmlString NSString containing HTML which should be loaded
 @param loadedBlock Callback block called when loading is done
 @param failureBlock Callback block called when loading
 
 @return The generated UIWebView
 */
+(UIWebView *)loadHTMLString:(NSString *)htmlString
                      loaded:(void (^)(UIWebView *webView))loadedBlock
                      failed:(void (^)(UIWebView *webView, NSError *error))failureBlock;

/**
 Load a HTML string and get notified when the web page is loaded successfully, failed to load or started to load.
 Also set whether or not a certain page should be loaded.
 
 @param htmlString NSString containing HTML which should be loaded.
 @param loadedBlock Callback block called when loading is done
 @param failureBlock Callback block called when loading
 @param loadStartedBlock Callback block called when loading started
 @param shouldLoadBlock Callback block determining whether or not a specific page should be loaded.
 
 @return The generated UIWebView
 */
+(UIWebView *)loadHTMLString:(NSString *)htmlString
                      loaded:(void (^)(UIWebView *))loadedBlock
                      failed:(void (^)(UIWebView *, NSError *))failureBlock
                 loadStarted:(void (^)(UIWebView *webView))loadStartedBlock
                  shouldLoad:(BOOL (^)(UIWebView *webView, NSURLRequest *request, UIWebViewNavigationType navigationType))shouldLoadBlock;

@end
