//
//  YJYLongNurseWebController.m
//  YJYNurse
//
//  Created by wusonghe on 2017/6/16.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYLongNurseWebController.h"

#define kBackAssessHandle @"backAssessHandle"
@interface YJYLongNurseWebController ()<UIWebViewDelegate>

@end

@implementation YJYLongNurseWebController

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//
////    self.webView.backgroundColor = [UIColor blackColor];
////    self.webView.frame = CGRectMake(0, -54, self.view.bounds.size.width, self.view.bounds.size.height + 64);
////
////    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:nil highImage:nil target:nil action:nil];
////    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:0 target:self action:@selector(back)];
//
//
//}
- (void)configureBridge {

    [super configureBridge];

    __weak typeof(self) weakSelf = self;
    [self.bridge registerHandler:kBackAssessHandle handler:^(id data, WVJBResponseCallback responseCallback) {

        responseCallback(nil);
        if (self.didComfire && data) {
            self.didComfire(data);
        }

        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
}
//- (void)viewWillAppear:(BOOL)animated {
//
//    [super viewWillAppear:animated];
//
//    [self navigationBarAlphaWithWhiteTint];
//
//
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//
//    [super viewWillDisappear:animated];
//
//    [self navigationBarNotAlphaWithBlackTint];
//
//}
//
//- (void)back {
//
//    if (self.webView.canGoBack) {
//        [self.webView goBack];
//
//    }else {
//
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//}
//


@end
