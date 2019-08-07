//
//  YJYInsureGuideTeachListController.m
//  YJYNurse
//
//  Created by wusonghe on 2018/3/23.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYInsureGuideTeachListController.h"
#import "YJYInsureGuideTeachDetailController.h"
@interface YJYInsureGuideTeachListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//NSMutableArray<TeachRecordVO*> *recordListArray
@property (strong, nonatomic) TeachRecordVO *teachRecordVO;
@end

@implementation YJYInsureGuideTeachListCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
}
- (void)setTeachRecordVO:(TeachRecordVO *)teachRecordVO {
    
    _teachRecordVO = teachRecordVO;
    self.titleLabel.text = teachRecordVO.createDate;
    
}

@end
 
@interface YJYInsureGuideTeachListController ()
@property (strong, nonatomic) GetInusreOrderTeachRecordRsp *rsp;
@end

@implementation YJYInsureGuideTeachListController

+ (instancetype)instanceWithStoryBoard {
    
    NSString *className = NSStringFromClass([self class]);
    id vc = [UIStoryboard storyboardWithName:@"YJYInsureGuideTeach" viewControllerIdentifier:className];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadNetworkData];
    
}

- (void)loadNetworkData {
    
    GetOrderReq *req = [GetOrderReq new];
    req.orderId = self.orderDetailRsp.order.orderId;
    if (self.orderId) {
        req.orderId = self.orderId;
    }
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetInusreOrderTeachRecord message:req controller:self command:APP_COMMAND_SaasappgetInusreOrderTeachRecord success:^(id response) {
        
        self.rsp = [GetInusreOrderTeachRecordRsp parseFromData:response error:nil];
        [self reloadAllData];
        
    } failure:^(NSError *error) {
        
        [self reloadErrorData];
        
    }];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YJYInsureGuideTeachListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YJYInsureGuideTeachListCell" forIndexPath:indexPath];
    
    TeachRecordVO *teachRecordVO = self.rsp.recordListArray[indexPath.row];
    cell.teachRecordVO = teachRecordVO;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TeachRecordVO *teachRecordVO = self.rsp.recordListArray[indexPath.row];
    
    YJYInsureGuideTeachDetailController *vc = [YJYInsureGuideTeachDetailController instanceWithStoryBoard];
    vc.teachRecordVO = teachRecordVO;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.rsp.recordListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

@end
