//
//  ViewController.h
//  Scaffold
//
//  Created by wusonghe on 2017/2/17.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnullability-completeness"

#import <UIKit/UIKit.h>
#import "Interface.pbobjc.h"

#import "WebViewJavascriptBridge.h"
#import "WKWebViewJavascriptBridge.h"

#import "YJYNetworkManager.h"
#import "YJYLoginController.h"


typedef void(^YJYWebDidDoneBlock)(id result);

@interface YJYWebController : YJYViewController


@property (copy, nonatomic) NSString *urlString;
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) WebViewJavascriptBridge* bridge;
@property (copy, nonatomic) NSString *webTitle;
@property (assign, nonatomic) BOOL hiddenRefresh;
@property (copy, nonatomic) YJYWebDidDoneBlock didDone;


- (void)configureBridge;
- (void)toReload;
@end

#pragma clang diagnostic pop

