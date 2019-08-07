//
//  YJYViewController.m
//  YJYUser
//
//  Created by wusonghe on 2017/4/11.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYViewController.h"

@interface YJYViewController ()

@end

@implementation YJYViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *backIetm = [[UIBarButtonItem alloc] init];
    backIetm.title = @"";
    self.navigationItem.backBarButtonItem = backIetm;
}

- (void)viewSafeAreaInsetsDidChange {
    
    [super viewSafeAreaInsetsDidChange];
    if (@available(iOS 11.0, *)) {
        self.additionalSafeAreaInsets = UIEdgeInsetsMake(20, 0, 0, 0);
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self navigationBarNotAlphaWithBlackTint];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
+ (instancetype)instanceWithStoryBoard {
    
    return nil;
}

#pragma mark - MDHTMLLabelDelegate

- (void)HTMLLabel:(MDHTMLLabel *)label didSelectLinkWithURL:(NSURL *)URL {
    
    if ([URL.absoluteString containsString:@"tel"]) {
        [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil];
    }else if ([URL.absoluteString containsString:@"http"]) {
        YJYWebController *vc = [YJYWebController new];
        vc.urlString = URL.absoluteString;
        vc.title = @"护理易";
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

@end
