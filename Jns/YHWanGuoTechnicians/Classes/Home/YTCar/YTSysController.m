//
//  YTSysController.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 3/9/2019.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import "YTSysController.h"
#import "UIView+add.h"

#import "YHCarPhotoService.h"
#import "YHWebFuncViewController.h"

#import "YTWarranty.h"
#import "YT4SCell.h"
#import "YTSysCell.h"
#import "YTFreeCell.h"

#import "AppDelegate.h"

@interface YTSysController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) YTExtended *model;
@end

@implementation YTSysController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"选择延保系统";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveSys)];
    //self.billId = @"21374";
    [self getData];
}



- (void)getData{
    //[self.view.subviews makeObjectsPerformSelector:@selector(setHidden:) withObject:@(YES)];
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hidden = YES;
    }];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[YHCarPhotoService new] getExtendedWarrantyPackageListBill_id:self.billId success:^(YTExtended *model) {
        
        //        YTExtended *model = [YTExtended new];
        //        YTWarranty *s0 = [YTWarranty new];
        //        s0.price = @"233.6";
        //        s0.system_name = @"AAA";
        //
        //        YTWarranty *s1 = [YTWarranty new];
        //        s1.system_name = @"AAA";
        //
        //        YTWarranty *c0 = [YTWarranty new];
        //        c0.system_name = @"BBB";
        //
        //        s1.child_system = @[c0];
        //
        //        YTWarranty *s2 = [YTWarranty new];
        //        s2.system_name = @"AAA";
        //
        //
        //        model.extended_warranty = @[s0,s1,s2];
        //
        //    model.ssss_price = @"233.6";
        //
        //[self.view.subviews makeObjectsPerformSelector:@selector(setHidden:) withObject:@(NO)];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.hidden = NO;
        }];

        self.model = model;
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:[error.userInfo valueForKey:@"message"]];
    }];
}

- (void)saveSys{
    
    NSMutableArray *extended_warranty = [NSMutableArray array];
    [self.model.extended_warranty enumerateObjectsUsingBlock:^(YTWarranty * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.check) {
            [extended_warranty addObject:@{
                                           @"system_id":obj.system_id,
                                           @"check":@(obj.check),
                                           @"price":obj.price,
                                           @"pid":@(0),
                                           }];
        }else{
            [obj.child_system enumerateObjectsUsingBlock:^(YTWarranty * _Nonnull cobj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (cobj.check) {
                    [extended_warranty addObject:@{
                                                   @"system_id":cobj.system_id,
                                                   @"check":@(cobj.check),
                                                   @"price":cobj.price,
                                                   @"pid":obj.system_id,
                                                   }];
                }
            }];
        }
    }];
    
    [[YHCarPhotoService new] saveExtendedWarrantyPackageBill_id:self.billId
                                                     ssss_price:[NSString stringWithFormat:@"%.2f",self.model.ssss_price.floatValue]
                                              extended_warranty:extended_warranty
                                                        success:^{
                                                            [MBProgressHUD showError:@"保存成功"];
                                                        } failure:^(NSError *error) {
                                                            [MBProgressHUD showError:[error.userInfo valueForKey:@"message"]];
                                                        }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.model? self.model.extended_warranty.count + 3 : 0;
    //    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    if (section == 0) {
    //        return 1;
    //    }
    //    if (section == 1) {
    //        return 5;
    //    }
    
    
    if (section && section <= self.model.extended_warranty.count) {
        return self.model.extended_warranty[section-1].child_system.count + 1;
    }
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 148;
    }
    if (indexPath.section <= self.model.extended_warranty.count) {
        
        YTWarranty *model = self.model.extended_warranty[indexPath.section-1];
        if (model.check && indexPath.row) {
            model.child_system[indexPath.row-1].check = NO;
            return 0;
        }
        
        return 60;
    }
    
    if (indexPath.section == self.model.extended_warranty.count+1) {
        return 144;
    }
    
    return 96;
    //    if(indexPath.section == 3){
    //        return 96;
    //    }
    //
    //    if(indexPath.section == 2){
    //        return 144;
    //    }
    //
    //    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0 ) {
        return 10;
    }
    
    if (self.model.extended_warranty.count &&  section <= self.model.extended_warranty.count) {
        if (section == 1 ) {
            return 48;
        }
        return 36;
    }else{
        return 10;
    }
    
    //    if (section == 0 ) {
    //        return 48;
    //    }
    //    if (section == 1) {
    //        return 36;
    //    }
    //    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    if (self.model.extended_warranty.count &&  section <= self.model.extended_warranty.count) {
        if (section == (self.model.extended_warranty.count)) {
            return 52.5;
        }
        return 12.5;
    }else{
        return 0;
    }
    
    //    if (section == 0 ) {
    //        return 12.5;
    //    }
    //    if (section == 1) {
    //       return 52.5;
    //    }
    //    return 0;
}

- (CGFloat )totalServicePrice{
    __block CGFloat total = 0;
    [self.model.extended_warranty enumerateObjectsUsingBlock:^(YTWarranty * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.check) {
            total += [obj.price floatValue];
        }else{
            [obj.child_system enumerateObjectsUsingBlock:^(YTWarranty * _Nonnull cobj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (cobj.check) total += [cobj.price floatValue];
            }];
        }
        
    }];
    return total;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *hv = [UIView new];
    hv.backgroundColor = YHColorWithHex(0xF0F0F0);
    
    if (self.model.extended_warranty.count && section > 0 && section <= self.model.extended_warranty.count) {
        
        UIView *box = [[UIView alloc] initWithFrame:CGRectMake(12, 0, screenWidth - 24,(section == (self.model.extended_warranty.count))? 52.5:12.5)];
        box.backgroundColor = [UIColor whiteColor];
        [hv addSubview:box];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(12, 12, box.bounds.size.width - 24, 0.5)];
        line.backgroundColor = YHColorWithHex(0xE5E5E5);
        [box addSubview:line];
        if (section == (self.model.extended_warranty.count) ) {
            
            UILabel *syL = [[UILabel alloc] initWithFrame:CGRectMake(12, 24.5, 200, 16)];
            [box addSubview:syL];
            syL.font = [UIFont systemFontOfSize:16];
            syL.textColor = YHColorWithHex(0x666666);
            syL.text = @"服务总计";
            
            UILabel *pyL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(line.frame)-300, 24.5, 300, 16)];
            [box addSubview:pyL];
            pyL.font = [UIFont systemFontOfSize:16];
            pyL.textColor = YHColorWithHex(0x666666);
            pyL.textAlignment = NSTextAlignmentRight;
            pyL.text = [NSString stringWithFormat:@"¥ %.2f",[self totalServicePrice]];
            
            [box setRounded:box.bounds corners:UIRectCornerBottomLeft|UIRectCornerBottomRight radius:10];
            
            
        }
        
    }else{
        
    }
    
    //    if (section == 0 || section == 1) {
    //        UIView *box = [[UIView alloc] initWithFrame:CGRectMake(12, 0, screenWidth - 24,section? 52.5:12.5)];
    //        box.backgroundColor = [UIColor whiteColor];
    //        [hv addSubview:box];
    //
    //        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(12, 12, box.bounds.size.width - 24, 0.5)];
    //        line.backgroundColor = YHColorWithHex(0xE5E5E5);
    //        [box addSubview:line];
    //
    //
    //
    //        if (section == 1) {
    //
    //            UILabel *syL = [[UILabel alloc] initWithFrame:CGRectMake(12, 24.5, 200, 16)];
    //            [box addSubview:syL];
    //            syL.font = [UIFont systemFontOfSize:16];
    //            syL.textColor = YHColorWithHex(0x666666);
    //            syL.text = @"我的方法";
    //
    //            UILabel *pyL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(line.frame)-300, 24.5, 300, 16)];
    //            [box addSubview:pyL];
    //            pyL.font = [UIFont systemFontOfSize:16];
    //            pyL.textColor = YHColorWithHex(0x666666);
    //            pyL.textAlignment = NSTextAlignmentRight;
    //            pyL.text = @"我的方法";
    //
    //            [box setRounded:box.bounds corners:UIRectCornerBottomLeft|UIRectCornerBottomRight radius:10];
    //
    //
    //        }
    //    }
    return hv;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *hv = [UIView new];
    hv.backgroundColor = YHColorWithHex(0xF0F0F0);
    if (self.model.extended_warranty.count && section  > 0 && section <= self.model.extended_warranty.count) {
        UIView *box = [[UIView alloc] initWithFrame:CGRectMake(12, (section>1)?0:12, screenWidth - 24, (section>1)?36:48)];
        box.backgroundColor = [UIColor whiteColor];
        [hv addSubview:box];
        UILabel *syL = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, 200, 20)];
        [box addSubview:syL];
        syL.font = [UIFont systemFontOfSize:20];
        syL.textColor = YHColorWithHex(0x333333);
        syL.text = self.model.extended_warranty[section-1].system_name;//@"我的方法";
        
        if(section == 1) [box setRounded:box.bounds corners:UIRectCornerTopLeft|UIRectCornerTopRight radius:10];
        
    }
    //    if (section == 0 || section == 1) {
    //        UIView *box = [[UIView alloc] initWithFrame:CGRectMake(12, section?0:12, screenWidth - 24, section?36:48)];
    //        box.backgroundColor = [UIColor whiteColor];
    //        [hv addSubview:box];
    //        UILabel *syL = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, 200, 20)];
    //        [box addSubview:syL];
    //        syL.font = [UIFont systemFontOfSize:20];
    //        syL.textColor = YHColorWithHex(0x333333);
    //        syL.text = @"我的方法";
    //
    //        if(section == 0) [box setRounded:box.bounds corners:UIRectCornerTopLeft|UIRectCornerTopRight radius:10];
    //
    //    }
    return hv;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section > self.model.extended_warranty.count+1){
        YT4SCell *cell = [tableView dequeueReusableCellWithIdentifier:@"4s"];
        cell.model = self.model;
        return cell;
    }
    
    if(indexPath.section == self.model.extended_warranty.count+1){
        YTFreeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"free"];
        cell.model = self.model;
        return cell;
    }
    
    if(indexPath.section == 0){
        YTFreeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"phone"];
        cell.model = self.model;
        return cell;
    }
    
    YTSysCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    YTWarranty *model = self.model.extended_warranty[indexPath.section-1];
    if (indexPath.row==0) {
        cell.model = model;
    }else{
        cell.model = model.child_system[indexPath.row-1];
    }
    cell.reloadBlock = ^{
        [tableView reloadData];
    };
    return cell;
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (IBAction)createReport:(UIButton *)sender {
    
    if(self.model.phone.length != 11) {
        [MBProgressHUD showError:@"手机号码有误！"];
        return;
    }
    
    NSMutableArray *extended_warranty = [NSMutableArray array];
    [self.model.extended_warranty enumerateObjectsUsingBlock:^(YTWarranty * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.check) {
            [extended_warranty addObject:@{
                                           @"system_id":obj.system_id,
                                           @"check":@(obj.check),
                                           @"price":obj.price,
                                           @"pid":@(0),
                                           }];
        }else{
            [obj.child_system enumerateObjectsUsingBlock:^(YTWarranty * _Nonnull cobj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (cobj.check) {
                    [extended_warranty addObject:@{
                                                   @"system_id":cobj.system_id,
                                                   @"check":@(cobj.check),
                                                   @"price":cobj.price,
                                                   @"pid":obj.system_id,
                                                   }];
                }
            }];
        }
    }];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[YHCarPhotoService new] saveExtendedWarrantyPackageBill_id:self.billId
                                                     ssss_price:[NSString stringWithFormat:@"%.2f",self.model.ssss_price.floatValue]
                                              extended_warranty:extended_warranty
                                                        success:^{
                                                            
                                                            [[YHCarPhotoService new] saveStorePushExtWarrantyReportBill_id:self.billId phone:self.model.phone syncWarrantyPhone:self.model.check success:^{
                                                                
                                                                [MBProgressHUD hideHUDForView:self.view animated:YES];

                                                                YHWebFuncViewController *controller = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
                                                                
                                                                AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;

                                                                 NSString *h5Source = app.h5Source;
                                                                
                                                                if (!IsEmptyStr(h5Source)) {
                                                                    h5Source = [NSString stringWithFormat:@"homeToCheck=%@&",h5Source];
                                                                }else{
                                                                    h5Source = @"";
                                                                }

                                                                //http://www.mhace.cn/jnsDev/index.html?token=a4e5dc67db9033c36f168bad56454e0a&billId=18950&jnsAppStep=Y002_report&jnsAppStatus=android#/appToH5
                                                                NSString *urlString = [NSString stringWithFormat:@"%@/index.html?token=%@&bill_id=%@&jnsAppStep=Y002_report&jnsAppStatus=ios&%@#/appToH5",SERVER_PHP_URL_Statements_H5_Vue,[YHTools getAccessToken],self.billId,h5Source];
                                                                
                                                                controller.urlStr = urlString;
                                                                controller.barHidden = YES;
                                                                
                                                                if(!IsEmptyStr(h5Source)){
                                                                    
                                                                    self.navigationController.viewControllers = @[self.navigationController.viewControllers.firstObject,self.navigationController.viewControllers[1],controller];

                                                                    return;
                                                                }

                                                                
                                                                NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:10];
                                                                [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                                                    
                                                                    [viewControllers addObject:obj];
                                                                    if([obj isKindOfClass:NSClassFromString(@"YHOrderListController")] ){//有详情页只去掉信息确认页
                                                                        [viewControllers addObject:controller];
                                                                        *stop = YES;
                                                                    }
                                                                }];
                                                                
                                                                if ([viewControllers containsObject:controller]) {
                                                                    self.navigationController.viewControllers = viewControllers;
                                                                    return ;
                                                                }
                                                                
                                                                YHWebFuncViewController *webList = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
                                                                
                                                                webList.urlStr = [NSString stringWithFormat:@"%@/index.html?token=%@&bill_id=%@&jnsAppStep=Y002_list&jnsAppStatus=ios&menuCode=menu_block_policy&billType=,Y002,A#/appToH5",SERVER_PHP_URL_Statements_H5_Vue,[YHTools getAccessToken],self.billId];
                                                                webList.barHidden = YES;

                                                                
                                                                self.navigationController.viewControllers = @[self.navigationController.viewControllers.firstObject,webList,controller];
                                                                
                                                                
                                                            } failure:^(NSError *error) {
                                                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                [MBProgressHUD showError:[error.userInfo valueForKey:@"message"]];
                                                            }];
                                                            
                                                        } failure:^(NSError *error) {
                                                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                            [MBProgressHUD showError:[error.userInfo valueForKey:@"message"]];
                                                        }];
}

@end
