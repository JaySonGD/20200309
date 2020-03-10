//
//  YHAuctionRulesViewController.m
//  YHCaptureCar
//
//  Created by mwf on 2018/1/15.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHAuctionRulesViewController.h"
#import "YHCommon.h"
#import "YHCaptureCarCell4.h"
#import "UITableView+FDTemplateLayoutCell.h"


@interface YHAuctionRulesViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation YHAuctionRulesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerNib:[UINib nibWithNibName:@"YHCaptureCarCell4" bundle:nil] forCellReuseIdentifier:@"YHCaptureCarCell4"];
}

#pragma mark - 列表代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YHCaptureCarCell4 *cell = [tableView dequeueReusableCellWithIdentifier:@"YHCaptureCarCell4"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float h =[tableView fd_heightForCellWithIdentifier:@"YHCaptureCarCell4" configuration:^(YHCaptureCarCell4* cell) {
        
    }];
    return h;
}

@end
