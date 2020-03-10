//
//  PurchaseSuccessViewController.m
//  CommunityFinance
//
//  Created by L on 15/10/13.
//  Copyright © 2015年 L. All rights reserved.
//

#import "PurchaseSuccessViewController.h"
@interface PurchaseSuccessViewController ()

@end

@implementation PurchaseSuccessViewController

- (instancetype)initWithStyle:(UITableViewStyle)style{
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购买成功";
    UIButton * leftBtn = [[UIButton alloc]init];
    leftBtn.frame = CGRectMake(0, 0, 30, 40);
    [leftBtn setImage:[UIImage imageNamed:@"navBack"] forState:UIControlStateNormal];
    //        [leftBtn setTitle:@"返回" forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [leftBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
}

- (void)back:(UIButton*)btn{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    return cell;
}



@end
