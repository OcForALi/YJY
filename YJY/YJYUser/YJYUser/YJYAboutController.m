//
//  YJYAboutController.m
//  YJYUser
//
//  Created by wusonghe on 2017/3/9.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYAboutController.h"

@interface YJYAboutController ()
@property (weak, nonatomic) IBOutlet UIButton *versionButton;

@end

@implementation YJYAboutController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYAboutController *)[UIStoryboard storyboardWithName:@"YJYSetting" viewControllerIdentifier:NSStringFromClass(self)];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSString *versionTitle = [NSString stringWithFormat:@"%@版本1.5",[BasePre isEqualToString:@"dev"] ? @"测试" : @""];
    [self.versionButton setTitle:versionTitle forState:0];
    
    
   
}

- (IBAction)reviewAction:(id)sender {
}
- (IBAction)aboutAction:(id)sender {
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self navigationBarAlphaWithWhiteTint];
    
//    [self.navigationController.navigationBar lt_setBackgroundColor:kColorAlpha(255, 255, 255, 0)];
//
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

}

- (void)viewWillDisappear:(BOOL)animated {
    
    
    [super viewWillDisappear:animated];
    
    [self navigationBarNotAlphaWithBlackTint];


    
    
}
- (IBAction)toReview:(id)sender {
    
    
    NSString *url = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@",@"1244685890"];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url] options:@{} completionHandler:^(BOOL success) {
        
    }];
}
@end
