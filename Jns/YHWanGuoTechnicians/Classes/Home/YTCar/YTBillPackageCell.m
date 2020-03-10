//
//  YTBillPackageCell.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 9/10/2019.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import "YTBillPackageCell.h"

#import "YTBillPackageModel.h"
#import "YTBillPackageSysCell.h"



@implementation YTBillPackageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.sysView.rowHeight = 44;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)swClick:(UISwitch *)sender {
    
//    if (!sender.isOn) {
//        [self.model.system_list enumerateObjectsUsingBlock:^(YTSystemPackageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            obj.is_check = NO;
//            [obj.child_system enumerateObjectsUsingBlock:^(YTSystemPackageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                obj.is_check = NO;
//            }];
//        }];
//    }
    
//    self.model.isOn = sender.isOn;
    self.model.is_check = sender.isOn;

    !(_reload)? : _reload();
}

- (void)setModel:(YTBillPackageModel *)model{
    _model = model;
    
    self.titleLB.text = model.title;
    self.priceLB.text = [NSString stringWithFormat:@"套餐价：%@元",model.sales_price];
    
    
    __block NSArray *disables = [model.system_list filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"status = 0"]];
    __block NSArray *checks = [model.system_list filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"is_check > 0"]];
    __block NSInteger checkCount = checks.count;
    //__block NSInteger disableCount = disables.count;

    __block BOOL hasDisable = NO;
    
    __block CGFloat h = 44 * model.system_list.count;
    [model.system_list enumerateObjectsUsingBlock:^(YTSystemPackageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if(!obj.is_check)
            h += obj.child_system.count * 44;
        if (!disables.count) {
            disables = [obj.child_system filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"status = 0"]];
        }
        
        if (!checks.count) {
            checks = [obj.child_system filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"is_check > 0"]];
        }
        checkCount += [obj.child_system filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"is_check > 0"]].count;
        //disableCount += [obj.child_system filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"status = 0"]].count;
        
        if(obj.status == 0 && !obj.is_check){
            hasDisable = YES;
        }
        
        [obj.child_system enumerateObjectsUsingBlock:^(YTSystemPackageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(obj.status == 0 && !obj.is_check){
                hasDisable = YES;
            }
        }];

    }];
    
    NSString *warranty_desc =  model.warranty_desc;
    if (model.limit_count) {
        warranty_desc = [NSString stringWithFormat:@"%@ (已选%ld/%ld)",model.warranty_desc,checkCount,(long)model.limit_count];
    }
    self.descLB.text = warranty_desc;
    
    [self.sysView reloadData];
    
    
//    self.editSw.hidden = !model.is_accept;
//    self.editSw.on = (checks.count || model.isOn);
    
    self.editSw.hidden = (model.status == 2);
    self.editSw.userInteractionEnabled = !(model.status == 0);
//    self.editSw.on = (checks.count || model.is_check);
    self.editSw.on = (model.is_check);

    if (self.editSw.isHidden || self.editSw.isOn) {
        self.priceBoxH.constant = 37;
        self.sysViewH.constant = h;
        self.disableBoxH.constant = hasDisable? 44:0;
//        self.disableBoxH.constant = disables.count? 44:0;
//        self.disableBoxH.constant = ((disableCount>0)&&(disableCount != checkCount))? 44:0;

    }else{
        self.priceBoxH.constant = 0;
        self.sysViewH.constant = 0;
        self.disableBoxH.constant = 0;
        
    }
    

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.model.system_list.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(self.model.system_list[section].is_check) return 1;
    
    return  self.model.system_list[section].child_system.count + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YTBillPackageSysCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.titleLeft.constant = indexPath.row? 24 :0;
    YTSystemPackageModel *m ;
    if(indexPath.row){
        m =  self.model.system_list[indexPath.section].child_system[indexPath.row-1];
    }else{
        m =  self.model.system_list[indexPath.section];
    }
    
    [cell.nameBtn setTitle:[NSString stringWithFormat:@"  %@",m.name] forState:UIControlStateNormal];
    
//status    string    是否可编辑：1-可编，0-不可编辑 ，2-隐藏选择框
//    is_check 1 0
//    if (m.status == 2) {
//        [cell.nameBtn setImage:nil forState:UIControlStateNormal];
//        cell.nameBtn.selected = NO;
//        cell.nameBtn.enabled = YES;
//    }else if (m.status == 0){
//        [cell.nameBtn setImage:[UIImage imageNamed:@"组 10031"] forState:UIControlStateDisabled];
//        cell.nameBtn.selected = NO;
//        cell.nameBtn.enabled = NO;
//    }else{
//        [cell.nameBtn setImage:[UIImage imageNamed:@"s_1"] forState:UIControlStateSelected];
//        [cell.nameBtn setImage:[UIImage imageNamed:@"s_0"] forState:UIControlStateNormal];
//
//        cell.nameBtn.selected = m.is_check;
//        cell.nameBtn.enabled = YES;
//    }
    
    if(m.is_check){
        
        if (m.status == 2) {
            [cell.nameBtn setImage:nil forState:UIControlStateNormal];
            cell.nameBtn.selected = YES;
//            cell.nameBtn.userInteractionEnabled = YES;
            cell.nameBtn.enabled = YES;

        }else if (m.status == 0){
            cell.nameBtn.selected = YES;
//            cell.nameBtn.userInteractionEnabled = NO;
            cell.nameBtn.enabled = YES;

        }else{
            [cell.nameBtn setImage:[UIImage imageNamed:@"s_1"] forState:UIControlStateSelected];
            [cell.nameBtn setImage:[UIImage imageNamed:@"s_0"] forState:UIControlStateNormal];
//            cell.nameBtn.userInteractionEnabled = YES;
            cell.nameBtn.selected = YES;
            cell.nameBtn.enabled = YES;
        }


    }else{
        if (m.status == 2) {
            [cell.nameBtn setImage:nil forState:UIControlStateNormal];
            cell.nameBtn.selected = NO;
//            cell.nameBtn.userInteractionEnabled = YES;
            cell.nameBtn.enabled = YES;
            
        }else if (m.status == 0){
            [cell.nameBtn setImage:[UIImage imageNamed:@"组 10031"] forState:UIControlStateDisabled];
            cell.nameBtn.selected = NO;
//            cell.nameBtn.userInteractionEnabled = YES;
            cell.nameBtn.enabled = NO;
            
        }else{
            [cell.nameBtn setImage:[UIImage imageNamed:@"s_1"] forState:UIControlStateSelected];
            [cell.nameBtn setImage:[UIImage imageNamed:@"s_0"] forState:UIControlStateNormal];
//            cell.nameBtn.userInteractionEnabled = YES;
            cell.nameBtn.selected = NO;
            cell.nameBtn.enabled = YES;
        }

    }
    
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YTSystemPackageModel *m ;
    NSInteger row = indexPath.row;
    if(row){
        m =  self.model.system_list[indexPath.section].child_system[indexPath.row-1];
    }else{
        m =  self.model.system_list[indexPath.section];
    }

    if (m.status == 1) {
        if (self.model.limit_count && !m.is_check) {
            __block CGFloat count=0;
            [self.model.system_list enumerateObjectsUsingBlock:^(YTSystemPackageModel * _Nonnull sobj, NSUInteger idx, BOOL * _Nonnull stop) {
                if(sobj.is_check) count += 1;
                [sobj.child_system enumerateObjectsUsingBlock:^(YTSystemPackageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if(obj.is_check) count += 1;
                }];
            }];
            if(count >= self.model.limit_count) {
                [MBProgressHUD showError:[NSString stringWithFormat:@"最多只能选择%ld个系统",(long)self.model.limit_count]];
                return;
            }
        }
        
        m.is_check = !m.is_check;
        if(!row) {
            [m.child_system enumerateObjectsUsingBlock:^(YTSystemPackageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                //obj.is_check = m.is_check;
                obj.is_check = NO;
            }];
            !(_reload)? : _reload();
        }
        else self.model = self.model;//[tableView reloadData];


    }
    

}


@end
