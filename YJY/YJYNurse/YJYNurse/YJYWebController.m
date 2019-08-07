//
//  ViewController.m
//  Scaffold
//
//  Created by wusonghe on 2017/2/17.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYWebController.h"

@interface YJYWebController ()<UIWebViewDelegate>

@property (strong, nonatomic) UIBarButtonItem *backItem;
@property (assign, nonatomic) BOOL isLoaded;
@end

@implementation YJYWebController


#define backAssessHandle @"backAssessHandle"
#define callLoginHandler @"callLoginHandler"
#define callLoginAgainHandle @"callLoginAgainHandle"
#define getTitleHandle @"getTitleHandle"
#define insurelifeAssessHandle @"insurelifeAssessHandle"
#define insureqcAssessHandle @"insureqcAssessHandle"
#define insureskillAssessHandle @"insureskillAssessHandle"
#define insureTeachSkillAssessHandle  @"insureTeachSkillAssessHandle"

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    

    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.webView.scrollView.bounces = NO;
    [self.view addSubview:self.webView];
    
    if (!self.hiddenRefresh) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"刷新" style:UIBarButtonItemStyleDone target:self action:@selector(toReload)];

    }
    
    
    self.backItem = [UIBarButtonItem itemWithImage:@"app_back_icon" highImage:@"app_back_icon" target:self action:@selector(back)];
    

//    [(UIButton *)self.backItem.customView setFrame:CGRectMake(0, 0, 40, 40)];
    self.navigationItem.leftBarButtonItem = self.backItem;
    

    
    [SYProgressHUD showToLoadingView:self.webView];


    self.isLoaded = YES;
    [self configureBridge];
    [self loadWebPage:self.webView];


}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    
}
-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];

}
- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];

}


- (void)configureBridge {
    __weak typeof(self) weakSelf = self;

    _bridge = nil;
    
//    [WebViewJavascriptBridge enableLogging];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
    [_bridge setWebViewDelegate:self];
    
    [_bridge registerHandler:callLoginAgainHandle handler:^(id data, WVJBResponseCallback responseCallback) {
        
        
        [weakSelf toLoginAction:nil];
    }];
    
    [_bridge registerHandler:insurelifeAssessHandle handler:^(id data, WVJBResponseCallback responseCallback) {
        
//

        if (self.didDone) {
            self.didDone(data);
            [self.navigationController popViewControllerAnimated:YES];
        }

    }];
    
    [_bridge registerHandler:insureskillAssessHandle handler:^(id data, WVJBResponseCallback responseCallback) {
        
//

        if (self.didDone) {
            self.didDone(data);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
    
    [_bridge registerHandler:insureqcAssessHandle handler:^(id data, WVJBResponseCallback responseCallback) {
        
        responseCallback(nil);
        
        if (self.didDone) {
            self.didDone(data);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
    [_bridge registerHandler:insureTeachSkillAssessHandle handler:^(id data, WVJBResponseCallback responseCallback) {
        
        responseCallback(nil);
        
        if (self.didDone) {
            self.didDone(data);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
    [self.bridge registerHandler:backAssessHandle handler:^(id data, WVJBResponseCallback responseCallback) {
        
        responseCallback(nil);
        if (self.didDone) {
            self.didDone(data);
            [self.navigationController popViewControllerAnimated:YES];
        }
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
   
    
   
    
}

- (void)loadWebPage:(UIWebView*)webView {
    
    
    if ([YJYSettingManager sharedInstance].urlTypeStr.length > 0) {
        NSString *http = [YJYSettingManager sharedInstance].urlTypeStr;
        self.urlString = [self.urlString stringByReplacingOccurrencesOfString:@"http" withString:http];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:self.urlString]];
    [request setValue:[YJYNetworkManager GetYUA] forHTTPHeaderField:@"YUA"];
    if ([KeychainManager getValueWithKey:SID]) {
        [request setValue:[KeychainManager getValueWithKey:SID] forHTTPHeaderField:SID];
    }
    
    [webView loadRequest:request];
    
    [SYProgressHUD showToLoadingView:self.webView];
}



#pragma mark - Action

- (IBAction)toLoginAction:(id)sender {
    

    YJYLoginController *login = [YJYLoginController presentLoginVCWithInVC:self];
    
    login.didSuccessLoginComplete = ^(id response) {
        
        [SYProgressHUD showSuccessText:[KeychainManager getValueWithKey:SID]];
        NSDictionary *sidHash = @{SID:[KeychainManager getValueWithKey:SID]};
        [self.bridge callHandler:callLoginHandler data:sidHash responseCallback:^(id responseData) {
            
        }];
    };
}

- (void)toReload {
    
    if (!self.isLoaded) {
        return;
    }
    
    self.isLoaded  = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self configureBridge];
    [self loadWebPage:self.webView];


}

- (void)webViewDidFinishLoad:(UIWebView *)webView {

    self.navigationItem.rightBarButtonItem.enabled = YES;
    self.isLoaded  = YES;
    [SYProgressHUD hideToLoadingView:self.webView];
    [SYProgressHUD hide];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
    self.isLoaded  = YES;
    [SYProgressHUD hideToLoadingView:self.webView];
    [SYProgressHUD showFailureText:@"加载失败"];

}

- (void)back {
    
    if (self.webView.canGoBack) {
        [self.webView goBack];

    }else {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}




@end
