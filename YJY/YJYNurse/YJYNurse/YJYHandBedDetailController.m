//
//  YJYHandBedDetailController.m
//  YJYNurse
//
//  Created by wusonghe on 2018/8/15.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYHandBedDetailController.h"


@interface YJYHandBedDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@end

@implementation YJYHandBedDetailCell

@end

@interface YJYHandBedDetailController ()

@end

@implementation YJYHandBedDetailController
+ (instancetype)instanceWithStoryBoard {
    
    NSString *className = NSStringFromClass([self class]);
    id vc = [UIStoryboard storyboardWithName:@"YJYHandBed" viewControllerIdentifier:className];
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak __typeof(self)weakSelf = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadNetworkData];
    }];
    
    [self loadNetworkData];
}

- (void)loadNetworkData {
    
    [self reloadAllData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.hangServiceDateListArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    YJYHandBedDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YJYHandBedDetailCell"];
    cell.titleLab.text = self.hangServiceDateListArray[indexPath.row];
    
    return cell;
    
}



@end
