//
//  YJYInsurePorcessController.m
//  YJYNurse
//
//  Created by wusonghe on 2017/11/13.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYInsurePorcessController.h"

@interface YJYInsurePorcessCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet MDHTMLLabel *desLabel;
@property (strong, nonatomic) InsureNODetailVO *insureNODetailVO;
@end

@implementation YJYInsurePorcessCell

- (void)setInsureNODetailVO:(InsureNODetailVO *)insureNODetailVO {
    
    _insureNODetailVO = insureNODetailVO;
    
    self.titleLabel.text = insureNODetailVO.createTime;
    self.desLabel.htmlText = insureNODetailVO.content;
}

@end

#pragma mark - YJYInsurePorcessController

@interface YJYInsurePorcessController ()

@end

@implementation YJYInsurePorcessController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYInsurePorcessController *)[UIStoryboard storyboardWithName:@"YJYInsurePorcess" viewControllerIdentifier:NSStringFromClass(self)];
}

- (void)viewDidLoad {
    
    
    [super viewDidLoad];

    
    self.title = @"申请进度";
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);//导航栏如果使用系统原生半透明的，top设置为64

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.detailListArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    YJYInsurePorcessCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YJYInsurePorcessCell"];
    cell.insureNODetailVO = self.detailListArray[indexPath.row];
    
    cell.titleLabel.textColor = indexPath.row == 0 ? APPHEXCOLOR : APPDarkCOLOR;
    cell.desLabel.textColor = indexPath.row == 0 ? APPHEXCOLOR : APPDarkCOLOR;

    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    InsureNODetailVO *insureNODetailVO = self.detailListArray[indexPath.row];
    CGFloat width = self.tableView.frame.size.width - (35 + 17);
    
    CGFloat height = [MDHTMLLabel sizeThatFitsHTMLString:insureNODetailVO.content withFont:[UIFont systemFontOfSize:16] constraints:CGSizeMake(width, 0) limitedToNumberOfLines:0 autoDetectUrls:NO];
    
    return 65 + (height - 17);
    
}

@end
