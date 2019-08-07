//
//  YJYOrderEndServiceController.m
//  YJYNurse
//
//  Created by wusonghe on 2017/6/24.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYOrderEndServiceController.h"


@interface YJYOrderEndServiceModel : NSObject

@property (copy, nonatomic) NSString *reason;
@property (copy, nonatomic) NSString *day;
@property (assign, nonatomic) BOOL isSelect;

@end
@implementation YJYOrderEndServiceModel
@end

#pragma mark - YJYOrderEndServiceCell

@interface YJYOrderEndServiceCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkView;

@property (strong, nonatomic) YJYOrderEndServiceModel *orderEndServiceModel;

@end

@implementation YJYOrderEndServiceCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    self.dayLabel.hidden = !selected;
    self.checkView.hidden = !selected;
    self.backgroundColor = selected ? APPSaasF4Color : [UIColor whiteColor];
}

- (void)setOrderEndServiceModel:(YJYOrderEndServiceModel *)orderEndServiceModel {
    
    _orderEndServiceModel = orderEndServiceModel;
    self.titleLabel.text = orderEndServiceModel.reason;
    self.dayLabel.text = orderEndServiceModel.day;
    
}

@end


#pragma mark - YJYOrderEndServiceController

@interface YJYOrderEndServiceController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet YJYTableView *tableView;

@property (strong, nonatomic) NSMutableArray *reasons;
@property(nonatomic, readwrite) uint32_t mold;
@property(nonatomic, readwrite) uint32_t type;

@end

@implementation YJYOrderEndServiceController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYOrderEndServiceController *)[UIStoryboard storyboardWithName:@"YJYOrderServices" viewControllerIdentifier:NSStringFromClass(self)];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.reasons = [NSMutableArray array];
    NSArray *reasonTitles = @[@"完成服务",@"事假",@"病假",@"休假",@"旷工",@"客户外出",@"转ICU不收费"];
    
    for (NSInteger i = 0; i < reasonTitles.count; i++) {
        
        YJYOrderEndServiceModel *orderEndServiceModel = [YJYOrderEndServiceModel new];
        orderEndServiceModel.reason = reasonTitles[i];
        [self.reasons addObject:orderEndServiceModel];
        
        
    }
    [self.tableView reloadData];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:0];
    self.mold = 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.reasons.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    YJYOrderEndServiceCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YJYOrderEndServiceCell"];
    cell.orderEndServiceModel = self.reasons[indexPath.row];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row > 0) {

        NSArray *titles;
        NSArray *nooutArray = @[@"半天（有人替班）",@"半天（无人替班）",@"全天（有人替班）",@"全天（无人替班）"];
        NSArray *outArray = @[@"客户外出（半天）",@"客户外出（全天)"];
        NSArray *icuArray = @[@"半天",@"全天"]; //2-4
        BOOL isOut = (indexPath.row == 5);
        titles = isOut ? outArray : nooutArray;
        titles = indexPath.row == 6 ? icuArray : titles;
        
        NSMutableArray *bigTiltes = [NSMutableArray arrayWithArray:nooutArray];
        [bigTiltes addObjectsFromArray:outArray];
        [bigTiltes addObjectsFromArray:icuArray];

        
        
        self.mold = (uint32_t)indexPath.row + 1;
        self.type = (uint32_t)2 + (isOut ? 4 : 0) - 1;

        YJYOrderEndServiceModel *orderEndServiceModel = self.reasons[indexPath.row];
        
      
        
        [self.reasons replaceObjectAtIndex:indexPath.row withObject:orderEndServiceModel];
        [self.tableView reloadData];
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:0];
        
       
        //alert
        
        [UIAlertController showAlertInViewController:self withTitle:@"确认情况" message:nil alertControllerStyle:UIAlertControllerStyleActionSheet cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:titles tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            
            if (buttonIndex >= 2) {
                
                self.mold = (uint32_t)indexPath.row + 1;
                self.type = (uint32_t)buttonIndex + (indexPath.row == 5 ? 4 : 0) - 1;
                if (indexPath.row == 6) {
                    
                    self.type = (uint32_t)(buttonIndex == 2 ? buttonIndex : 4);
                }
                
                YJYOrderEndServiceModel *orderEndServiceModel = self.reasons[indexPath.row];
                orderEndServiceModel.day = action.title;
                [self.reasons replaceObjectAtIndex:indexPath.row withObject:orderEndServiceModel];
                [self.tableView reloadData];
                [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:0];

            }
            ///1：半天（有人顶替），2：半天（无人顶替），3：全天（有人顶替），4：全天（无人服务），5：客户外出（半天） ，6：客户外出（全天）
            
        }];
    }else {
        
        self.mold = (uint32_t)indexPath.row + 1;
        self.type = (uint32_t)indexPath.row;
    }
    
}



#pragma mark - Action



- (IBAction)done:(id)sender {
    
    if (!self.tableView.indexPathForSelectedRow) {
        return;
    }
    
    NSString *reasonStr = @"完成服务";
    if (self.mold != 1) {
        
        YJYOrderEndServiceModel *orderEndServiceModel = self.reasons[self.tableView.indexPathForSelectedRow.row];
        reasonStr = orderEndServiceModel.reason;
        if (self.mold == 2 || self.mold == 3) {
            reasonStr = [@"请" stringByAppendingString:reasonStr];
        }
    }
    
    
    NSString *dayStr = @"";
    if (self.type == 1 || self.type == 2 || self.type == 5){
        dayStr = @"半天";
    }else if (self.type == 3 || self.type == 4 || self.type == 6){
        dayStr = @"全天";
    }
    
    
    NSString *confirmStr = [NSString stringWithFormat:@"%@%@",reasonStr,dayStr];
    NSString *hgType = @"护工";
    
    NSString *alertTitle = [NSString stringWithFormat:@"是否确认%@\n%@%@%@？",self.affirmTime,hgType,self.hgName,confirmStr];
    
    if (self.mold == 7 || self.mold == 6 || self.mold == 1) {
        
        alertTitle = [NSString stringWithFormat:@"是否确认%@\n%@？",self.affirmTime,confirmStr];

    }
    
    [UIAlertController showAlertInViewController:self withTitle:alertTitle message:nil alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            
            
            [SYProgressHUD show];
            SaveOrderItemReq *req = [SaveOrderItemReq new];
            req.mold = self.mold;
            if (self.mold != 1) {
                req.type = self.type;
            }
           
            req.orderId = self.orderId;
            req.affirmTime = self.affirmTime;
            
            [YJYNetworkManager requestWithUrlString:SAASAPPConfirmOrderItem message:req controller:self command:APP_COMMAND_SaasappconfirmOrderItem success:^(id response) {
                
                [SYProgressHUD showSuccessText:@"确定完成"];
                
                if (self.didDoneBlock) {
                    self.didDoneBlock();
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
                
            } failure:^(NSError *error) {
                
            }];
            
        }
    }];
    
   
    
    
}


@end
