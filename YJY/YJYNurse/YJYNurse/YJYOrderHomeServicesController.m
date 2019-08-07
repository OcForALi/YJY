//
//  YJYOrderHomeServicesController.m
//  YJYNurse
//
//  Created by wusonghe on 2017/6/19.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYOrderHomeServicesController.h"

@interface YJYOrderHomeServicesCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;

@property (strong, nonatomic) IndexServiceItem *item;

@end

@implementation YJYOrderHomeServicesCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    self.titleLabel.textColor = selected ? APPHEXCOLOR : APPNurseDarkGrayCOLOR;
    self.checkImageView.hidden = !selected;
    self.backgroundColor = selected ? APPSaasF4Color : [UIColor whiteColor];
}

- (void)setItem:(IndexServiceItem *)item {
    
    _item = item;
    
    self.titleLabel.text = item.iconDesc;
}

@end

@interface YJYOrderHomeServicesController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation YJYOrderHomeServicesController


+ (instancetype)instanceWithStoryBoard {
    
    return (YJYOrderHomeServicesController *)[UIStoryboard storyboardWithName:@"YJYOrderCreate" viewControllerIdentifier:NSStringFromClass(self)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [YJYSettingManager sharedInstance].items.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    YJYOrderHomeServicesCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YJYOrderHomeServicesCell"];
    IndexServiceItem *item = [YJYSettingManager sharedInstance].items[indexPath.row];
    cell.item = item;
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}
- (IBAction)done:(id)sender {
    
    IndexServiceItem *item = [YJYSettingManager sharedInstance].items[[self.tableView indexPathForSelectedRow].row];

    if (self.didSelectBlock) {
        self.didSelectBlock(item);
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}


@end
