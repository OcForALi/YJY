//
//  YJYLanguagesController.m
//  YJYNurse
//
//  Created by wusonghe on 2017/6/19.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYLanguagesController.h"

#pragma mark - YJYLanguagesContentController

@interface YJYLanguagesCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;

@property (strong, nonatomic) Language *language;

@end

@implementation YJYLanguagesCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    self.titleLabel.textColor = selected ? APPHEXCOLOR : APPNurseDarkGrayCOLOR;
    self.backgroundColor = selected ? APPSaasF4Color : [UIColor whiteColor];
    self.checkImageView.hidden = !selected;
}

- (void)setLanguage:(Language *)language {
    
    _language = language;
    self.titleLabel.text = language.name;
}

@end

@interface YJYLanguagesContentController : YJYTableViewController
@property (strong, nonatomic) GPBUInt32Array *languageArray;
@end

@implementation YJYLanguagesContentController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self loadLans];
}

- (void)loadLans {
    
    [self.languageArray enumerateValuesWithBlock:^(uint32_t value, NSUInteger idx, BOOL *stop) {
        
        NSInteger index = value - 1;
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.tableView selectRowAtIndexPath:newIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [YJYSettingManager sharedInstance].languageList.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    YJYLanguagesCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YJYLanguagesCell"];
    Language *language = [YJYSettingManager sharedInstance].languageList[indexPath.row];
    cell.language = language;
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {

    return YES;
}

@end

#pragma mark - YJYLanguagesController

@interface YJYLanguagesController ()

@property (strong, nonatomic) YJYLanguagesContentController *contentVC;

@end

@implementation YJYLanguagesController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYLanguagesController *)[UIStoryboard storyboardWithName:@"YJYNormal" viewControllerIdentifier:NSStringFromClass(self)];
}
- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    
    if ([segue.identifier isEqualToString:@"YJYLanguagesContentController"]) {
        self.contentVC = segue.destinationViewController;
        self.contentVC.languageArray = self.languageArray;
    }
}

- (IBAction)done:(id)sender {
    
    
    GPBUInt32Array *larry = [GPBUInt32Array array];
    [larry removeAll];
    
    NSMutableArray *lans = [NSMutableArray array];

    for (NSInteger i = 0; i < [self.contentVC.tableView indexPathsForSelectedRows].count; i++) {
        
        NSIndexPath *indexPath = [self.contentVC.tableView indexPathsForSelectedRows][i];
        
        Language *language = [YJYSettingManager sharedInstance].languageList[indexPath.row];
        
        [lans addObject:language.name];
         [larry insertValue:(uint32_t)language.id_p atIndex:i];
    }
    
    if (self.didSelectBlock) {
        self.didSelectBlock(larry,[lans componentsJoinedByString:@","]);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
   
    
    
}

@end
