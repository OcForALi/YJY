//
//  LaunchScreenController.m
//  ShareParking
//
//  Created by wusonghe on 2016/12/26.
//  No Comment © 2016年 jb. All rights reserved.
//

#import "YJYLaunchScreenController.h"

@interface YJYLaunchScreenController ()

@end

@implementation YJYLaunchScreenController


+ (instancetype)instanceWithStoryBoard {
    
    return (YJYLaunchScreenController *)[UIStoryboard storyboardWithName:@"YJYLaunch" viewControllerIdentifier:NSStringFromClass(self)];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
