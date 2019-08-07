//
//  YJYActionSheet.m
//  YJYNurse
//
//  Created by wusonghe on 2018/1/24.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYActionSheet.h"
#import "YJYActionSheetCell.h"

#pragma mark - YJYActionSheet

@interface YJYActionSheet()<UITableViewDelegate,UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UIView *actionView;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *comfireButton;


@property (assign, nonatomic) NSInteger selectedIndex;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *actionH;

@end

@implementation YJYActionSheet

+ (instancetype)instancetypeWithXIBWithDatasource:(NSMutableArray *)datasource withTitle:(NSString *)title{
    
    YJYActionSheet *sheet = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]firstObject];
    sheet.datasource = [NSMutableArray array];
    sheet.datasource = datasource;
    sheet.titleLabel.text = title;
    sheet.actionH.constant = [sheet cellHeight];

    return sheet;

}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectedIndex = -1;
    [self.tableView registerNib:[UINib nibWithNibName:@"YJYActionSheetCell" bundle:nil] forCellReuseIdentifier:@"YJYActionSheetCell"];
    self.tableView.separatorColor = APPSaasF4Color;
    

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.datasource.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    YJYActionSheetCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YJYActionSheetCell"];
    id item  = self.datasource[indexPath.row];
    if ([item isKindOfClass:[HgVO class]]) {
        cell.titleLabel.text = [(HgVO *)item fullName];
    }else {
        
        cell.titleLabel.text = item;
    }
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.selectedIndex = indexPath.row;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}


- (void)showInView:(UIView *)view {
    
    if ([view.subviews containsObject:self]) {
        [self removeFromSuperview];
    }
    
    if (!view) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    
    self.frame = view.bounds;
    [view addSubview:self];
    
    self.backgroundColor = kColorAlpha(0, 0, 0, 0.5);
    self.actionView.transform = CGAffineTransformMakeTranslation(0, self.actionH.constant);
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.actionView.transform = CGAffineTransformIdentity;
    }];
}

- (void)hidden {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.backgroundColor = [UIColor clearColor];
        self.actionView.transform = CGAffineTransformMakeTranslation(0, self.actionH.constant);
        if (self.didDismissBlock) {
            self.didDismissBlock();
        }
    }completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
}

- (CGFloat)cellHeight {
    
    CGFloat height = self.datasource.count * 50 + 50;
    return height > 300 ? 300 :height;
}

#pragma mark - Action


- (IBAction)cancelAction:(id)sender {
    
    [self hidden];
}

- (IBAction)comfireAction:(id)sender {
    
    [self hidden];
    
    id result = nil;

    if (self.selectedIndex >= 0) {
        result = self.datasource[self.selectedIndex];
    }
    
    
    if (self.didComfireBlock) {
        self.didComfireBlock(result);
    }
}

@end
