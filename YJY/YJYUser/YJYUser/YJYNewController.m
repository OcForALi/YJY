//
//  YJYNewController.m
//  YJYUser
//
//  Created by wusonghe on 2017/5/2.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYNewController.h"
#import "AFImageDownloader.h"

@interface YJYNewController ()<UIScrollViewDelegate>

@end

@implementation YJYNewController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYNewController *)[UIStoryboard storyboardWithName:@"YJYNormal" viewControllerIdentifier:NSStringFromClass(self)];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.webView.frame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 60);
    self.webView.scrollView.delegate = self;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"分享" style:UIBarButtonItemStyleDone target:self action:@selector(shareAction:)];

}
//
//- (void)viewWillAppear:(BOOL)animated {
//    
//    [super viewWillAppear:animated];
//    
//    [self.navigationController.navigationBar lt_setBackgroundColor:kColorAlpha(0, 255, 0, 0)];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//    
//    
//}
//
//- (void)viewDidDisappear:(BOOL)animated {
//    
//    [super viewWillDisappear:animated];
//    
//    [self.navigationController.navigationBar lt_reset];
//   
//}

- (IBAction)backAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)shareAction:(id)sender {
    
    YJYShareView *shareView = [YJYShareView instancetypeWithXIB];
    shareView.frame = self.view.frame;
    
    [SYProgressHUD show];
    
    
    NSURLRequest *re = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.imgURL]];
    [[AFImageDownloader defaultInstance]downloadImageForURLRequest:re success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull responseObject) {
        
        NSData *imgData = UIImageJPEGRepresentation(responseObject, 0.1);
        UIImage *img = [UIImage imageWithData:imgData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            
            
            [SYProgressHUD hide];
            
            shareView.shareViewDidSelectBlock = ^(YJYShareType type) {
                
                
                OSMessage *msg=[[OSMessage alloc] init];
                msg.title = self.text;
                msg.image = img;
                msg.thumbnail = msg.image;
                msg.link= self.urlString;
                
                if (type == YJYShareTypeMoment) {
                    
                    [OpenShare shareToWeixinTimeline:msg Success:^(OSMessage *message) {
                        
                        [SYProgressHUD showToCenterText:@"分享成功"];
                        
                    } Fail:^(OSMessage *message, NSError *error) {
                    }];
                    
                }else if (type == YJYShareTypeQQ) {
                    
                    
                    msg.desc = msg.title;
                    
                    [OpenShare shareToQQFriends:msg Success:^(OSMessage *message) {
                        
                        [SYProgressHUD showToCenterText:@"分享成功"];
                        
                        
                    } Fail:^(OSMessage *message, NSError *error) {
                        
                        
                    }];
                    
                    
                }else if (type == YJYShareTypeWechat) {
                    
                    
                    [OpenShare shareToWeixinSession:msg Success:^(OSMessage *message) {
                        
                        [SYProgressHUD showToCenterText:@"分享成功"];
                        
                        
                    } Fail:^(OSMessage *message, NSError *error) {
                        
                        
                    }];
                }
                
            };
            [shareView showInView:nil];
        });
        
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
    
        
        [SYProgressHUD showFailureText:@"分享失败"];

    }];
    
   
    
}

- (void)loadTitle:(NSString *)title {
    
    self.title = self.text;
}

- (void)setInformation:(Information *)information {

    _information = information;
    self.urlString = information.URL;
    self.imgURL = information.imgURL;
    self.text = information.title;
    self.sketch = information.sketch;
    [self loadTitle:information.title];
}



@end
