//
//  YJYTableViewController.h
//  YJYUser
//
//  Created by wusonghe on 2017/3/6.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDHTMLLabel.h"

typedef NS_ENUM(NSInteger, NoDataShowType) {

    NoDataShowTypeImgButton,
    NoDataShowTypeDesButton
};

@interface YJYTableViewController : UITableViewController<MDHTMLLabelDelegate>

@property (strong, nonatomic) UIView *emptyView;
@property (copy, nonatomic) NSString *descTitle;
@property (copy, nonatomic) NSString *noDataTitle;
@property (copy, nonatomic) NSString *errorTitle;


@property (strong, nonatomic) UIButton *reloadButton;
@property (strong, nonatomic) UILabel  *descriptionLabel;

@property (strong, nonatomic) UIImageView *emptyImageView;
@property (strong, nonatomic) UIImage *noDataImage;
@property (strong, nonatomic) UIImage *errorImage;


@property (assign, nonatomic) BOOL isLayout;
@property (assign, nonatomic) BOOL isNaviError;

@property (assign, nonatomic) NoDataShowType dataShowType;

- (void)reloadAllData;
- (void)reloadErrorData;
- (void)reloadAllDataAndView;
+ (instancetype)instanceWithStoryBoard;

@end
