//
//  YJYInsureIntroController.m
//  YJYUser
//
//  Created by wusonghe on 2017/4/14.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYInsureIntroController.h"
#import "YJYInsureApplyController.h"
#import "YJYWeakTimerManager.h"
#import "YJYInsureQuestionController.h"


@interface YJYInsureIntroController ()

@property (assign, nonatomic) NSInteger countDown;
@property (strong, nonatomic) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIButton *applyButton;

@end

@implementation YJYInsureIntroController


+ (instancetype)instanceWithStoryBoard {
    
    return (YJYInsureIntroController *)[UIStoryboard storyboardWithName:@"YJYInsure" viewControllerIdentifier:NSStringFromClass(self)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.webView.frame = CGRectMake(0, 64, self.webView.frame.size.width, self.webView.frame.size.height - 64 - 60);
    self.urlString =  [YJYSettingManager sharedInstance].insureDescURL;

}

- (void)loadTitle:(NSString *)title {
    
    self.title = @"长护险预约申请";

}

- (void)setupTimer {
    
    
    _countDown = 6;
    
    _timer = [YJYWeakTimerManager scheduledTimerWithTimeInterval:1 block:^(id userInfo) {
        
        if (_timer && _countDown == 1 ) {
            [_timer invalidate];
            _timer = nil;
            self.applyButton.enabled = YES;
            [self.applyButton setTitle:@"申 请" forState:UIControlStateNormal];

            return;
        }
        
        _countDown -=1;
        self.applyButton.enabled = NO;
        [self.applyButton setTitle:[NSString stringWithFormat:@"%d 秒",(int)_countDown] forState:UIControlStateDisabled];
        
    } userInfo:nil repeats:YES];
    [_timer fire];

}

- (IBAction)applyAction:(id)sender {
    
    YJYInsureApplyController *vc = [YJYInsureApplyController instanceWithStoryBoard];
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
