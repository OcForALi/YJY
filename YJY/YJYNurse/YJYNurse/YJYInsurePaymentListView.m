//
//  YJYInsurePaymentListView.m
//  YJYNurse
//
//  Created by wusonghe on 2018/4/18.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYInsurePaymentListView.h"
#import "YJYInsurePaymentListCell.h"

@interface YJYInsurePaymentListView()<UITableViewDelegate,UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UIView *actionView;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *comfireButton;


@property (assign, nonatomic) NSInteger selectedIndex;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *actionH;

@end

@implementation YJYInsurePaymentListView

+ (instancetype)instancetypeWithXIB {
    
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]firstObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];

    [self.tableView registerNib:[UINib nibWithNibName:@"YJYInsurePaymentListCell" bundle:nil] forCellReuseIdentifier:@"YJYInsurePaymentListCell"];
    self.tableView.separatorColor = APPSaasF4Color;
    
    
}

- (void)setDatasource:(NSMutableArray *)datasource {
    
    _datasource = datasource;
    
    
    [self.tableView reloadData];
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    
//    return self.datasource.count;
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
//    NSDictionary *dict = self.datasource[section];
//    NSArray *arr = dict[@"list"];
 
    return self.datasource.count;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    YJYInsurePaymentListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YJYInsurePaymentListCell"];
    NSDictionary *dict = self.datasource[indexPath.row];
    
    
    cell.titleLabel.text = dict[@"title"];
    cell.dayLabel.text = dict[@"number"];
    cell.priceLabel.text = dict[@"price"];
    
//    NSArray *arr = dict[@"list"];
//    id item  = arr[indexPath.row];
    
//    if ([item isKindOfClass:[HgVO class]]) {
//        cell.titleLabel.text = [(HgVO *)item fullName];
//    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 40;
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
    }completion:^(BOOL finished) {
        if (self.didHidden) {
            self.didHidden();
        }
        [self removeFromSuperview];
        
    }];
}

- (CGFloat)cellHeight {
    
    return 200;//self.datasource.count * 50 + 50;
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
    
    
    if (self.didDoneBlock) {
        self.didDoneBlock(result);
    }
}

@end
