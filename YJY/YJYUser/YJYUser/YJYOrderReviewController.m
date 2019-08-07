//
//  YJYOrderReviewController.m
//  YJYUser
//
//  Created by wusonghe on 2017/3/3.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYOrderReviewController.h"
#import "RateStarView.h"


@interface YJYOrderReviewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UIView *rateContainView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIView *rateTextView;

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (strong, nonatomic) RateStarView *starView;
@property (strong, nonatomic) OrderPraise *model;
@end

@implementation YJYOrderReviewController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYOrderReviewController *)[UIStoryboard storyboardWithName:@"YJYOrder" viewControllerIdentifier:NSStringFromClass(self)];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
  
    self.starView = [[RateStarView alloc] initWithNormalImage:[UIImage imageNamed:@"order_star_normal"] selectedImage:[UIImage imageNamed:@"order_star_press"] padding:0];
    self.starView.frame = self.rateContainView.bounds;
    self.starView.score = 5;
    
    self.rateContainView.backgroundColor = [UIColor clearColor];
    [self.rateContainView addSubview:self.starView];
    
    //place
    
    [self.confirmButton setTitle:self.isEdit ? @"提交评价" :@"确定" forState:0];
    self.textView.userInteractionEnabled = self.isEdit;
    self.starView.userInteractionEnabled = self.isEdit;
    self.recordButton.hidden = !self.isEdit;
    
    if (!self.isEdit) {
        [SYProgressHUD show];
        [self loadNetworkData];

    }else {
        
//        self.textView.placeholder = @"写下真实服务评价，我们将根据你的意见不断升级优化，为您提供更优质的服务";
        
    }
}


- (void)loadNetworkData {
    
    GetOrderPraiseReq *req = [GetOrderPraiseReq new];
    req.orderId = self.order.orderId;
    
    [YJYNetworkManager requestWithUrlString:APPGetOrderPraise message:req controller:self command:APP_COMMAND_AppgetOrderPraise success:^(id response) {
        
        [SYProgressHUD hide];
        GetOrderPraiseRsp *rsp = [GetOrderPraiseRsp parseFromData:response error:nil];
        self.model = rsp.model;
        [self setupModel];
        
    } failure:^(NSError *error) {
        
    }];

}

- (void)setupModel {

    
    self.starView.score = self.model.grade1;
    self.textView.text = self.model.content;
    
}

- (IBAction)confirmAction:(id)sender {
    
    if ([self.confirmButton.currentTitle isEqualToString:@"提交评价"]) {

        [SYProgressHUD show];
        
        SaveOrderPraiseReq *req = [SaveOrderPraiseReq new];
        req.orderId = self.order.orderId;
        req.grade = (uint32_t)self.starView.score;
        req.content = self.textView.text;
        

        [YJYNetworkManager requestWithUrlString:APPSaveOrderPraise message:req controller:self command:APP_COMMAND_AppsaveOrderPraise success:^(id response) {
            
            [SYProgressHUD showSuccessText:@"成功提交"];
            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(NSError *error) {
            
        }];
        
    }else {
    
        [self.navigationController popViewControllerAnimated:YES];

    }
    
 
}

@end
