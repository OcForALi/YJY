//
//  YJYQRView.h
//  YJYNurse
//
//  Created by wusonghe on 2017/8/3.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^YJYFilterViewDidDoneBlock)(NSArray *illnesses);

@interface YJYFilterView : UIView

@property (weak, nonatomic) IBOutlet UIView *actionView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (copy, nonatomic) NSString *imgUrl;

@property(nonatomic) NSMutableArray<Illness*> *illnessListArray;
@property (copy, nonatomic) YJYFilterViewDidDoneBlock didDoneBlock;


+ (instancetype)instancetypeWithXIB;
- (void)showInView:(UIView *)view;
- (void)hidden;
@end
