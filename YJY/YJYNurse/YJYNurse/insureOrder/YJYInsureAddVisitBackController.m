//
//  YJYInsureAddVisitBackController.m
//  YJYNurse
//
//  Created by wusonghe on 2018/3/16.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYInsureAddVisitBackController.h"
#import "IQActionSheetPickerView.h"

@interface YJYInsureAddVisitBackContentController : YJYTableViewController
@property (strong, nonatomic) GetInsureOrderDetailRsp *orderDetailRsp;
@property (strong, nonatomic) NSDate *nowDate;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@end

@implementation YJYInsureAddVisitBackContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.nowDate = [NSDate date];
}

- (IBAction)toPickTimeAction:(id)sender {
    
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"时间选择" delegate:nil];

    picker.minimumDate = [NSDate dateWithTimeIntervalSince1970:0];
    picker.actionSheetPickerStyle = IQActionSheetPickerStyleDatePicker;
    picker.didSelectDate = ^(NSDate *date) {
        self.nowDate = date;
        self.timeLabel.text = [NSDate getRealDateTime:date withFormat:YYYY_MM_DD];
    };
    [picker setDate:[NSDate dateString:self.timeLabel.text Format:YYYY_MM_DD]];
    [picker show];
}

@end


@interface YJYInsureAddVisitBackController ()

@property (strong, nonatomic) YJYInsureAddVisitBackContentController *contentVC;
@end


@implementation YJYInsureAddVisitBackController



+ (instancetype)instanceWithStoryBoard {
    
    NSString *className = NSStringFromClass([self class]);
    id vc = [UIStoryboard storyboardWithName:@"YJYInsureBackVisitList" viewControllerIdentifier:className];
    return vc;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"YJYInsureAddVisitBackContentController"]) {
        
        self.contentVC = (YJYInsureAddVisitBackContentController *)segue.destinationViewController;
        self.contentVC.orderDetailRsp = self.orderDetailRsp;
    }
    
}
- (IBAction)done:(id)sender {
    
//    if (!(self.contentVC.nowDate && self.contentVC.contentTextView.text)) {
//        [SYProgressHUD showFailureText:@"请填写内容"];
//        return;
//    }
    
    [SYProgressHUD show];
    
    AddInsureOrderVisitReq *req = [AddInsureOrderVisitReq new];
    req.orderId = self.orderDetailRsp.order.orderId;
    req.visitTimeStr = [NSDate getRealDateTime:self.contentVC.nowDate withFormat:YYYY_MM_DD];
//    req.visitDetial = self.contentVC.contentTextView.text;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPAddInsureOrderVisit message:req controller:self command:APP_COMMAND_SaasappaddInsureOrderVisit success:^(id response) {
        [SYProgressHUD show];
        if (self.didDoneBlock) {
            self.didDoneBlock();
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
   
}

@end

