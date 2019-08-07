//
//  ViewController.h
//  Scaffold
//
//  Created by wusonghe on 2017/2/17.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnullability-completeness"

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "Interface.pbobjc.h"

#import "WKWebViewJavascriptBridge.h"
#import "WebViewJavascriptBridge.h"
#import "YJYNetworkManager.h"
#import "YJYLoginController.h"
#import "YJYShareView.h"

@interface YJYWebController : YJYViewController





@property (copy, nonatomic) NSString *urlString;
@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) WKWebViewJavascriptBridge* bridge;

- (void)configureBridge;
- (void)loadTitle:(NSString *)title;
- (void)toReload;
@end

#pragma clang diagnostic pop

