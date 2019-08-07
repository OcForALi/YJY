//
//  YJYOrderPackageDetailController.m
//  YJYUser
//
//  Created by wusonghe on 2017/4/19.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYOrderPackageDetailController.h"

@interface YJYOrderPackageDetailController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *packageLabel;
@property (weak, nonatomic) IBOutlet UILabel *packagePriceLabel;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation YJYOrderPackageDetailController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYOrderPackageDetailController *)[UIStoryboard storyboardWithName:@"YJYOrderBook" viewControllerIdentifier:NSStringFromClass(self)];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.packageLabel.text = [self.price serviceItem];
    self.packagePriceLabel.text = self.price.priceStr;
    [self.webView loadHTMLString:self.price.description_p baseURL:nil];
}



@end
