//
//  YJYWaitVisitOrderController.m
//  YJYNurse
//
//  Created by wusonghe on 2018/6/6.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYWaitVisitOrderController.h"
#import "YJYInsureOrderDetailController.h"

@interface YJYWaitVisitOrderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitTimeLabel;

@property (strong, nonatomic) InsureOrderVisitVO *insureOrderVisitVO;

@end

@implementation YJYWaitVisitOrderCell

- (void)setInsureOrderVisitVO:(InsureOrderVisitVO *)insureOrderVisitVO {
  
    _insureOrderVisitVO = insureOrderVisitVO;
    self.nameLabel.text = insureOrderVisitVO.fullName;
    self.serviceLabel.text = insureOrderVisitVO.serviceItem;
    self.locationLabel.text = insureOrderVisitVO.addr;
    self.visitTimeLabel.text = insureOrderVisitVO.visitTimeStr;
}

@end




@interface YJYWaitVisitOrderController ()<UISearchBarDelegate>
@property (assign, nonatomic) NSInteger pageNum;
@property (strong, nonatomic) NSMutableArray<InsureOrderVisitVO*> *visitVoArray;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation YJYWaitVisitOrderController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYWaitVisitOrderController *)[UIStoryboard storyboardWithName:@"YJYWaitVisitOrder" viewControllerIdentifier:NSStringFromClass(self)];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    
    //search
    self.searchBar.barTintColor = [UIColor whiteColor];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"请输入被陪护人姓名/身份证号/订单号";

    
    
    UITextField *searchField = [self.searchBar valueForKey:@"searchField"];
    if (searchField) {
        [searchField setBackgroundColor:APPSaasF4Color];
        searchField.layer.cornerRadius = 14.0f;
    }
    
    self.visitVoArray = [NSMutableArray array];
    __weak __typeof(self)weakSelf = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.pageNum = 1;
        [weakSelf loadNetworkData];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        self.pageNum ++;
        [weakSelf loadNetworkData];
    }];
    
    
    self.pageNum = 1;
    [self loadNetworkData];
}

- (void)loadNetworkDataWithText:(NSString *)text {
    
    GetInsureOrderVisitListHSReq *req = [GetInsureOrderVisitListHSReq new];
    req.pageNo = (uint32_t)self.pageNum;
    req.pageSize = 20;
    if (text) {
        req.name = text;
    }
    
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetInsureOrderVisitListHS message:req controller:self command:APP_COMMAND_SaasappgetInsureOrderVisitListHs success:^(id response) {
        
        
        GetInsureOrderVisitListRsp *rsp = [GetInsureOrderVisitListRsp parseFromData:response error:nil];
        
        if (self.pageNum > 1) {
            
            if (rsp.visitVoArray.count == 0) {
                [self.tableView.mj_footer endRefreshing];
            }else {
                
                [self.visitVoArray addObjectsFromArray:rsp.visitVoArray];
                
            }
            
        }else {
            self.visitVoArray = rsp.visitVoArray;
            [self.tableView.mj_footer resetNoMoreData];
            
        }
        
        [self reloadAllData];
        
        
    } failure:^(NSError *error) {
        
        [self reloadErrorData];
        
        
    }];
}


- (void)loadNetworkData {
    
    [self loadNetworkDataWithText:nil];
    
}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.visitVoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    YJYWaitVisitOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YJYWaitVisitOrderCell" forIndexPath:indexPath];
    
    InsureOrderVisitVO *insureOrderVisitVO = self.visitVoArray[indexPath.row];
    cell.insureOrderVisitVO = insureOrderVisitVO;
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YJYInsureOrderDetailController *vc = [YJYInsureOrderDetailController instanceWithStoryBoard];
    InsureOrderVisitVO *insureOrderVisitVO = self.visitVoArray[indexPath.row];
    vc.orderId = insureOrderVisitVO.orderId;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    InsureOrderVisitVO *insureOrderVisitVO = self.visitVoArray[indexPath.row];

    CGFloat addressWidth = self.tableView.frame.size.width - (35+80+5);
    
    CGFloat markExtraHeight = [insureOrderVisitVO.addr boundingRectWithSize:CGSizeMake(addressWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height - 10;
    
    return 180 + markExtraHeight;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText  {
    
    self.pageNum = 1;
    [self loadNetworkDataWithText:searchText];
}

@end
