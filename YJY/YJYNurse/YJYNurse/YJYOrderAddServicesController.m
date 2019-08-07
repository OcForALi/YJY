//
//  YJYOrderAddServicesController.m
//  YJYNurse
//
//  Created by wusonghe on 2017/6/5.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYOrderAddServicesController.h"
#import "YJYCalendarView.h"
#import "YJYOrderAddServicesCell.h"


@interface YJYOrderServicesContentController : YJYTableViewController<IQActionSheetPickerViewDelegate>



@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIView *headerView;



@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *timeButton;
@property (weak, nonatomic) IBOutlet UIImageView *timeDownButton;
@property (copy, nonatomic) NSString *sectionTitle;



//outdata

@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *affirmTime;
@property (assign, nonatomic) BOOL isShowCalendar;
@property (assign, nonatomic) BOOL isInsure;


//network

#define kPriceItems @"kPriceItems"
#define kPriceTitle @"kPriceTitle"


@property (strong, nonatomic) GetPriceListRsp *rsp;

//arr1,arr2
@property (strong, nonatomic) NSMutableArray *priceDictArray;

@end

@implementation YJYOrderServicesContentController


- (void)viewDidLoad {

    [super viewDidLoad];
    
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@",self.affirmTime];
    [self.timeButton setTitle:self.affirmTime forState:0];

    self.timeButton.hidden = !self.isShowCalendar;
    self.timeDownButton.hidden = self.timeButton.hidden;
    
    self.priceDictArray = [NSMutableArray array];

    [SYProgressHUD show];
    [self loadNetworkData];
}

- (void)loadNetworkData {

    
    SaveOrderItemReq *req = [SaveOrderItemReq new];
    [req setOrderId:self.orderId];
    [req setAffirmTime:self.affirmTime];
    
    
    NSString *urlString = SAASAPPGetPriceList;
    APP_COMMAND command =  APP_COMMAND_SaasappgetPriceList;
    
    
    [YJYNetworkManager requestWithUrlString:urlString message:req controller:self command:command success:^(id response) {
        
        self.rsp = [GetPriceListRsp parseFromData:response error:nil];
        [self reloadRsp];
        [self reloadAllData];
        [self reloadSelectTableView];
        
    } failure:^(NSError *error) {
        
        [self reloadErrorData];
    }];
}
- (void)reloadRsp {
    
    self.sectionTitle = nil;
    self.priceDictArray = [NSMutableArray array];
    if (self.isInsure) {
        
        if (self.rsp.insurePriceVolistArray_Count > 0) {
            self.sectionTitle = @"长护险附加服务";
            [self.priceDictArray addObject:@{kPriceItems:self.rsp.insurePriceVolistArray,kPriceTitle:self.sectionTitle}];
            
           
        }
    }else {
    
        if (self.rsp.commonPriceVolistArray_Count > 0) {
            self.sectionTitle = @"普通附加服务";
            [self.priceDictArray addObject:@{kPriceItems:self.rsp.commonPriceVolistArray,kPriceTitle:self.sectionTitle}];
            
        }
    
    }
    
}


- (void)reloadSelectTableView {
    
    
    for (NSInteger i = 0; i < self.priceDictArray.count; i++) {
        
        NSArray *items = self.priceDictArray[i][kPriceItems];
        for (NSInteger j = 0; j < items.count; j ++) {
            
            CompanyPriceVO *price = items[j];
            if (price.number > 0) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:0];
            }
        }
    }

    
}
#pragma mark - Action

- (IBAction)timeAction:(id)sender {
    
    YJYCalendarView *calendarView = [YJYCalendarView instancetypeWithXIB];
    calendarView.selectedDate = [NSDate dateString:self.affirmTime Format:YYYY_MM_DD];
    calendarView.disableBefore = YES;
    [calendarView showInView:nil];
    
    calendarView.didConfirmBlock = ^(NSDate *date) {
        
        NSString *dataString = [NSDate getRealDateTime:date withFormat:YYYY_MM_DD];
        [self.timeButton setTitle:dataString forState:0];
        self.affirmTime = dataString;
        [self loadNetworkData];
    };
}


#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.priceDictArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.priceDictArray.count > 0) {
        NSDictionary *dict = self.priceDictArray[section];
        NSArray *items = dict[kPriceItems];
        return items.count;
    }
    
    return 0;
   
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    YJYOrderAddServicesCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YJYOrderAddServicesCell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.priceDictArray[indexPath.section]];
    NSMutableArray *items = [NSMutableArray arrayWithArray:dict[kPriceItems]];

    CompanyPriceVO *price = items[indexPath.row];
    cell.price = price;

    
    cell.didNumberChangeBlock = ^(NSInteger number) {
        
        price.number = (uint32_t)number;
        [items replaceObjectAtIndex:indexPath.row withObject:price];
        dict[kPriceItems] = items;
        
        [self.priceDictArray replaceObjectAtIndex:indexPath.section withObject:dict];

    };

    return cell;
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 44;
}



- (UIView*) tableView:(UITableView *)_tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 44)];
    headerView.backgroundColor = APPSaasF4Color;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, _tableView.frame.size.width-50, 50)];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor darkGrayColor];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.priceDictArray[section]];
    label.text = dict[kPriceTitle];
    label.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:label];
    
    return headerView;
}




- (nullable NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (tableView.allowsMultipleSelection &&
        [[tableView indexPathsForSelectedRows] containsObject:indexPath]) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return nil;
    }
    return indexPath;
    
}


#pragma mark - UIScrollView


#define kHomeHeaderHeight 220

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if(offsetY < 0){
        CGRect rect = self.headerImageView.frame;
        rect.origin.y = offsetY;
        rect.size.height =  kHomeHeaderHeight - offsetY;
        self.headerImageView.frame = rect;
    }
    
}


@end

@interface YJYOrderAddServicesController ()

@property (strong, nonatomic) YJYOrderServicesContentController *contentVC;

@end

@implementation YJYOrderAddServicesController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYOrderAddServicesController *)[UIStoryboard storyboardWithName:@"YJYOrderServices" viewControllerIdentifier:NSStringFromClass(self)];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"YJYOrderServicesContentController"]) {
        self.contentVC = segue.destinationViewController;
        self.contentVC.orderId = self.orderId;
        self.contentVC.affirmTime = self.affirmTime;
        self.contentVC.isShowCalendar = self.isShowCalendar;
        self.contentVC.isInsure = self.isInsure;

    }
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self navigationBarAlphaWithWhiteTint];

}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self navigationBarNotAlphaWithBlackTint];

}

- (GPBUInt64UInt32Dictionary *)getMapPrice {

    
    GPBUInt64UInt32Dictionary *mapPrice = [GPBUInt64UInt32Dictionary dictionary];

    
    for (NSInteger i = 0; i < self.contentVC.priceDictArray.count; i++) {
        
        NSArray *items = self.contentVC.priceDictArray[i][kPriceItems];
        for (NSInteger j = 0; j < items.count; j ++) {
            
            CompanyPriceVO *price = items[j];
            GPBUInt64UInt32Dictionary *info = [GPBUInt64UInt32Dictionary dictionaryWithUInt32:price.number forKey:price.price.priceId];
            [mapPrice addEntriesFromDictionary:info];
        }
    }

    
    return mapPrice;
    
}
- (IBAction)done:(id)sender {
    
    NSString *title = [NSString stringWithFormat:@"是否将所选医疗附加项添加至%@的服务中？",self.contentVC.affirmTime];
    
    [UIAlertController showAlertInViewController:self withTitle:title message:nil alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"取消" destructiveButtonTitle:@"确认" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
         
            [self toMofidyAction];
        }
    }];
    
    
}


- (void)toMofidyAction {

    GPBUInt64UInt32Dictionary *mapPrice = [self getMapPrice];
    
    if (mapPrice.count == 0) {
        
        [SYProgressHUD showFailureText:@"请选择服务"];
        return;
    }
    AddOrderPriceReq *req  = [AddOrderPriceReq new];
    req.orderId = self.orderId;
    req.serviceTime = self.contentVC.affirmTime;
    req.mapPrice = mapPrice;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPAddOrderPrice message:req controller:self command:APP_COMMAND_SaasappaddOrderPrice success:^(id response) {
        
        if (self.didEditServicesBlock) {
            self.didEditServicesBlock();
        }
        [self.navigationController popViewControllerAnimated:YES];
        
        
    } failure:^(NSError *error) {
        
    }];
    
    
}


@end
