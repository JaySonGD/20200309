//
//  TTZAirConditionController.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 17/1/2019.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import "TTZAirConditionController.h"

#import "TTZDetectResultCell.h"

#import "TTZPartsCell.h"

@interface TTZAirConditionController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TTZAirConditionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TTZDetectResultCell" bundle:nil] forCellReuseIdentifier:@"TTZDetectResultCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TTZPartsCell" bundle:nil] forCellReuseIdentifier:@"TTZPartsCell"];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.tableFooterView = [self finishButton];

//    self.tableView.sectionHeaderHeight = 54;
//    self.tableView.sectionFooterHeight = 10;
    //self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.01)];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.models.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.models[section][@"list"] count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *textLB = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, view.height)];
    textLB.text = self.models[section][@"title"];
    textLB.textColor = YHColorWithHex(0x222222);
    [view addSubview:textLB];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        TTZDetectResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TTZDetectResultCell"];
        cell.resultLB.text = self.models[indexPath.section][@"list"][indexPath.row][@"title"];
        return cell;
    }else if (indexPath.section == 1){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
         cell.textLabel.text = self.models[indexPath.section][@"list"][indexPath.row][@"title"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.textLabel.textColor = YHColorWithHex(0x333333);
        return cell;

    }
    
    TTZPartsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TTZPartsCell"];
    NSDictionary *obj = self.models[indexPath.section][@"list"][indexPath.row];
//    "partsName": "冷媒",        //配件名
//    "partNum": 9,        //数量
//    "partsUnit": "g",        //单位
    cell.partsNameLB.text = obj[@"partsName"];
    cell.partNumLB.text = [NSString stringWithFormat:@"%@",[obj[@"partNum"] integerValue]?obj[@"partNum"] : @"-"];
    cell.partsUnit.text = obj[@"partsUnit"];

    return cell;
}

- (UIView *)finishButton{
//    if (!_finishButton) {
         UIButton * _finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_finishButton setBackgroundColor:YHNaviColor];
        _finishButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
        [_finishButton setTitle:@"重新诊断" forState:UIControlStateNormal];
        [_finishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        kViewRadius(_finishButton, 8);
    [_finishButton addTarget:self action:@selector(popViewController:) forControlEvents:UIControlEventTouchUpInside];
        _finishButton.frame = CGRectMake(10, 10, screenWidth - 20, 44);
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 54)];
    [footer addSubview:_finishButton];
//    }
    return footer;
}


@end
