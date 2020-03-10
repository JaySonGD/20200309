//
//  YHWorkboardListController.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/12/26.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHWorkboardListController.h"

#import "YHNoDataCell.h"
#import "YHWorkboardCell.h"
#import "YHStroreOrderCell.h"

#import "YHNetworkPHPManager.h"

#import "YHTools.h"
#import "YHGTLCalendar.h"
#import "YHWorkboardDetailController.h"
#import "UIAlertView+Block.h"
#import "YHWebFuncViewController.h"
#import "NSMutableArray+YH.h"
#import "AppDelegate.h"
#import "UIAlertController+Blocks.h"
#import "YHWorkbordNewController.h"

#import "YHHomeModel.h"

extern NSString *const notificationConditionDate;
@interface YHWorkboardListController ()<UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *dateB;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchKeyFT;

//门店预订单
@property (weak, nonatomic) IBOutlet UIButton *storeOrderButton;


@property (strong, nonatomic)NSArray *dataSource;
@property (strong, nonatomic)NSMutableArray *dataSourceShow;
@property (strong, nonatomic)UIActionSheet *sheet;
@property (strong, nonatomic)NSString *fromDate;

@property (nonatomic, strong) NSMutableArray *tempArray;
@end

@implementation YHWorkboardListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.storeOrderButton.hidden = YES;

    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(notificationConditionDate:) name:notificationConditionDate object:nil];
//    [self reupdataDatasource];
    NSString  *dateStr = [YHTools stringFromDate:[NSDate date] byFormatter:@"MM-dd"];
    _dateB.titleLabel.text = dateStr;
    [_dateB setTitle:dateStr forState:UIControlStateNormal];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"YHNoDataCell" bundle:nil] forCellReuseIdentifier:@"YHNoDataCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"YHStroreOrderCell" bundle:nil] forCellReuseIdentifier:@"YHStroreOrderCell"];
    
    //判断是否有门店预订单MWF
    self.isHaveStoreOrder = NO;
    for (YHHomeModel *model in self.homeArray) {
        if ([model.code isEqualToString:@"bill_car_maintain"] && [model.status isEqualToString:@"1"]) {
            self.isHaveStoreOrder = YES;
        }
    }
}

- (IBAction)lookUpStoreorder:(UIButton *)sender
{
    YHWebFuncViewController *controller = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
    controller.urlStr = [NSString stringWithFormat:@"%@%@/detection/index.html?token=%@&status=ios#/Custome",SERVER_PHP_URL_Statements_H5,SERVER_PHP_H5_Trunk, [YHTools getAccessToken]];
    [self.navigationController pushViewController:controller animated:YES];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self reupdataDatasource];
}

- (void)notificationConditionDate:(NSNotification*)notice{
    NSDictionary *userInfo = notice.userInfo;
    self.fromDate = userInfo[@"fromDate"];
    _dateB.titleLabel.text = [self.fromDate substringWithRange:NSMakeRange(5, 5)];
    [_dateB setTitle:[self.fromDate substringWithRange:NSMakeRange(5, 5)] forState:UIControlStateNormal];
    [self sortListBy:_fromDate orKey:nil];
}

- (void)sortListBy:(NSString*)date orKey:(NSString*)key{
    
    [self.tempArray removeAllObjects];

    if (date) {
        for (NSInteger i = 0; _dataSourceShow.count > i; i++) {
            NSDictionary *item = _dataSourceShow[i];
            if ([item[@"appointmentDate"] isEqualToString:date]) {
                [_dataSourceShow moveObjectFromIndex:i toIndex:0];
                [self.tempArray addObject:item[@"appointmentDate"]];
            }
        }
        
        if (self.tempArray.count == 0) {
            [MBProgressHUD showError:@"查询暂无数据"];
        }

    }else{
        for (NSInteger i = 0; _dataSourceShow.count > i; i++) {
            NSDictionary *item = _dataSourceShow[i];
            if (([item[@"name"] rangeOfString:key].location != NSNotFound) || ([item[@"phone"] rangeOfString:key].location != NSNotFound)) {
                [_dataSourceShow moveObjectFromIndex:i toIndex:0];
                [self.tempArray addObject:item[@"name"]];
            }
        }
        
        if (self.tempArray.count == 0) {
            [MBProgressHUD showError:@"查询暂无数据"];
        } 
    }
    
    [_tableView reloadData];
}

- (IBAction)dateAction:(id)sender {
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    YHGTLCalendar *controller = [board instantiateViewControllerWithIdentifier:@"YHGTLCalendar"];
    controller.isOnly = YES;
    [self.navigationController pushViewController:controller animated:YES];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)delAction:(UIButton*)button {
    
    NSDictionary *item = _dataSourceShow[button.tag];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确定删除？" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    __weak __typeof__(self) weakSelf = self;
    [alertView showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [MBProgressHUD showMessage:@"" toView:self.view];
            [[YHNetworkPHPManager sharedYHNetworkPHPManager]
             deleteWorkboard:[YHTools getAccessToken]
             id:item[@"id"]
             onComplete:^(NSDictionary *info) {
                 [MBProgressHUD hideHUDForView:self.view];
                 if (((NSNumber*)info[@"code"]).integerValue == 20000) {
                     [weakSelf reupdataDatasource];
                 }else {
                     if(![weakSelf networkServiceCenter:info[@"code"]]){
                         YHLog(@"");
                         if (((NSNumber*)info[@"code"]).integerValue == 20400) {
                             [weakSelf showErrorInfo:info];
                             weakSelf.dataSource = nil;
                             weakSelf.dataSourceShow = nil;
                         }
                     }
                 }
                 [weakSelf.tableView reloadData];
             } onError:^(NSError *error) {
                 [MBProgressHUD hideHUDForView:self.view];
             }];
            
        }
    }];
    
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [_tableView reloadData];
}

- (IBAction)searchAction:(id)sender {
    [[self view] endEditing:YES];
    if ([_searchKeyFT.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"输入客户名称或联系电话"];
        return;
    }
    [self sortListBy:nil orKey:_searchKeyFT.text];
}


- (void)reupdataDatasource{
    __weak __typeof__(self) weakSelf = self;
    [MBProgressHUD showMessage:@"" toView:self.view];
    [[YHNetworkPHPManager sharedYHNetworkPHPManager]getWorkboardList:[YHTools getAccessToken]
                                                          onComplete:^(NSDictionary *info)
    {
         NSLog(@"=======工作板：%@======%@=======",info,info[@"msg"]);
        
         [MBProgressHUD hideHUDForView:self.view];
         if (((NSNumber*)info[@"code"]).integerValue == 20000) {
             //weakSelf.dataSource = info[@"data"];
             weakSelf.dataSource = info[@"data"][@"list"];
             weakSelf.dataSourceShow = [weakSelf.dataSource mutableCopy];
         }else {
             if(![weakSelf networkServiceCenter:info[@"code"]]){
                 YHLog(@"");
                 if (((NSNumber*)info[@"code"]).integerValue == 20400) {
                     //[weakSelf showErrorInfo:info];
                     weakSelf.storeOrderButton.hidden = NO;
                     weakSelf.dataSource = nil;
                     weakSelf.dataSourceShow = nil;
                 }
             }
         }
         [weakSelf.tableView reloadData];
     } onError:^(NSError *error) {
         [MBProgressHUD hideHUDForView:self.view];
     }];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.isHaveStoreOrder == YES) {
        return 2;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (_dataSourceShow.count != 0) {
            return _dataSourceShow.count;
        } else {
            return 1;
        }
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (_dataSourceShow.count != 0) {
            YHWorkboardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            [cell loaddataSource:_dataSourceShow[indexPath.row] index:indexPath.row];
            return cell;
        } else {
            YHNoDataCell *NoDataCell = [self.tableView dequeueReusableCellWithIdentifier:@"YHNoDataCell"];
            NoDataCell.remindL.text = @"暂无工作板";
            return NoDataCell;
        }
    } else {
        WeakSelf;
        YHStroreOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YHStroreOrderCell" forIndexPath:indexPath];
        cell.btnClickBlock = ^(UIButton *button) {
            YHWebFuncViewController *controller = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
            controller.urlStr = [NSString stringWithFormat:@"%@%@/detection/index.html?token=%@&status=ios#/Custome",SERVER_PHP_URL_Statements_H5,SERVER_PHP_H5_Trunk, [YHTools getAccessToken]];
            controller.barHidden = YES;
            [weakSelf.navigationController pushViewController:controller animated:YES];
        };
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (_dataSourceShow.count != 0) {
            return 145;
        } else {
            if (self.isHaveStoreOrder == YES) {
                return (self.tableView.frame.size.height - 65);
            }else{
                return self.tableView.frame.size.height;
            }
        }
    } else {
        //如果所有cell行高 < 列表高度，第二段cell高度 = 列表高度 - 所有cell行高
        if (((_dataSourceShow.count * 145) > 0) && ((_dataSourceShow.count * 145) < self.tableView.frame.size.height)) {
            return (self.tableView.frame.size.height - (_dataSourceShow.count * 145));
        } else {
            return 65;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section > 0) {
        return;
    }
    
    UITableViewCell *sender = [tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *userInfo = [(AppDelegate*)[[UIApplication sharedApplication] delegate] loginInfo];
    NSDictionary *data = userInfo[@"data"];
    NSArray *menuList = data[@"menuList"];
    BOOL isNewOrder = NO;
    for (NSDictionary *menuItem in menuList) {
        if([menuItem[@"id"] isEqualToString:@"402881fb5acf7dc4015acfa8c04d0007"]){
            isNewOrder = YES;
            break;
        }
    }
    NSDictionary *item = _dataSourceShow[indexPath.row];
    if (![item[@"customerId"] isEqualToString:@"0"] && isNewOrder) {
        
//        self.sheet = [[UIActionSheet alloc] initWithTitle:nil
//                                                 delegate:self
//                                        cancelButtonTitle:@"取消"
//                                   destructiveButtonTitle:nil
//                                        otherButtonTitles:@"接车", @"详情", nil];
//        self.sheet.tag = indexPath.row;
//        // Show the sheet
//        [self.sheet showInView:self.view];
//
//        return;
        
        [UIAlertController showInViewController:self withTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"接车", @"详情"] popoverPresentationControllerBlock:^(UIPopoverPresentationController * _Nonnull popover) {
            popover.sourceView = sender;
            popover.sourceRect = sender.bounds;
        } tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            
            if(buttonIndex == controller.cancelButtonIndex || buttonIndex == controller.destructiveButtonIndex) return ;
            buttonIndex -= 2;
            
//            NSDictionary *userInfo = [(AppDelegate*)[[UIApplication sharedApplication] delegate] loginInfo];
//            NSDictionary *data = userInfo[@"data"];
//            NSArray *menuList = data[@"menuList"];
//            BOOL isNewOrder = NO;
//            for (NSDictionary *menuItem in menuList) {
//                if([menuItem[@"id"] isEqualToString:@"402881fb5acf7dc4015acfa8c04d0007"]){
//                    isNewOrder = YES;
//                    break;
//                }
//            }
            
            NSDictionary *item = _dataSourceShow[indexPath.row];
//            if (![item[@"customerId"] isEqualToString:@"0"] && isNewOrder) {//@"接车", @"详情"
                if (buttonIndex == 0) {
                    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
                    YHWebFuncViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
                    controller.title = @"接单";
                    controller.urlStr = [NSString stringWithFormat:@"%@%@/index.html?token=%@&status=ios&workBoardId=%@",SERVER_PHP_URL_H5,SERVER_PHP_H5_Trunk, [YHTools getAccessToken], item[@"id"]];
                    controller.barHidden = YES;
                    [self.navigationController pushViewController:controller animated:YES];
                }
                if (buttonIndex == 1) {
                    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    YHWorkboardDetailController *controller = [board instantiateViewControllerWithIdentifier:@"YHWorkboardDetailController"];
                    controller.wordbordInfo = item;
                    [self.navigationController pushViewController:controller animated:YES];
                }
//            }
        }];
        
    }else if(isNewOrder){
//        self.sheet = [[UIActionSheet alloc] initWithTitle:nil
//                                                 delegate:self
//                                        cancelButtonTitle:@"取消"
//                                   destructiveButtonTitle:nil
//                                        otherButtonTitles:@"接车", nil];
//        self.sheet.tag = indexPath.row;
//        // Show the sheet
//        [self.sheet showInView:self.view];
//
//        return;
        [UIAlertController showInViewController:self withTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"接车"] popoverPresentationControllerBlock:^(UIPopoverPresentationController * _Nonnull popover) {
            popover.sourceView = sender;
            popover.sourceRect = sender.bounds;
        } tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            
            if(buttonIndex == controller.cancelButtonIndex || buttonIndex == controller.destructiveButtonIndex) return ;
            buttonIndex -= 2;
            
//            NSDictionary *userInfo = [(AppDelegate*)[[UIApplication sharedApplication] delegate] loginInfo];
//            NSDictionary *data = userInfo[@"data"];
//            NSArray *menuList = data[@"menuList"];
//            BOOL isNewOrder = NO;
//            for (NSDictionary *menuItem in menuList) {
//                if([menuItem[@"id"] isEqualToString:@"402881fb5acf7dc4015acfa8c04d0007"]){
//                    isNewOrder = YES;
//                    break;
//                }
//            }
            
            NSDictionary *item = _dataSourceShow[indexPath.row];
            
//            if(isNewOrder){//@"接车",
                if (buttonIndex == 0) {
                    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
                    YHWebFuncViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
                    controller.title = @"接单";
                    controller.urlStr = [NSString stringWithFormat:@"%@%@/index.html?token=%@&status=ios&workBoardId=%@",SERVER_PHP_URL_H5 ,SERVER_PHP_H5_Trunk,[YHTools getAccessToken], item[@"id"]];
                    controller.barHidden = YES;
                    [self.navigationController pushViewController:controller animated:YES];
                }
//            }
        }];
    }else if(![item[@"customerId"] isEqualToString:@"0"] ){
//        self.sheet = [[UIActionSheet alloc] initWithTitle:nil
//                                                 delegate:self
//                                        cancelButtonTitle:@"取消"
//                                   destructiveButtonTitle:nil
//                                        otherButtonTitles:@"详情", nil];
//        self.sheet.tag = indexPath.row;
//        // Show the sheet
//        [self.sheet showInView:self.view];
        
//        return;
        [UIAlertController showInViewController:self withTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"详情"] popoverPresentationControllerBlock:^(UIPopoverPresentationController * _Nonnull popover) {
            popover.sourceView = sender;
            popover.sourceRect = sender.bounds;
        } tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            
            if(buttonIndex == controller.cancelButtonIndex || buttonIndex == controller.destructiveButtonIndex) return ;
            buttonIndex -= 2;
            
//            NSDictionary *userInfo = [(AppDelegate*)[[UIApplication sharedApplication] delegate] loginInfo];
//            NSDictionary *data = userInfo[@"data"];
//            NSArray *menuList = data[@"menuList"];
//            BOOL isNewOrder = NO;
//            for (NSDictionary *menuItem in menuList) {
//                if([menuItem[@"id"] isEqualToString:@"402881fb5acf7dc4015acfa8c04d0007"]){
//                    isNewOrder = YES;
//                    break;
//                }
//            }
//
            NSDictionary *item = _dataSourceShow[indexPath.row];
            
//            if(![item[@"customerId"] isEqualToString:@"0"] ){//@"详情"
                if (buttonIndex == 0) {
                    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    YHWorkboardDetailController *controller = [board instantiateViewControllerWithIdentifier:@"YHWorkboardDetailController"];
                    controller.wordbordInfo = item;
                    [self.navigationController pushViewController:controller animated:YES];
                }
//            }

        }];
    }
}

#pragma mark - 头像上传
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSDictionary *userInfo = [(AppDelegate*)[[UIApplication sharedApplication] delegate] loginInfo];
    NSDictionary *data = userInfo[@"data"];
    NSArray *menuList = data[@"menuList"];
    BOOL isNewOrder = NO;
    for (NSDictionary *menuItem in menuList) {
        if([menuItem[@"id"] isEqualToString:@"402881fb5acf7dc4015acfa8c04d0007"]){
            isNewOrder = YES;
            break;
        }
    }
    
    NSDictionary *item = _dataSourceShow[self.sheet.tag];
    if (![item[@"customerId"] isEqualToString:@"0"] && isNewOrder) {//@"接车", @"详情"
        if (buttonIndex == 0) {
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
            YHWebFuncViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
            controller.title = @"接单";
            controller.urlStr = [NSString stringWithFormat:@"%@%@/index.html?token=%@&status=ios&workBoardId=%@",SERVER_PHP_URL_H5,SERVER_PHP_H5_Trunk, [YHTools getAccessToken], item[@"id"]];
            controller.barHidden = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
        if (buttonIndex == 1) {
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            YHWorkboardDetailController *controller = [board instantiateViewControllerWithIdentifier:@"YHWorkboardDetailController"];
            controller.wordbordInfo = item;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }else if(isNewOrder){//@"接车",
        if (buttonIndex == 0) {
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
            YHWebFuncViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
            controller.title = @"接单";
            controller.urlStr = [NSString stringWithFormat:@"%@%@/index.html?token=%@&status=ios&workBoardId=%@",SERVER_PHP_URL_H5,SERVER_PHP_H5_Trunk, [YHTools getAccessToken], item[@"id"]];
            controller.barHidden = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }else  if(![item[@"customerId"] isEqualToString:@"0"] ){//@"详情"
        if (buttonIndex == 0) {
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            YHWorkboardDetailController *controller = [board instantiateViewControllerWithIdentifier:@"YHWorkboardDetailController"];
            controller.wordbordInfo = item;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
    
}

- (NSMutableArray *)tempArray
{
    if (!_tempArray) {
        _tempArray = [[NSMutableArray alloc]init];
    }
    return _tempArray;
}

@end
