//
//  YTBillPackageCellOne.m
//  YHWanGuoTechnicians
//
//  Created by Liangtao Yu on 2019/10/23.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import "YTBillPackageCellOne.h"
#import "YTBillPackageSysCell.h"
#import "YTPlanModel.h"

@implementation YTBillPackageCellOne

-(void)setModel:(packageOwnerModel *)model{
    
    _model = model;
    self.descLb.text = model.warranty_desc;
    self.priceLb.text = [NSString stringWithFormat:@"套餐价:%@元",model.sales_price];
    self.taoCanLb.text = model.title;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.model.system_names.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.model.system_names[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"0x2a2a2a"];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 30;
}



@end
