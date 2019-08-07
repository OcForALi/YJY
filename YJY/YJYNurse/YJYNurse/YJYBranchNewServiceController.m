//
//  YJYBranchNewServiceController.m
//  YJYNurse
//
//  Created by wusonghe on 2018/3/29.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYBranchNewServiceController.h"
#import "YJYBranchOrderInfoController.h"

#define YJYBranchNewServiceHeaderH 60

@interface YJYBranchNewServiceHeader : UIView

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIView *whiteView;
@property (strong, nonatomic) NSString *title;
@end

@implementation YJYBranchNewServiceHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = APPSaasF8Color;
        
        self.whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-10)];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, 0, 300, 20)];
        self.titleLabel.center = CGPointMake(self.titleLabel.center.x, self.whiteView.center.y);
        self.titleLabel.textColor = APPGrayCOLOR;
        
        [self.whiteView addSubview:self.titleLabel];
        [self addSubview:self.whiteView];
        
        
        
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    
    _title = title;
    self.titleLabel.text = title;
    
}
@end

@interface YJYBranchNewServiceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (strong, nonatomic) id price;

@end

@implementation YJYBranchNewServiceCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    if (self.userInteractionEnabled) {
        self.titleLabel.textColor = selected ? APPHEXCOLOR : APPNurseGrayCOLOR;
        self.selectImageView.image = [UIImage imageNamed:(selected ? @"app_select_icon": @"app_unselect_icon")];
        
    }
}

- (void)setPrice:(id)price {
    
    _price = price;
    
    if ([price isKindOfClass:[Price class]]) {
        
        self.titleLabel.text = [(Price *)price serviceItem];
        self.priceLabel.text = [(Price *)price priceStr];
        
        
    }else if ([price isKindOfClass:[CompanyPriceVO class]]) {
        
        self.titleLabel.text = [[(CompanyPriceVO *)price price] serviceItem];
        self.priceLabel.text = [[(CompanyPriceVO *)price price] priceStr];
        
        
    }
}

@end


@interface YJYBranchNewServiceContentController : YJYTableViewController


@property(nonatomic, readwrite) uint64_t branchId;
@property (strong, nonatomic) GetPriceRsp *rsp;
@property (copy, nonatomic) NSString *orderId;

@property (strong, nonatomic) NSArray *arrM;

@end

@implementation YJYBranchNewServiceContentController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self loadNetworkData];
}

- (void)loadNetworkData {
    
    GetPriceReq *req = [GetPriceReq new];
    req.branchId = self.branchId;
    
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetPrice message:req controller:self command:APP_COMMAND_SaasappgetPrice success:^(id response) {
        
        //rsp
        
        self.rsp = [GetPriceRsp parseFromData:response error:nil];
        self.arrM = @[@{@"普陪服务":self.rsp.pList12NArray},@{@"专陪服务":self.rsp.pList121Array}];
        [self reloadAllData];
  
        
    } failure:^(NSError *error) {
        [self reloadErrorData];
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.arrM.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSDictionary *dict = self.arrM[section];
    NSMutableArray<Price*> *pListArray = dict.allValues.firstObject;

    return pListArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    YJYBranchNewServiceCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YJYBranchNewServiceCell"];
    
    NSDictionary *dict = self.arrM[indexPath.section];
    NSMutableArray<Price*> *pListArray = dict.allValues.firstObject;
    Price *price = pListArray[indexPath.row];
    cell.price = price;
    
    if (price.defaultStatus == 1) {
        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:0];
    }
    
    
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    YJYBranchNewServiceHeader *header = [[YJYBranchNewServiceHeader alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, YJYBranchNewServiceHeaderH)];
    
    NSDictionary *dict = self.arrM[section];
    header.title = dict.allKeys.firstObject;
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return YJYBranchNewServiceHeaderH;
}

- (void)done {

   
    if (!self.tableView.indexPathForSelectedRow) {
        [UIAlertController showAlertInViewController:self withTitle:@"请选择服务" message:nil alertControllerStyle:1 cancelButtonTitle:nil destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
         
            
        }];
        return;
    }
    
    NSDictionary *dict = self.arrM[self.tableView.indexPathForSelectedRow.section];
    NSMutableArray<Price*> *pListArray = dict.allValues.firstObject;
    Price *price = pListArray[self.tableView.indexPathForSelectedRow.row];

    YJYBranchOrderInfoController *vc = [YJYBranchOrderInfoController instanceWithStoryBoard];
    vc.branchId = self.branchId;
    vc.priceId = price.priceId;
    vc.orderId = self.orderId;

    [self.navigationController pushViewController:vc animated:YES];
    
        

    
    
}

@end


@interface YJYBranchNewServiceController ()
@property (strong, nonatomic) YJYBranchNewServiceContentController *contentVC;
@end

@implementation YJYBranchNewServiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
+ (instancetype)instanceWithStoryBoard {
    
    return (YJYBranchNewServiceController *)[UIStoryboard storyboardWithName:@"YJYBranchNewService" viewControllerIdentifier:NSStringFromClass(self)];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"YJYBranchNewServiceContentController"]) {
        
        self.contentVC = segue.destinationViewController;
        self.contentVC.orderId = self.orderId;
        self.contentVC.branchId = self.branchId;

        
    }
}

- (IBAction)done:(id)sender {
 
    [self.contentVC done];
}


@end
