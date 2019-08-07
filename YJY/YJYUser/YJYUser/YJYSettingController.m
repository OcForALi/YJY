//
//  YJYSettingController.m
//  YJYUser
//
//  Created by wusonghe on 2017/3/3.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYSettingController.h"
#import "YJYComplaintController.h"
#import "YJYSuggestionController.h"
#import "YJYUserAgreementController.h"
#import "YJYAboutController.h"

@interface YJYSettingController ()

@property (strong, nonatomic) NSArray *settings;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation YJYSettingController

- (void)viewDidLoad {
    

    [super viewDidLoad];

    self.tableView.tableFooterView = [[UIView alloc]init];
    self.settings = @[@"意见反馈",@"关于我们",@"用户协议"];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.settings.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textColor = APPMiddleGrayCOLOR;
    cell.textLabel.text = self.settings[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *key = self.settings[indexPath.row];
    id vc;
    if ([key isEqualToString:@"意见反馈"]) {
        
        vc = [YJYSuggestionController instanceWithStoryBoard];
        
    }else if ([key isEqualToString:@"用户协议"]) {
        
        vc = [YJYUserAgreementController new];

        
    }else if ([key isEqualToString:@"关于我们"]) {
        
        vc = [YJYAboutController instanceWithStoryBoard];

        
    }
    
    
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}


- (IBAction)quitAction:(id)sender {
    
    
    [UIAlertController showAlertInViewController:self withTitle:@"是否退出登录" message:nil alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"取消" destructiveButtonTitle:@"确认" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [SYProgressHUD show];
            [YJYLoginManager loginOut];
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.navigationController.tabBarController setSelectedIndex:0];
                [self.navigationController popToRootViewControllerAnimated:NO];
                [SYProgressHUD hide];


            });
        }
    }];
    
}





@end
