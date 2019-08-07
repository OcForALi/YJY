//
//  YJYSuggestionController.m
//  YJYNurse
//
//  Created by wusonghe on 2017/7/9.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYSuggestionController.h"
#import "YJYSuggestListController.h"

@interface YJYSuggestionController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *limitLabel;

@end

@implementation YJYSuggestionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)confirmAction:(id)sender {
    
    NSInteger length = self.textView.text.length;
    if (length>500) {
        [SYProgressHUD showInfoText:@"超过字数了"];
        return;
    }

    [SYProgressHUD show];
    
    FeedBackReq *req = [FeedBackReq new];
    req.suggestion = self.textView.text;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPAddFeedBack message:req controller:self command:APP_COMMAND_SaasappaddFeedBack success:^(id response) {
    
        
        [self.navigationController popViewControllerAnimated:YES];
        [SYProgressHUD showSuccessText:@"提交成功"];
        
    } failure:^(NSError *error) {
        
    }];
    
}
- (IBAction)toList {
    
    YJYSuggestListController *vc = [YJYSuggestListController instanceWithStoryBoard];
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)textViewDidChange:(UITextView *)textView {
    
    NSInteger length = textView.text.length;

    
    if ([textView isFirstResponder] && length > 500) {
        self.textView.text = [self.textView.text substringToIndex:500];
        return;
    }else {
        
        self.limitLabel.text = [NSString stringWithFormat:@"%@/%@",@(length),@(500)];

    }
    
    
    self.limitLabel.textColor = length > 500 ? APPREDCOLOR : APPHEXCOLOR;
    
    
}


@end
