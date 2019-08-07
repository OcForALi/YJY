//
//  YJYTableView.h
//  YJYUser
//
//  Created by wusonghe on 2017/4/11.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ReloadDidSelect)();

@interface YJYTableView : UITableView

@property (strong, nonatomic) UIButton *reloadButton;
@property (strong, nonatomic) UIImageView *emptyImageView;

@property (strong, nonatomic) UIView *emptyView;

@property (copy, nonatomic) ReloadDidSelect reloadDidSelect;

@property (strong, nonatomic) NSString *noDataTitle;
@property (strong, nonatomic) NSString *errorTitle;
@property (strong, nonatomic) UIImage *noDataImage;
@property (strong, nonatomic) UIImage *errorImage;


@property (assign, nonatomic) BOOL noShow;
@property (assign, nonatomic) CGFloat reloadButtonY;

- (void)reloadAllData;
- (void)reloadErrorData;
- (void)reloadAllDataAndView;
@end
