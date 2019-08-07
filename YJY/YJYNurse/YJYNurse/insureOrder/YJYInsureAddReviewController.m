//
//  YJYInsureAddReviewController.m
//  YJYNurse
//
//  Created by wusonghe on 2018/3/23.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYInsureAddReviewController.h"

@interface YJYInsureAddModel : NSObject

@property (strong, nonatomic) NSString *title;

@end

@implementation YJYInsureAddModel
@end

@interface YJYInsureAddCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;
@property (strong, nonatomic) YJYInsureAddModel *addModel;

@end

@implementation YJYInsureAddCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    NSString *name = selected == YES ?  @"app_select_icon" : @"app_unselect_icon";
    self.selectedImageView.image = [UIImage imageNamed:name];
}


- (void)setAddModel:(YJYInsureAddModel *)addModel {
    
    _addModel = addModel;
    self.titleLabel.text = addModel.title;
    
}

@end

@interface YJYInsureAddContentReviewController : YJYTableViewController
@property (weak, nonatomic) IBOutlet UITextField *testTextField;
@property (strong, nonatomic) GetInsureOrderDetailRsp *orderDetailRsp;
@property (strong, nonatomic) NSMutableArray *addModelArray;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@end

@implementation YJYInsureAddContentReviewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.addModelArray = [NSMutableArray array];
    
    NSArray *titles = @[@"长护险生活照护类操作考核",@"居家照护质量标准检查",@"最终考核"];
    for (NSString *title in titles) {
        YJYInsureAddModel *add = [YJYInsureAddModel new];
        add.title = title;
        [self.addModelArray addObject:add];
    }
    [self.tableView reloadData];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.addModelArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    YJYInsureAddCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YJYInsureAddCell" forIndexPath:indexPath];
    YJYInsureAddModel *add = self.addModelArray[indexPath.row];
    cell.addModel = add;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 200;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return self.footerView;
}

- (IBAction)numberDidChange:(UITextField *)sender {
    
    NSInteger number = [sender.text integerValue];
    
    
    
    if ([sender isFirstResponder] && sender.text.length > 3) {
        sender.text = [sender.text substringToIndex:3];
        
        return;
    }
    
    if ([sender isFirstResponder] && sender.text.length == 3 && number > 100) {
        sender.text = [sender.text substringToIndex:2];
        
        return;
    }
   
    
    
}

@end

@interface YJYInsureAddReviewController ()

@property (strong, nonatomic) YJYInsureAddContentReviewController *contentVC;
@end

@implementation YJYInsureAddReviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

+ (instancetype)instanceWithStoryBoard {
    
    NSString *className = NSStringFromClass([self class]);
    id vc = [UIStoryboard storyboardWithName:@"YJYInsureReview" viewControllerIdentifier:className];
    return vc;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"YJYInsureAddContentReviewController"]) {
        
        self.contentVC = (YJYInsureAddContentReviewController *)segue.destinationViewController;
        self.contentVC.orderDetailRsp = self.orderDetailRsp;
    }
    
}
- (IBAction)done:(id)sender {
    
    [SYProgressHUD show];
    APPAddInsureOrderCheckReq *req = [APPAddInsureOrderCheckReq new];
    req.orderId = self.orderDetailRsp.order.orderId;
    req.checkType = (uint32_t)self.contentVC.tableView.indexPathForSelectedRow.row;
    req.score = [self.contentVC.testTextField.text integerValue];
    [YJYNetworkManager requestWithUrlString:SAASAPPAddInsureOrderCheck message:req controller:self command:APP_COMMAND_SaasappaddInsureOrderCheck success:^(id response) {
        
        [SYProgressHUD hide];
        [self.navigationController popViewControllerAnimated:YES];


        
    } failure:^(NSError *error) {
        
    }];
    
    
   
    
    
}



@end
