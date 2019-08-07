//
//  YJYOrderNightCareController.m
//  YJYNurse
//
//  Created by wusonghe on 2018/1/24.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYOrderNightCareController.h"
#import "YJYOrderNightCell.h"
#import "YJYActionSheet.h"


@interface YJYOrderNightCareController ()

@property (strong, nonatomic) OrderItemNightRsp *rsp;
@property (strong, nonatomic) GetHgRsp *hgRsp;
@property (weak, nonatomic) IBOutlet YJYOrderNightCell *addServiceCell;
@property (weak, nonatomic) IBOutlet YJYOrderNightCell *serviceRecordCell;

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end

@implementation YJYOrderNightCareController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYOrderNightCareController *)[UIStoryboard storyboardWithName:@"YJYOrderNightCare" viewControllerIdentifier:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:0 target:self action:@selector(close)];
    //[UIBarButtonItem itemWithImage:@"app_back_icon" highImage:@"app_back_icon" target:self action:@selector(back)];
    
 
    [self loadNetWorkData];
    [self setupCell];
}

- (void)loadNetWorkData {
 
    OrderItemNightReq *req = [OrderItemNightReq new];
    req.orderId = self.orderId;
    [YJYNetworkManager requestWithUrlString:SAASAPPGetOrderItemNightList message:req controller:self command:APP_COMMAND_SaasappgetOrderItemNightList success:^(id response) {
        
        self.rsp = [OrderItemNightRsp parseFromData:response error:nil];
        
        self.addServiceCell.priceVolistArray = self.rsp.priceVolistArray;
        self.serviceRecordCell.orderItemNightVolistArray = self.rsp.orderItemNightVolistArray;
        
        self.totalLabel.text = [NSString stringWithFormat:@"合计%@次",@(self.rsp.orderItemNightVolistArray_Count)];
        
        [self loadStaffList];
        [SYProgressHUD hide];
        [self.tableView reloadData];
        
        
        
    } failure:^(NSError *error) {
        
    }];
}


- (void)loadStaffList {
    
    GetStaffListReq *req = [GetStaffListReq new];
    req.orgId = self.rsp.orgId;
    req.branchId = self.rsp.branchId;
    req.workType = self.rsp.workType;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetStaffList message:req controller:self command:APP_COMMAND_SaasappgetStaffList success:^(id response) {
        
        self.hgRsp = [GetHgRsp parseFromData:response error:nil];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - cell

- (void)guidePrice:(PriceVO *)priceVo
  orderItemNightVO:(OrderItemNightVO *)orderItemNightVO
          isDelete:(BOOL)isDelete
          complete:(CompleteNoneBlock)complete{

    YJYActionSheet *actionSheet  = [YJYActionSheet instancetypeWithXIBWithDatasource:self.hgRsp.hgVoArray withTitle:@"指派夜陪护工"];
    actionSheet.frame = self.view.bounds;
    
    actionSheet.didComfireBlock = ^(id result) {
        
        
        
        
        if ([result isKindOfClass:[HgVO class]]) {
            HgVO *hg = (HgVO *)result;
            
            SaveOrUpdateOrderItemNighReq *req = [SaveOrUpdateOrderItemNighReq new];
            req.orderId = self.orderId;
            
            if (priceVo) {
                req.priceId = priceVo.priceId;
                req.hgId = hg.id_p;
                req.type = 0;
            }else if (orderItemNightVO) {
                
                req.priceId = orderItemNightVO.priceId;
                req.hgId = hg.id_p;
                req.itemId = orderItemNightVO.itemId;
                req.type = 2;
            }
            
            
            
            [YJYNetworkManager requestWithUrlString:SAASAPPSaveOrUpdateOrderItemNight message:req controller:self command:APP_COMMAND_SaasappsaveOrUpdateOrderItemNight success:^(id response) {
                
                if (complete) {
                    complete();
                }
                
            } failure:^(NSError *error) {
                
            }];
        }else {
            
            [SYProgressHUD showFailureText:@"请选择护工"];
        }
    };
    [actionSheet showInView:nil];
}

- (void)setupCell {
    
    
    self.addServiceCell.nightCellType = YJYOrderNightCellTypeAddService;
    self.serviceRecordCell.nightCellType = YJYOrderNightCellTypeServiceRecord;
    
    
//    self.tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 20)];
//    self.tipLabel.text =
    
    __weak typeof(self) weakSelf = self;
    self.addServiceCell.didAddBlock = ^(PriceVO *priceVo) {
        
        
        [self guidePrice:priceVo orderItemNightVO:nil isDelete:NO complete:^{
            
            [SYProgressHUD show];
            [weakSelf loadNetWorkData];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SYProgressHUD showSuccessText:@"操作成功"];
                
            });
        }];
        
    };
    
    self.serviceRecordCell.didGuideBlock = ^(OrderItemNightVO *orderItemNightVO) {
      
        [self guidePrice:nil orderItemNightVO:orderItemNightVO isDelete:NO complete:^{
            
            [SYProgressHUD show];
            [weakSelf loadNetWorkData];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SYProgressHUD showSuccessText:@"操作成功"];
                
            });
        }];
    };
    
    self.serviceRecordCell.didDelBlock = ^(OrderItemNightVO *orderItemNightVO) {
        
        [UIAlertController showAlertInViewController:self withTitle:@"是否删除此服务？" message:nil alertControllerStyle:1 cancelButtonTitle:@"不删除" destructiveButtonTitle:@"删除" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                
                SaveOrUpdateOrderItemNighReq *req = [SaveOrUpdateOrderItemNighReq new];
                req.orderId = self.orderId;
                req.priceId = orderItemNightVO.priceId;
                req.hgId = orderItemNightVO.hgId;
                req.itemId = orderItemNightVO.itemId;
                req.type = 1;
                
                [YJYNetworkManager requestWithUrlString:SAASAPPSaveOrUpdateOrderItemNight message:req controller:self command:APP_COMMAND_SaasappsaveOrUpdateOrderItemNight success:^(id response) {
                    
                    [SYProgressHUD show];
                    [weakSelf loadNetWorkData];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [SYProgressHUD showSuccessText:@"操作成功"];
                        
                    });

                    
                } failure:^(NSError *error) {
                    
                }];
                
             
            }
        }];
    };
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        CGFloat cellH = [self.addServiceCell cellHeight];
        if (self.jumpType != YJYOrderPaymentAdjustTypeNone) {
            cellH = 0;
        }
        return cellH;
        
    }else if (indexPath.row == 1){
        
        CGFloat cellH = [self.serviceRecordCell cellHeight];
       
        return cellH == 0 ? 300 :cellH;
    }
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (void)close{
    
    if (self.rsp.nightHgStatus == YES) {
        
        [UIAlertController showAlertInViewController:self withTitle:@"仍有未指派的服务,是否返回去指派" message:nil alertControllerStyle:1 cancelButtonTitle:@"不指派" destructiveButtonTitle:@"指派" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                
                
                
                if (self.jumpType == YJYOrderPaymentAdjustTypeNone) {
                    
                    [self.navigationController popViewControllerAnimated:YES];

                }else if (self.jumpType == YJYOrderPaymentAdjustTypePayoffPaymentCheck) {

                    NSInteger index =  self.navigationController.viewControllers.count-1-2;
                    if (index < 0) {
                        index = 0;
                    }
                    [self.navigationController popToViewController:self.navigationController.viewControllers[index] animated:YES];
                }else {
                    
                    if (self.didBackBlock) {
                        self.didBackBlock();
                    }
                }
                
                
                
              
            }
        }];
        
    }else {
        if (self.didBackBlock) {
            self.didBackBlock();
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}




@end
