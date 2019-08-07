//
//  ViewController.m
//  Scaffold
//
//  Created by wusonghe on 2017/2/17.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYWebController.h"

@interface YJYWebController ()<WKNavigationDelegate,WKUIDelegate>

@end

@implementation YJYWebController


#define callLoginHandler @"callLoginHandler"
#define callLoginAgainHandle @"callLoginAgainHandle"
#define getTitleHandle  @"getTitleHandle"

- (void)viewDidLoad {
    
    [super viewDidLoad];

    
    self.webView = [[NSClassFromString(@"WKWebView") alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.webView.navigationDelegate = self;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"刷新" style:UIBarButtonItemStyleDone target:self action:@selector(toReload)];

    
    //    [(UIButton *)self.backItem.customView setFrame:CGRectMake(0, 0, 40, 40)];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"app_back_icon" highImage:@"app_back_icon" target:self action:@selector(back)];
    [self.view addSubview:self.webView];
    
//    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
//    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    
    [SYProgressHUD showToLoadingView:self.webView];

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    
}
-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self configureBridge];

}
- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];

}
- (void)dealloc {
    
//    [self.webView removeObserver:self forKeyPath:@"title"];
//    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
 
}

- (void)configureBridge {
    __weak typeof(self) weakSelf = self;

    _bridge = nil;
    
    //    [WebViewJavascriptBridge enableLogging];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
    [_bridge setWebViewDelegate:self];
    
    [_bridge registerHandler:callLoginAgainHandle handler:^(id data, WVJBResponseCallback responseCallback) {
        
        responseCallback(nil);
        
        [weakSelf toLoginAction:nil];
    }];
    
    
    [_bridge callHandler:callLoginHandler data:@{SID:@""} responseCallback:^(id responseData) {
        
    }];
    
    NSDictionary *sidHash = nil;
    if ([KeychainManager getValueWithKey:SID]) {
        sidHash = @{SID:[KeychainManager getValueWithKey:SID]};
    }
    [_bridge callHandler:callLoginHandler data:sidHash responseCallback:^(id responseData) {
        
    }];
    
    [_bridge registerHandler:getTitleHandle handler:^(id data, WVJBResponseCallback responseCallback) {
        
        if (data[@"title"]) {
            
            weakSelf.title = data[@"title"];
            [weakSelf.navigationController.navigationBar sizeToFit];
        }
        
        
    }];
    
   
    
    [self loadWebPage:self.webView];
}

- (void)loadWebPage:(WKWebView*)webView {
//    self.urlString = @"https://www.baidu.com";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:self.urlString]]; //
    [request setValue:[YJYNetworkManager GetYUA] forHTTPHeaderField:@"YUA"];
    if ([KeychainManager getValueWithKey:SID]) {
        [request setValue:[KeychainManager getValueWithKey:SID] forHTTPHeaderField:SID];
    }
    
    [webView loadRequest:request];
    
}
#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    

    [SYProgressHUD hideToLoadingView:self.webView];
    [SYProgressHUD hide];

}
#pragma mark - WKUIDelegate

-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:ac animated:YES completion:nil];
    
}

#pragma mark - Action

- (IBAction)toLoginAction:(id)sender {
    
//    YJYLoginController *login = [YJYLoginController instanceWithStoryBoard];
//    [self presentViewController:login animated:YES completion:nil];
    
    YJYLoginController *login = [YJYLoginController presentLoginVCWithInVC:self];
    
    login.didSuccessLoginComplete = ^(id response) {
        
        [SYProgressHUD showSuccessText:[KeychainManager getValueWithKey:SID]];
        NSDictionary *sidHash = @{SID:[KeychainManager getValueWithKey:SID]};
        [self.bridge callHandler:callLoginHandler data:sidHash responseCallback:^(id responseData) {
            
        }];
    };
}

- (void)toReload {
    
    
    [self configureBridge];
    [SYProgressHUD showToLoadingView:self.webView];
    [self.webView reload];
    
}



#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
   	if ([keyPath isEqualToString:@"title"]) {
        if (object == self.webView) {
//            NSString *title = self.webView.title;
//            [self loadTitle:title];
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
}

- (void)loadTitle:(NSString *)title {
    
    self.title = title;
}

- (void)back {
    
    if (self.webView.canGoBack) {
        [self.webView goBack];
        
    }else {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
