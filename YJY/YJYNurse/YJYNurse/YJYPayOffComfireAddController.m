//
//  YJYPayOffComfireAddController.m
//  YJYNurse
//
//  Created by wusonghe on 2017/8/13.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYPayOffComfireAddController.h"
#import "YJYOrderAddServicesCell.h"

@interface YJYPayOffComfireAddCell : UITableViewCell<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray<CompanyPriceVO*> *commonPriceVolistArray;
@end


@implementation YJYPayOffComfireAddCell

- (CGFloat)cellHeight {

    return self.commonPriceVolistArray.count * 44;
}

#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.commonPriceVolistArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    YJYOrderAddServicesCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YJYOrderAddServicesCell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    CompanyPriceVO *price = self.commonPriceVolistArray[indexPath.row];
    cell.price = price;
    
    
    cell.didNumberChangeBlock = ^(NSInteger number) {
        
        price.number = (uint32_t)number;
        [self.commonPriceVolistArray replaceObjectAtIndex:indexPath.row withObject:price];
        
//        [self.tableView reloadData];
//        [self reloadSelectTableView];
    };
    
    return cell;
    
}
- (void)reloadSelectTableView {
    
    for (NSInteger i = 0; i < self.commonPriceVolistArray.count; i ++) {
        
        CompanyPriceVO *price = self.commonPriceVolistArray[i];
        if (price.number > 0) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:0];
        }
    }
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return 44;
}

@end




@interface YJYPayOffComfireAddContentController : YJYTableViewController<IQActionSheetPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *discardTime;
@property (weak, nonatomic) IBOutlet YJYPayOffComfireAddCell *comfireAddCell;
@property (weak, nonatomic) IBOutlet UILabel *hgRebateFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *hgKinsRebateFeeLabel;

@property (weak, nonatomic) IBOutlet UIButton *noPrimeButton;


//data
@property (strong, nonatomic)NSDate *discardDate;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *affirmTime;
@property (strong, nonatomic) NSArray *primeButtons;
@property (assign, nonatomic) YJYPrimeType primeType;

@property (strong, nonatomic) GetPriceListRsp *rsp;
@property (assign, nonatomic) YJYOrderState orderState;

@end

@implementation YJYPayOffComfireAddContentController



- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.primeButtons = @[@(YJYPrimeTypeNone),@(YJYPrimeTypeEmployeeFamily),@(YJYPrimeTypeEmployee)];
    self.primeType = YJYPrimeTypeNone;
    
    
    [self primeSelectAction:self.noPrimeButton];
    
    
    [SYProgressHUD show];
    [self loadNetworkData];
}

- (void)loadNetworkData {
    
    
    GetOrderInfoReq *req = [GetOrderInfoReq new];
    [req setOrderId:self.orderId];
    
    
    NSString *urlString = SAASAPPGetOrderPriceInvert;
    APP_COMMAND command = APP_COMMAND_SaasappgetOrderPriceInvert;
    
    
    [YJYNetworkManager requestWithUrlString:urlString message:req controller:self command:command success:^(id response) {
        
        self.rsp = [GetPriceListRsp parseFromData:response error:nil];
        [self reloadRsp];
        [self reloadAllData];
        
    } failure:^(NSError *error) {
        
        [self reloadErrorData];
    }];
}

- (void)reloadRsp {
    
    self.comfireAddCell.commonPriceVolistArray = [NSMutableArray array];
    self.comfireAddCell.commonPriceVolistArray = self.rsp.commonPriceVolistArray;
    [self.comfireAddCell.tableView reloadData];
    
    self.discardDate = [NSDate dateString:self.rsp.dischargedTime Format:YYYY_MM_DD_HH_MM];
    
}
- (GPBUInt64Int32Dictionary *)getMapPrice {
    
    
    GPBUInt64Int32Dictionary *mapPrice = [GPBUInt64Int32Dictionary dictionary];
    
    
    for (NSInteger i = 0; i < self.comfireAddCell.commonPriceVolistArray.count; i ++) {
        
        CompanyPriceVO *price = self.comfireAddCell.commonPriceVolistArray[i];
        GPBUInt64Int32Dictionary *info = [GPBUInt64Int32Dictionary dictionaryWithInt32:price.number forKey:price.price.priceId];
        [mapPrice addEntriesFromDictionary:info];
    }
    
    
    return mapPrice;
    
}

#pragma mark - Action

- (IBAction)primeSelectAction:(UIButton *)sender {
    
   
    for (NSNumber *num in self.primeButtons) {
        
        UIImageView *selectImgView = (UIImageView *)[self.view viewWithTag:[num integerValue] * 10];
        [selectImgView setImage:[UIImage imageNamed:@"app_unselect_icon"]];

        
    }
    
    self.primeType = sender.tag;
    UIImageView *selectImgView = (UIImageView *)[sender.superview viewWithTag:sender.tag  * 10];
    [selectImgView setImage:[UIImage imageNamed:@"app_select_icon"]];
    
}


- (IBAction)discardTimeAction:(id)sender {
    
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"时间选择" delegate:self];
    picker.minimumDate = [NSDate dateWithTimeIntervalSince1970:0];

    picker.actionSheetPickerStyle = IQActionSheetPickerStyleTimePicker;
    [picker setDate:[NSDate dateString:self.discardTime.text Format:YYYY_MM_DD_HH_MM]];
    [picker show];
}

- (void)done:(id)sender {
    
    if (self.orderState == YJYOrderStateWaitPayOff) {
        
        [self toFinishAction];

    }else {
    
        NSString *title = @"一旦结束订单，将会停止计费，是否结束？";
        
        
        [UIAlertController showAlertInViewController:self withTitle:title message:nil alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"取消" destructiveButtonTitle:@"确认" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                
                [self toFinishAction];
                
            }
        }];
    }
    
    
    
    
}
- (void)toFinishAction {
    
    
    [SYProgressHUD show];
    
    GPBUInt64Int32Dictionary *mapPrice = [self getMapPrice];
    
    if (mapPrice.count == 0) {
        
        [SYProgressHUD showFailureText:@"请选择服务"];
        return;
    }
    AddOrderPriceReviseReq *req  = [AddOrderPriceReviseReq new];
    req.orderId = self.orderId;
    req.mapPrice = mapPrice;
    req.hgRebateType = self.primeType - 4;
    
    if (self.orderState == YJYOrderStateServing && self.discardTime.text) {
        req.dischargedTime = self.discardTime.text;
    }
    
    [YJYNetworkManager requestWithUrlString:SAASAPPAddOrderPriceItemRevise message:req controller:self command:APP_COMMAND_SaasappaddOrderPriceItemRevise success:^(id response) {
        
        
        if (self.orderState == YJYOrderStateWaitPayOff) {
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        
    } failure:^(NSError *error) {
        
    }];
}
- (void)setDiscardDate:(NSDate *)discardDate {
    
    _discardDate = discardDate;
    
    self.discardTime.text = [NSDate getRealDateTime:discardDate withFormat:YYYY_MM_DD_HH_MM];

    BOOL isAm = [[NSDate date] isAmTimeBucketWithDate:discardDate];
    
    self.hgRebateFeeLabel.text = [NSString stringWithFormat:@"可优惠%@元",isAm ? self.rsp.hgRebateFeeAm : self.rsp.hgRebateFeePm];
    self.hgKinsRebateFeeLabel.text = [NSString stringWithFormat:@"可优惠%@元",isAm ? self.rsp.hgKinsRebateFeeAm : self.rsp.hgKinsRebateFeePm];
}
#pragma mark - IQSheetDelegate

- (void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectDate:(NSDate*)date {
    
    
    self.discardDate = date;
    
}

#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if ((indexPath.row == 0 ||
        (indexPath.row >= 3 && indexPath.row <= 6)) &&
        self.orderState == YJYOrderStateWaitPayOff){
        
        return 0;
            
    }
    
    if (indexPath.row == 2) {
        return [self.comfireAddCell cellHeight];
    }
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

@end

#pragma mark - YJYPayOffComfireAddController

@interface YJYPayOffComfireAddController ()

@property (strong, nonatomic) YJYPayOffComfireAddContentController *contentVC;

@end

@implementation YJYPayOffComfireAddController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYPayOffComfireAddController *)[UIStoryboard storyboardWithName:@"YJYOrderPayOff" viewControllerIdentifier:NSStringFromClass(self)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"YJYPayOffComfireAddContentController"]) {
        
        self.contentVC = segue.destinationViewController;
        self.contentVC.orderState = self.orderState;
        self.contentVC.orderId = self.orderId;
        
    }
}
- (IBAction)done:(id)sender {
    
    [self.contentVC done:nil];
}
@end
