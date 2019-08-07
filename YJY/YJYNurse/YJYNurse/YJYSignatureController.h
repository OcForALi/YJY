//
//  YJYSignatureController.h
//  Scaffold
//
//  Created by wusonghe on 2017/2/25.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SignatureDidDone)();
typedef void(^SignatureDidReturnImage)(NSString *imageID,NSString *imageURL);

@interface YJYSignatureController : YJYViewController
@property (copy, nonatomic) SignatureDidDone didDone;
@property (copy, nonatomic) NSString *orderId;
@property (assign, nonatomic) BOOL isSetup;
@property (assign, nonatomic) BOOL isInsure;
@property (assign, nonatomic) BOOL isBackVC;

@property (copy, nonatomic) SignatureDidReturnImage didReturnImage;
@end
