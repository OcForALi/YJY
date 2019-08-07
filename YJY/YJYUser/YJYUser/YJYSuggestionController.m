//
//  YJYSuggestionController.m
//  YJYUser
//
//  Created by wusonghe on 2017/3/3.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYSuggestionController.h"

@interface YJYSuggestionController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *comfireButton;

@end

@implementation YJYSuggestionController

+ (instancetype)instanceWithStoryBoard {

    return (YJYSuggestionController *)[UIStoryboard storyboardWithName:@"YJYSetting" viewControllerIdentifier:NSStringFromClass(self)];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"意见反馈";

    self.textView.tintColor = APPHEXCOLOR;
    self.textView.layer.borderColor = [UIColor colorWithHexString:@"#666666"].CGColor;

}
- (IBAction)comfireAction:(id)sender {
    if (!self.textView.text) {
        return;
    }
    FeedBackReq *req = [FeedBackReq new];
    req.suggestion = self.textView.text;
    
    [YJYNetworkManager requestWithUrlString:APPAddFeedBack message:req controller:self command:APP_COMMAND_AppaddFeedBack success:^(id response) {
        
        [SYProgressHUD showSuccessText:@"提交成功"];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
        
    }];
    
}


@end
