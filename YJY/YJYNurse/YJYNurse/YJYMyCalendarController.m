//
//  YJYMyCalendarController.m
//  YJYNurse
//
//  Created by wusonghe on 2017/5/19.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYMyCalendarController.h"
#import "YJYLongNurseDetailController.h"
#import "YJYOrderDetailController.h"
#import "YJYOrderCreateController.h"
#import "YJYInsureOrderDetailController.h"
#import "YJYCalendarView.h"

typedef void(^YJYCalendarCellDidSelectBlock)();

@interface YJYCalendarCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIView  *vLine;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;


@property (strong, nonatomic) MyScheduleVO *schedule;
@property (strong, nonatomic) CalendarListItem *listItem;

@property (copy, nonatomic) YJYCalendarCellDidSelectBlock didSelectBlock;

@end

@implementation YJYCalendarCell

- (void)setSchedule:(MyScheduleVO *)schedule {

    _schedule = schedule;
    self.titleLabel.text = schedule.serviceItem;
    self.nameLabel.text = [NSString stringWithFormat:@"被陪护人:%@",schedule.kinsName];
    self.addressLabel.text = [NSString stringWithFormat:@"%@:%@",@"服务地点",schedule.addrDetail];

    self.timeLabel.text = [NSString stringWithFormat:@"预约开始时间:%@",schedule.startDate];

    //
    if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeCustomManager) {
        
        if (self.listItem.type == YJYCalendarTypeOpenOrder) {
            
            self.stateLabel.text = schedule.conditionStr;
            [self.actionButton setTitle:@"开启服务" forState:0];
            
        }else if (self.listItem.type == YJYCalendarTypeContinueOrder) {
            
            self.stateLabel.text = [NSString stringWithFormat:@"离服务到期还%@天",@(schedule.dayNum)];
            [self.actionButton setTitle:@"续费" forState:0];

        }
        
    }else if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeWorker) {
        
        
        if (self.listItem.type == YJYCalendarTypeOpenOrder) {
            
            self.stateLabel.text = schedule.conditionStr;
            [self.actionButton setTitle:@"开启服务" forState:0];
            
        }else if (self.listItem.type == YJYCalendarTypeContinueOrder) {
            
            self.stateLabel.text = schedule.conditionStr;
            [self.actionButton setTitle:@"每日服务确认" forState:0];
            
        }
        

        
    }else if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurse) {
        
        if (self.listItem.type == YJYCalendarTypeApplyReview) {
            
            self.stateLabel.text = schedule.conditionStr;
            [self.actionButton setTitle:@"查看详情" forState:0];

            
        }else if (self.listItem.type == YJYCalendarTypeServiceBack) {
            
            self.stateLabel.text = schedule.conditionStr;
            [self.actionButton setTitle:@"查看详情" forState:0];


        }else if (self.listItem.type == YJYCalendarTypeCarePlan) {
            
            self.stateLabel.text = [NSString stringWithFormat:@"距上次更新已%@天",@(schedule.dayNum)];
            [self.actionButton setTitle:@"查看详情" forState:0];

            
        }
        
    }
   
}

- (IBAction)toAction:(id)sender {
    
    if (self.didSelectBlock) {
        self.didSelectBlock();
    }
    
}

@end

@interface YJYMyCalendarController ()

@property (strong, nonatomic) NSMutableArray<MyScheduleVO*> *scheduleListArray;
@property (assign, nonatomic) uint32_t pageNum;
@end

@implementation YJYMyCalendarController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYMyCalendarController *)[UIStoryboard storyboardWithName:@"YJYCalendars" viewControllerIdentifier:NSStringFromClass(self)];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.scheduleListArray = [NSMutableArray array];
    
    __weak __typeof(self)weakSelf = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.pageNum = 1;
        [weakSelf loadNetworkData];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        self.pageNum ++;
        [weakSelf loadNetworkData];
    }];
    
    if (!self.currentDate) {
        self.currentDate = [NSDate date];
    }
    
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self navigationBarAlphaWithWhiteTint];
    [self loadNetworkData];

}
- (void)setCurrentDate:(NSDate *)currentDate {
    
    _currentDate = currentDate;
    [self loadNetworkData];
}


- (void)loadNetworkData {
    /// 1-开启订单 2-续费订单 3-确认服务 4-申请评估 5-服务回访 6-照护计划制定
    GetScheduleReq *req = [GetScheduleReq new];
    req.pageNo = self.pageNum;
    req.pageSize = 20;
    req.tabType = self.listItem.type;
    req.date = [NSDate getRealDateTime:self.currentDate withFormat:YYYY_MM_DD];
    
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetSchedule  message:req controller:nil command:APP_COMMAND_SaasappgetSchedule success:^(id response) {
        
        
        GetScheduleRsp *rsp = [GetScheduleRsp parseFromData:response error:nil];
        
        if (self.pageNum > 1) {
            
            if (self.scheduleListArray.count >= rsp.scheduleListArray_Count) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                
                [self.scheduleListArray addObjectsFromArray:rsp.scheduleListArray];
                
            }
            
        }else {
            self.scheduleListArray = rsp.scheduleListArray;
            [self.tableView.mj_footer resetNoMoreData];
            
        }
        
        [self reloadAllData];
        
        
    } failure:^(NSError *error) {
        
        [self reloadErrorData];
        
        
    }];
    
   
}

#pragma mark - UITableView Delegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.scheduleListArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    YJYCalendarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YJYCalendarCell" forIndexPath:indexPath];
    MyScheduleVO *schedule = self.scheduleListArray[indexPath.row];

    cell.schedule = schedule;
    cell.didSelectBlock = ^{
      
        YJYInsureOrderDetailController *vc = [YJYInsureOrderDetailController instanceWithStoryBoard];
        vc.orderId = schedule.orderId;
        vc.insureNo = schedule.insureNo;
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    
    return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    MyScheduleVO *schedule = self.scheduleListArray[indexPath.row];
    [self toJumpWithSchedule:schedule];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 170;
}

- (void)toJumpWithSchedule:(MyScheduleVO *)schedule {
    
    
    if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeHealthManager) {
        
        if (self.listItem.type == YJYCalendarTypeOpenOrder) {
            
           
            
        }else if (self.listItem.type == YJYCalendarTypeContinueOrder) {
            
        
            
        }
        
    }else if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeWorker) {
        
        
        if (self.listItem.type == YJYCalendarTypeOpenOrder) {
            
           
            
        }else if (self.listItem.type == YJYCalendarTypeContinueOrder) {
            
          
            
        }
        
        
        
    }else if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurse) {
        
        if (self.listItem.type == YJYCalendarTypeApplyReview) {
            
        
            
            
        }else if (self.listItem.type == YJYCalendarTypeServiceBack) {
            
           
            
        }else if (self.listItem.type == YJYCalendarTypeCarePlan) {
            
            
        }
        
    }
}

- (void)toDetail {
    
    YJYInsureOrderDetailController *vc = [YJYInsureOrderDetailController instanceWithStoryBoard];
    
    
}




@end
