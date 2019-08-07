//
//  YJYEditController.m
//  YJYNurse
//
//  Created by wusonghe on 2017/6/8.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYEditController.h"

@interface YJYEditController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation YJYEditController


+ (instancetype)instanceWithStoryBoard {
    
    return (YJYEditController *)[UIStoryboard storyboardWithName:@"YJYEdit" viewControllerIdentifier:NSStringFromClass(self)];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (![self.originString isEqualToString:@"无"]) {
        self.textField.text = self.originString;
    }
    
}
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self.textField becomeFirstResponder];
}
- (IBAction)doneAction:(id)sender {
    
    if (self.didEditBlock && ![self.textField.text isEqualToString:self.originString]) {
        self.didEditBlock(self.textField.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}


@end
