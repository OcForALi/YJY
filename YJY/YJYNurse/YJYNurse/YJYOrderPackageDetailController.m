//
//  YJYOrderPackageDetailController.m
//  YJYUser
//
//  Created by wusonghe on 2017/4/19.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYOrderPackageDetailController.h"

@interface YJYOrderPackageDetailController ()
@property (weak, nonatomic) IBOutlet UILabel *packageLabel;
@property (weak, nonatomic) IBOutlet UILabel *packagePriceLabel;
@property (weak, nonatomic) IBOutlet UITextView *packageDesTextView;

@end

@implementation YJYOrderPackageDetailController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYOrderPackageDetailController *)[UIStoryboard storyboardWithName:@"YJYOrderBook" viewControllerIdentifier:NSStringFromClass(self)];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.packageLabel.text = [self.price serviceItem];
    self.packagePriceLabel.text = self.price.priceStr;
    self.packageDesTextView.text = self.price.description_p;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
