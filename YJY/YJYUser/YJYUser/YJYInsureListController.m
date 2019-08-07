//
//  YJYInsureListController.m
//  YJYUser
//
//  Created by wusonghe on 2017/5/2.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYInsureListController.h"
#import "YJYInsureDetailController.h"
@interface YJYInsureItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *beServiceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *processLabel;
@property (weak, nonatomic) IBOutlet UIButton *applyIdButton;

@property (strong, nonatomic) InsureVO *insure;

@end

@implementation YJYInsureItemCell

- (void)setInsure:(InsureVO *)insure {
    
    _insure = insure;
    
    //50-初审驳回 51-复审驳回 52-终审驳回
    
    if (insure.status == 50 ||
        insure.status == 51 ||
        insure.status == 52) {
        self.processLabel.textColor = APPREDCOLOR;
    }else {
    
        self.processLabel.textColor = APPHEXCOLOR;
    }
    self.beServiceLabel.text = [NSString stringWithFormat:@"被服务人：%@",insure.kinsName];
    self.timeLabel.text = [NSString stringWithFormat:@"申请时间：%@",insure.createTime];
    self.processLabel.text = [NSString stringWithFormat:@" 申请进度：%@",insure.statusDesc];
    [self.applyIdButton setTitle:[NSString stringWithFormat:@"   申请编号：%@",insure.insureNo]  forState:0];
    [self.applyIdButton sizeToFit];
    
}

@end

@interface YJYInsureListController ()
@property(nonatomic, strong) NSMutableArray<InsureVO*> *insureListArray;
@end

@implementation YJYInsureListController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYInsureListController *)[UIStoryboard storyboardWithName:@"YJYInsure" viewControllerIdentifier:NSStringFromClass(self)];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.insureListArray = [NSMutableArray array];
    
    
    __weak __typeof(self)weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadNetworkData];
    }];
    
    
    //left
    if (self.isProcess) {
        
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"app_back_icon" highImage:@"app_back_icon" target:self action:@selector(dismiss)];

    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self loadNetworkData];

}

- (void)loadNetworkData {
    
    
    [YJYNetworkManager requestWithUrlString:APPGetInsureList message:nil controller:self command:APP_COMMAND_AppgetInsureList success:^(id response) {
        
        GetInsureListRsp *rsp = [GetInsureListRsp parseFromData:response error:nil];
        
        self.insureListArray = rsp.insureListArray;
        [self reloadAllData];
        
    } failure:^(NSError *error) {
        [self reloadErrorData];
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.insureListArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    YJYInsureItemCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YJYInsureItemCell"];
    cell.insure = self.insureListArray[indexPath.row];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YJYInsureDetailController *vc = [YJYInsureDetailController instanceWithStoryBoard];
    InsureVO *insure = self.insureListArray[indexPath.row];
    vc.insreNO = insure.insureNo;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    return 133;
}

#pragma mark - action

- (void)dismiss {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kYJYHomeIndexSelectNotification object:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    });
}


@end
