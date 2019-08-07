//
//  YJYShareView.h
//  Scaffold
//
//  Created by wusonghe on 2017/2/23.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YJYShareType) {

    YJYShareTypeMoment,
    YJYShareTypeQQ,
    YJYShareTypeWechat,
    YJYShareTypeClose,
    
};

typedef void(^ShareViewDidSelectBlock)(YJYShareType type);

@interface YJYShareView : UIView

@property (copy, nonatomic) ShareViewDidSelectBlock shareViewDidSelectBlock;


+ (instancetype)instancetypeWithXIB;
- (void)showInView:(UIView *)view;
- (void)hidden;


//quick method

+ (instancetype)createShareViewAndShowInView:(UIView *)view;


@end
