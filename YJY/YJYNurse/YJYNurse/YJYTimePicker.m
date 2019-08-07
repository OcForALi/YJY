//
//  YJYTimePicker.m
//  YJYUser
//
//  Created by wusonghe on 2017/4/5.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYTimePicker.h"
#import "YJYTimeDayCell.h"
#import "YJYTimeDateCell.h"

#define ZXHScreenHeight [UIScreen mainScreen].bounds.size.height
#define ZXHScreenWidth [UIScreen mainScreen].bounds.size.width



@interface YJYTimePicker () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (weak, nonatomic) IBOutlet UIView *actionView;
@property (weak, nonatomic) IBOutlet UIView *bgView;


@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;

//@property (strong, nonatomic) NSMutableArray *days;
//@property (nonatomic, strong) NSMutableArray *dates;

@property (nonatomic, strong) NSMutableArray<TimeData*> *timeDateListArray;
@property (strong, nonatomic) TimeData *currentTimeData;
@property (strong, nonatomic) OrderTimeData *currentOrderTimeData;
@property (strong, nonatomic) NSMutableArray *privateTimes;

//@property (assign, nonatomic) NSInteger morningIndex;
//@property (assign, nonatomic) NSInteger afternoonIndex;

@end

@implementation YJYTimePicker


+ (instancetype)instancetypeWithXIB {
    
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]firstObject];
}



- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    
    self.cancelButton.layer.cornerRadius = self.cancelButton.frame.size.height/2;
    self.cancelButton.layer.borderColor = APPHEXCOLOR.CGColor;
    self.cancelButton.layer.borderWidth = 1;
    
    self.confirmButton.layer.cornerRadius = self.confirmButton.frame.size.height/2;
    self.confirmButton.layer.borderColor = APPHEXCOLOR.CGColor;
    self.confirmButton.layer.borderWidth = 1;
    
    
    [self.leftTableView registerNib:[UINib nibWithNibName:@"YJYTimeDayCell" bundle:nil] forCellReuseIdentifier:@"YJYTimeDayCell"];
    
    [self.rightTableView registerNib:[UINib nibWithNibName:@"YJYTimeDateCell" bundle:nil] forCellReuseIdentifier:@"YJYTimeDateCell"];
    
    
    self.timeDateListArray = [NSMutableArray array];
    self.privateTimes = [NSMutableArray array];
    
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidden)];
    [self.bgView addGestureRecognizer:tap];
    
    
    self.leftTableView.mj_insetT = 6;
    self.leftTableView.mj_insetB = 6;
    
    if (self.orderType == 1) {
    
        self.rightTableView.mj_insetT = 20;
        self.rightTableView.mj_insetB = 20;
        
    }else {
    
        self.rightTableView.mj_insetT = 7.5;
        self.rightTableView.mj_insetB = 6;
        
    }

}

- (void)loadNetwork {

    GetOrderTimeReq *req = [GetOrderTimeReq new];
    
    req.orderType = (uint32_t)self.orderType;
    [YJYNetworkManager requestWithUrlString:APPGetOrderTime message:req controller:nil command:APP_COMMAND_AppgetOrderTime success:^(id response) {
        
        GetOrderTimeRsp *rsp = [GetOrderTimeRsp parseFromData:response error:nil];
        self.timeDateListArray = rsp.timeDateListArray;
        self.currentTimeData = self.timeDateListArray.firstObject;

        
        [self.leftTableView reloadData];
        [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];

        
        if (self.orderType == 2) {
            
            [self setupPrivateTimes];
            
        }else {
            
            [self setupMListArray];
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        
    }];
    
}


- (void)setupPrivateTimes {

    
    self.privateTimes = [NSMutableArray array];
    
   
    
    NSString *morning = @"上午";
    [self.privateTimes addObject:morning];
    if (self.currentTimeData.dayTimeData.amListArray.count > 0) {
        
        [self.privateTimes addObjectsFromArray:self.currentTimeData.dayTimeData.amListArray];
    }
    NSString *afternoon = @"下午";
    [self.privateTimes addObject:afternoon];
    if (self.currentTimeData.dayTimeData.pmListArray.count > 0) {
        
        [self.privateTimes addObjectsFromArray:self.currentTimeData.dayTimeData.pmListArray];
    }
    
    [self.rightTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        for (NSInteger i = 0; i < self.privateTimes.count; i++) {
            
            id timeData = self.privateTimes[i];
            
            if ([timeData isKindOfClass:[OrderTimeData class]] && [(OrderTimeData *)timeData status]) {
                
                [self.rightTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
                self.currentOrderTimeData = timeData;
                break;
            }
            
            
        };
    });
    
    

}

- (void)setupMListArray {
    
    
    if (self.currentTimeData.dayTimeData.mListArray.count > 0) {
        
        [self.rightTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            for (NSInteger i = 0; i < self.currentTimeData.dayTimeData.mListArray.count; i++) {
                
                OrderTimeData *timeData = self.currentTimeData.dayTimeData.mListArray[i];
                
                if (timeData.status) {
                    [self.rightTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
                    self.currentOrderTimeData = timeData;
                    break;
                }
                
                
            };
            
          

        });
        
    }
  


    
}
#pragma mark - UITableViewDelegate && UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.leftTableView) {
        return self.timeDateListArray.count;
    }
    
    if (self.orderType == 2) {
        return self.privateTimes.count;
    }else {
        return self.currentTimeData.dayTimeData.mListArray.count;

    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.leftTableView) {
    
        YJYTimeDayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YJYTimeDayCell"];
        cell.timeData = self.timeDateListArray[indexPath.row];
        return cell;

    }else {
    
        YJYTimeDateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YJYTimeDateCell"];
        
        
        if (self.orderType == 2) {
            
            if ([self.privateTimes[indexPath.row] isKindOfClass:[OrderTimeData class]]) {
                cell.orderTimeData = self.privateTimes[indexPath.row];
                cell.dateLabel.textColor = APPDarkGrayCOLOR;
            }else {
                cell.dateLabel.textColor = APPDarkCOLOR;
                cell.dateLabel.text = self.privateTimes[indexPath.row];
            }
            
        }else{
        
            cell.orderTimeData = self.currentTimeData.dayTimeData.mListArray[indexPath.row];

        }
        
        return cell;
    
    }
    
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (tableView == self.leftTableView) {
    
        self.currentTimeData = self.timeDateListArray[indexPath.row];

        if (self.orderType == 2) {
        
            [self setupPrivateTimes];
            
        }else {
        
            [self setupMListArray];
           
        }
        
       
        
    }else {
    
        if (self.orderType == 2) {
            
            if ([self.privateTimes[indexPath.row] isKindOfClass:[OrderTimeData class]]) {
                
                self.currentOrderTimeData = self.privateTimes[indexPath.row];
               
            }
            
        }else {
            
            OrderTimeData *orderTimeData =  self.currentTimeData.dayTimeData.mListArray[indexPath.row];
            self.currentOrderTimeData = orderTimeData;
            if (!orderTimeData.status) {
                return;
            }
        }
        
    }

    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.rightTableView == tableView && self.orderType == 2) {
        
        if (indexPath.row == 0 ||
            indexPath.row == self.currentTimeData.dayTimeData.amListArray.count + 1) {
            return 45;
        }else {
            return 30;

        }
    }
    return 50;
}


//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//
//    return 40;
//}
#pragma mark - show & hide
#define kActionViewHeight 400
- (void)showInView:(UIView *)view {
    
    if ([view.subviews containsObject:self]) {
        [self removeFromSuperview];
    }
    
    if (!view) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    
    self.frame = view.bounds;
    [view addSubview:self];
    
    self.backgroundColor = kColorAlpha(0, 0, 0, 0.5);
    self.actionView.transform = CGAffineTransformMakeTranslation(0, kActionViewHeight);
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.actionView.transform = CGAffineTransformIdentity;
    }];
}

- (void)hidden {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.backgroundColor = [UIColor clearColor];
        self.actionView.transform = CGAffineTransformMakeTranslation(0, kActionViewHeight);
    }completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
}
- (IBAction)closeAction:(id)sender {
    
    [self hidden];
}
- (IBAction)confirmAction:(id)sender {
    
    

    if (!self.currentOrderTimeData) {
        [SYProgressHUD showFailureText:@"请选择具体时间"];
        return;
    }

    if (self.timePickerDidSelectBlock) {
        self.timePickerDidSelectBlock(self.currentTimeData,self.currentOrderTimeData);
        [self hidden];

    }
}

@end
