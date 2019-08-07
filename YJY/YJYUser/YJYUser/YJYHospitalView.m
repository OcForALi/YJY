

//
//  YJYHospitalView.m
//  YJYUser
//
//  Created by wusonghe on 2017/3/14.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYHospitalView.h"

#define kHospitalActionViewH 200


@interface YJYHospitalView ()<UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) NSMutableArray *hospitals;

@property (weak, nonatomic) IBOutlet UIView *actionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@end

@implementation YJYHospitalView

- (void)awakeFromNib {

    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - keyboard 

- (void)keyboardWillShow:(NSNotification *)notification {

}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.hospitals.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = @"";
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

@end
