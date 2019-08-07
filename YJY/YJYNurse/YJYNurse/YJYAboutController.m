//
//  YJYAboutController.m
//  YJYNurse
//
//  Created by wusonghe on 2017/6/8.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYAboutController.h"

@interface YJYAboutController ()
@property (weak, nonatomic) IBOutlet UILabel *verisonLabel;

@end

@implementation YJYAboutController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];

    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];

    NSString *versionTitle = [NSString stringWithFormat:@"版本%@",app_Version];
    self.verisonLabel.text = versionTitle;
    

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self navigationBarAlphaWithWhiteTint];
    
}



- (void)viewWillDisappear:(BOOL)animated {
    
    
    [super viewWillDisappear:animated];
    
     [self navigationBarNotAlphaWithBlackTint];
    
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)toReview:(id)sender {
    
    NSString *url = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@",@"1259828749"];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url] options:@{} completionHandler:^(BOOL success) {
        
    }];
}

@end
