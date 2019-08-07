//
//  YJYUserAgreementController.m
//  YJYUser
//
//  Created by wusonghe on 2017/3/9.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYUserAgreementController.h"
#import <WebKit/WebKit.h>

@interface YJYUserAgreementController ()<WKNavigationDelegate>

@property (strong, nonatomic) WKWebView *webView;
@end

@implementation YJYUserAgreementController



- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"用户协议";

    
    self.webView = [[NSClassFromString(@"WKWebView") alloc] initWithFrame:self.view.bounds];
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    

    
    [SYProgressHUD showHUDAddedTo:self.view animated:YES];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:kUserAgreement]];
    [self.webView loadRequest:request];

}
- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    [SYProgressHUD hideToLoadingView:self.view];

}
#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    [SYProgressHUD hideToLoadingView:self.view];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
    [SYProgressHUD hideToLoadingView:self.view];


}



@end
