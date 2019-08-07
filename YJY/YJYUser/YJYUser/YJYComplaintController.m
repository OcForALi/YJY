//
//  YJYComplaintController.m
//  YJYUser
//
//  Created by wusonghe on 2017/3/9.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYComplaintController.h"

@interface YJYComplaintCell: UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *packageLabel;

@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@end

@implementation YJYComplaintCell

@end


@interface YJYComplaintController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *otherTextField;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@property (weak, nonatomic) IBOutlet UIButton *workNotSeriousButton;
@property (weak, nonatomic) IBOutlet UIButton *workNotFinishButton;
@property (weak, nonatomic) IBOutlet UIButton *drawbackButton;



@property (strong, nonatomic) NSMutableArray *orders;
@property (strong, nonatomic) NSArray *originOrders;
@property (assign, nonatomic) BOOL isExpand;
@end

@implementation YJYComplaintController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYComplaintController *)[UIStoryboard storyboardWithName:@"YJYSetting" viewControllerIdentifier:NSStringFromClass(self)];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    self.title = @"投诉建议";

    
    self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
    
    

    self.originOrders = @[@"0",@"0"];
    self.orders = [NSMutableArray array];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (IBAction)complaintOptionSelectAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
}
- (IBAction)expandAction:(id)sender {
    
    
    if (!self.isExpand) {

        self.orders = [NSMutableArray arrayWithArray:self.originOrders];

    }else {
        
        self.orders = [NSMutableArray array];

    }
    
    self.arrowImageView.transform = self.isExpand ?  CGAffineTransformIdentity : CGAffineTransformMakeRotation(M_PI);

    self.isExpand = !self.isExpand;

    
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    
}
- (IBAction)comfireAction:(id)sender {

    [SYProgressHUD showSuccessText:@"提交成功"];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.orders.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    YJYComplaintCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YJYComplaintCell"];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 111;
}
#pragma mark - UIKeyboard

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    CGRect keyBoardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (!keyBoardRect.size.height) {
        return;
    }
    
    
    
    [UIView animateWithDuration:animationDuration animations:^{
        
       
        [self.view layoutIfNeeded];
    }];
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    
    [UIView animateWithDuration:animationDuration animations:^{
        
       
        [self.view layoutIfNeeded];
    }];
}

@end
