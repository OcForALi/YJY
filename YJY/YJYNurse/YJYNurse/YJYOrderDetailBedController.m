//
//  YJYOrderDetailBedController.m
//  YJYNurse
//
//  Created by wusonghe on 2017/12/20.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYOrderDetailBedController.h"
#import "YJYOrderAddServicesCell.h"
#import "YJYSignatureController.h"

@interface YJYOrderDetailBedContentController : YJYTableViewController

@property(nonatomic, strong) NSMutableArray<CompanyPriceVO*> *priceVoprcListArray;
@property (strong, nonatomic) GetOrderItemRsp *rsp;
@property (copy, nonatomic) YJYOrderDetailBedDidComfireBlock didComfireBlock;

@property (copy, nonatomic) NSString *orderId;
@property (assign, nonatomic) BOOL isYesterday;
@property (assign, nonatomic) int32_t originNumber;
@property (copy, nonatomic) NSString *signID;


@end

@implementation YJYOrderDetailBedContentController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self loadNetworkData];

}

- (void)loadNetworkData {
    [SYProgressHUD show];

    GetOrderProcessReq *req = [GetOrderProcessReq new];
    req.orderId = self.orderId;
    req.isYesterday = self.isYesterday;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetOrderItemDetailNowInvert message:req controller:self command:APP_COMMAND_SaasappgetOrderItemDetailNowInvert success:^(id response) {
        
        self.rsp = [GetOrderItemRsp parseFromData:response error:nil];
        self.originNumber = self.rsp.priceVoprcListArray.firstObject.number;
        [self reloadAllData];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.rsp.priceVoprcListArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    YJYOrderAddServicesCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YJYOrderAddServicesCell"];
    CompanyPriceVO *price = self.rsp.priceVoprcListArray[indexPath.row];
    cell.price = price;
    
    cell.didNumberChangeBlock = ^(NSInteger number) {
        
        price.number = (uint32_t)number;
        self.rsp.priceVoprcListArray[indexPath.row] = price;
        
    };
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

- (IBAction)done:(id)sender {
    
    //是不是减少
    AddOrderPriceReviseReq *req = [AddOrderPriceReviseReq new];
    req.orderId = self.orderId;
    req.signId = [self.signID integerValue];
    
    
    /// 是否修改今日 0-否 1-是 2-昨日

    req.istoday = 1;
    if (self.isYesterday) {
        req.istoday = 2;
    }
    
    
    //是否减少
    BOOL isAppend = false;

    GPBUInt64Int32Dictionary *mapPrice = [GPBUInt64Int32Dictionary dictionary];
    for (CompanyPriceVO *price in self.rsp.priceVoprcListArray) {
        [mapPrice addEntriesFromDictionary:[GPBUInt64Int32Dictionary dictionaryWithInt32:price.number forKey:price.price.priceId]];
        isAppend = self.originNumber <= price.number;
    }
    req.mapPrice = mapPrice;
    
    
    /// 添加陪人床附加项是否需要签名 1-不需要 2-需要
    
    if (self.rsp.prcOrderSignConfig == 2) {
        if (isAppend) {
            [self toSign];
            return;
        }
        
    }

    
    
    [SYProgressHUD show];
    
    
    [YJYNetworkManager requestWithUrlString:SAASAPPCreateOrUpdateOrderItemPrice message:req controller:self command:APP_COMMAND_SaasappcreateOrUpdateOrderItemPrice success:^(id response) {
        
        
        if (self.didComfireBlock) {
            self.didComfireBlock();
        }
        [self.navigationController popViewControllerAnimated:YES];
        [SYProgressHUD hide];
        
    } failure:^(NSError *error) {
        
    }];
    
}
- (void)toSign {
    

    
    YJYSignatureController *vc = [YJYSignatureController new];
    vc.orderId = self.orderId;
    vc.didReturnImage = ^(NSString *imageID, NSString *imageURL) {
       
        if (imageID && imageID.length > 0) {
            [SYProgressHUD showSuccessText:@"签名成功"];
            self.rsp.prcOrderSignConfig = 1;
            self.signID = imageID;
            [self done:nil];
        }
       
    };
    [self presentViewController:vc animated:YES completion:nil];
}

@end

#pragma mark - YJYOrderDetailBedController

@interface YJYOrderDetailBedController ()

@property (strong, nonatomic) YJYOrderDetailBedContentController *contentVC;

@end

@implementation YJYOrderDetailBedController


+ (instancetype)instanceWithStoryBoard {
    
    return (YJYOrderDetailBedController *)[UIStoryboard storyboardWithName:@"YJYOrderDetailBed" viewControllerIdentifier:NSStringFromClass(self)];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"YJYOrderDetailBedContentController"]) {
        
        __weak typeof(self) weakSelf = self;
        self.contentVC = (YJYOrderDetailBedContentController *)segue.destinationViewController;
        self.contentVC.orderId = self.orderId;
        self.contentVC.isYesterday = self.isYesterday;
        self.contentVC.didComfireBlock = ^{
            weakSelf.didComfireBlock();
        };
    }
    
}
- (IBAction)done:(id)sender {
    [self.contentVC done:nil];
    
}






@end
