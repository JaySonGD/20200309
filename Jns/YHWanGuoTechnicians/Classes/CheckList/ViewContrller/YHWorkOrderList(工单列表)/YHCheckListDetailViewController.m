//
//  YHCheckListDetailViewController.m
//  YHWanGuoTechnicians
//
//  Created by mwf on 2018/3/2.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHCheckListDetailViewController.h"
#import "YHTools.h"
#import "YHCommon.h"
#import <MJRefresh.h>
#import <MJExtension.h>

#import "YHNetworkPHPManager.h"
#import "YHNoDataCell.h"
#import "YHCheckListDetailCell0.h"
#import "YHCheckListDetailModel0.h"
#import "YHNewOrderController.h"
#import "YHDiagnosisProjectVC.h"
#import "SmartOCRCameraViewController.h"
#import "YHOrderDetailController.h"

#import "YHCarValuationViewController.h"
#import "YJProgressHUD.H"

#import "NewBillViewController.h"

@interface YHCheckListDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *emptyView;
@property (weak, nonatomic) IBOutlet UIView *searchView;
//@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelWidth;

@property (weak, nonatomic) IBOutlet UIButton *unFinishedBtn;     //未完成按钮
@property (weak, nonatomic) IBOutlet UIView *unFinishedView;      //未完成刻线
@property (weak, nonatomic) IBOutlet UIButton *finishedBtn;       //已完成按钮
@property (weak, nonatomic) IBOutlet UIView *finishedView;        //已完成刻线
@property (weak, nonatomic) IBOutlet UITableView *tableView;      //工单列表
@property (weak, nonatomic) IBOutlet UIButton *checkCarBtn;       //检车按钮

@property (nonatomic, strong) NSString *keyword;                  //搜索关键字

@property (nonatomic, assign) int tempPage;                       //临时页码
@property (nonatomic, assign) int page1;                          //左界面页码
@property (nonatomic, assign) int page2;                          //右界面页码
@property (nonatomic, assign) int searchPage1;                    //左界面搜索页码
@property (nonatomic, assign) int searchPage2;                    //右界面搜索页码
@property (nonatomic, assign) NSInteger tag;                      //页面标识tag
@property (nonatomic, assign) NSInteger didSelectedRow;           //选中行
@property (nonatomic, assign) NSInteger visibleRows;              //记录列表停留时可见行的起始行
@property (nonatomic, assign) BOOL isRequest;                     //设置未完成已完成数据源是否都为空

@property (nonatomic, strong) NSMutableArray *dataArray1;         //左界面数据源
@property (nonatomic, strong) NSMutableArray *dataArray2;         //右界面数据源
@property (nonatomic, strong) NSMutableArray *searchArray1;       //左界面搜索结果数据源
@property (nonatomic, strong) NSMutableArray *searchArray2;       //右界面搜索结果数据源

@property (nonatomic, assign) BOOL isClick;

@end

@implementation YHCheckListDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //初始化变量
    [self initVar];
    
    //初始化UI
    [self initUI];
    
    //初始化数据
    [self initData];
}

#pragma mark - --------------------------------------初始化变量------------------------------------------
- (void)initVar
{
    //设置页面标识tag初始值为1
    self.tag = 1;
    
    self.page1 = 1;
    
    self.page2 = 1;
    
    self.searchPage1 = 1;
    
    self.searchPage2 = 1;
    
    self.code = 0;
    
    //设置搜索初始状态为NO
    self.isSearch = NO;
    
    self.isRequest = NO;
    
    self.isClick = NO;
}

#pragma mark - --------------------------------------初始化UI------------------------------------------
- (void)initUI
{
    if (self.carDealerName.length > 10) {
        self.navigationItem.title = [NSString stringWithFormat:@"%@...",[self.carDealerName substringWithRange:NSMakeRange(0, 10)]];
    } else {
        self.navigationItem.title = self.carDealerName;
    }
    
    self.emptyView.hidden = YES;

    [self initSearchBar];
    
    [self initHeader];
    
    [self initCell];
}

#pragma mark - 1.initSearchBar
- (void)initSearchBar
{
    self.searchView.layer.cornerRadius = 5;
    self.searchView.layer.masksToBounds = YES;
    self.cancelWidth.constant = 0;
}

#pragma mark - 2.initHeader
- (void)initHeader
{
    [self.unFinishedBtn setTitleColor:YHNaviColor forState:UIControlStateNormal];
    [self.finishedBtn setTitleColor:YHBlackColor forState:UIControlStateNormal];
    self.unFinishedView.hidden = NO;
    self.finishedView.hidden = YES;
    self.checkCarBtn.layer.cornerRadius = 10;
    self.checkCarBtn.layer.masksToBounds = YES;
}

#pragma mark - 3.initCell
- (void)initCell
{
    [self.tableView registerNib:[UINib nibWithNibName:@"YHNoDataCell" bundle:nil] forCellReuseIdentifier:@"YHNoDataCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"YHCheckListDetailCell0" bundle:nil] forCellReuseIdentifier:@"YHCheckListDetailCell0"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    
//    [self.dataArray1 removeAllObjects];
//    [self.dataArray2 removeAllObjects];
//    [self.searchArray1 removeAllObjects];
//    [self.searchArray2 removeAllObjects];
//    [self loadNewData1];
}

- (IBAction)clickFinishedBtn:(UIButton *)sender
{
    self.tag = sender.tag;//页面标识tag = 页面tag
    switch (sender.tag) {
        case 1:
            [self.unFinishedBtn setTitleColor:YHNaviColor forState:UIControlStateNormal];
            [self.finishedBtn setTitleColor:YHBlackColor forState:UIControlStateNormal];
            self.unFinishedView.hidden = NO;
            self.finishedView.hidden = YES;
            break;
        case 2:
            [self.unFinishedBtn setTitleColor:YHBlackColor forState:UIControlStateNormal];
            [self.finishedBtn setTitleColor:YHNaviColor forState:UIControlStateNormal];
            self.unFinishedView.hidden = YES;
            self.finishedView.hidden = NO;
            break;
        default:
            break;
    }
    
    //搜索框未处于搜索状态
    if (self.isSearch == NO) {
        //未完成
        if (self.tag == 1) {
            if (self.code == 1) {
                self.code = 0;
                [self loadNewData1];
            } else {
                if (self.page1 == 1) {
                    [self loadNewData1];
                } else {
                    
                }
            }
        //已完成
        } else {
            if (self.code == 1) {
                self.code = 0;
                [self loadNewData2];
            } else {
                if (self.page2 == 1) {
                    [self loadNewData2];
                } else {
                    
                }
            }
        }
    //搜索框处于搜索状态
    } else {
        //未完成
        if (self.tag == 1) {
            if (self.code == 1) {
                self.code = 0;
                [self loadNewData3];
            } else {
                if (self.searchPage1 == 1) {
                    [self loadNewData3];
                } else {
                    
                }
            }
        //已完成
        } else {
            if (self.code == 1) {
                self.code = 0;
                [self loadNewData4];
            } else {
                if (self.searchPage2 == 1) {
                    [self loadNewData4];
                } else {
                    
                }
            }
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark - ------------------------------------初始化数据-----------------------------------------
- (void)initData
{
    WeakSelf;
    //下拉刷新MJRefreshNormalHeader
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //搜索框未处于搜索状态
        if (self.isSearch == NO) {
            //未完成
            if (self.tag == 1) {
                [self loadNewData1];
            //已完成
            } else {
                [self loadNewData2];
            }
        //搜索框处于搜索状态
        } else {
            //未完成
            if (self.tag == 1) {
                [self loadNewData3];
            //已完成
            } else {
                [self loadNewData4];
            }
        }
    }];
    
    //上拉加载更多MJRefreshAutoNormalFooter
    self.tableView.mj_footer =[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf queryData];
    }];
    
    if ((self.dataArray1.count == 0) || (self.dataArray2.count == 0)) {
        [self.tableView.mj_header beginRefreshing];
    }
}

#pragma mark - 返回刷新
- (void)backRefresh
{
    [self.dataArray1 removeObjectAtIndex:self.didSelectedRow];
    [self.tableView reloadData];
}

#pragma mark - 1.未完成未搜索
- (void)loadNewData1
{
    self.page1 = 1;
    [self queryData];
}

#pragma mark - 2.已完成未搜索
- (void)loadNewData2
{
    self.page2 = 1;
    [self queryData];
}

#pragma mark - 3.未完成已搜索
- (void)loadNewData3
{
    self.searchPage1 = 1;
    [self queryData];
}

#pragma mark - 4.已完成已搜索
- (void)loadNewData4
{
    self.searchPage2 = 1;
    [self queryData];
}

#pragma mark - 5.查询数据共用方法
- (void)queryData
{
    NSLog(@"-----------=====嘿嘿嘿tag:%ld=====------------",self.tag);

    //搜索框处于未搜索状态
    if (self.isSearch == NO) {
        if (self.tag == 1) {
            self.tempPage = self.page1;
        } else {
            self.tempPage = self.page2;
        }
        self.keyword = @"";
    //搜索框处于搜索状态
    } else {
        if (self.tag == 1) {
            self.tempPage = self.searchPage1;
        } else {
            self.tempPage = self.searchPage2;
        }
        self.keyword = self.searchTF.text;
    }
    
    NSLog(@"2-----------=====tag:%ld===page:%d====keyword:%@=====------------",self.tag,self.tempPage,self.keyword);
    
//    [MBProgressHUD showMessage:@"" toView:self.view];
    [YJProgressHUD showProgress:@"" inView:self.view];
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] queryWorkOrderListWithToken:[YHTools getAccessToken]
                                                                     WithKeyword:self.keyword
                                                                   WithPartnerId:self.partnerId
                                                                        WithPage:self.tempPage
                                                                    WithPageSize:10
                                                                         WithTag:self.tag
                                                                      onComplete:^(NSDictionary *info)
    {
        NSLog(@"\n工单列表:\n%@,%@,%@",info,info[@"msg"],info[@"code"]);
        [YJProgressHUD hide];
        if (([info[@"code"] longLongValue] == 20000) || ([info[@"code"] longLongValue] == 20400)) {
            //1.下拉刷新,清除所有数据源,避免重复添加
            if (self.isSearch == NO) {
                if (self.tag == 1) {
                    if (self.page1 == 1) {
                        [self.dataArray1 removeAllObjects];
                    }
                } else {
                    if (self.page2 == 1) {
                        [self.dataArray2 removeAllObjects];
                    }
                }
            } else {
                if (self.tag == 1) {
                    if (self.searchPage1 == 1) {
                        [self.searchArray1 removeAllObjects];
                    }
                } else {
                    if (self.searchPage2 == 1) {
                        [self.searchArray2 removeAllObjects];
                    }
                }
            }
            
            //2.解析数据并模型化
            for (NSDictionary *dict in info[@"data"][@"list"]) {
                YHCheckListDetailModel0 *model = [YHCheckListDetailModel0 mj_objectWithKeyValues:dict];
                if (self.isSearch == NO) {
                    if (self.tag == 1) {
                        [self.dataArray1 addObject:model];
                    } else {
                        [self.dataArray2 addObject:model];
                    }
                } else {
                    if (self.tag == 1) {
                        [self.searchArray1 addObject:model];
                    } else {
                        [self.searchArray2 addObject:model];
                    }
                }
            }
            
            //3.Page++
            if (self.isSearch == NO) {
                if (self.tag == 1) {
                    if (self.page1 < [info[@"total"] intValue]) {
                        self.page1 += 1;
                    }
                } else {
                    if (self.page2 < [info[@"total"] intValue]) {
                        self.page2 += 1;
                    }
                }
            } else {
                if (self.tag == 1) {
                    if (self.searchPage1 < [info[@"total"] intValue]) {
                        self.searchPage1 += 1;
                    }
                } else {
                    if (self.searchPage2 < [info[@"total"] intValue]) {
                        self.searchPage2 += 1;
                    }
                }
            }
            
            //7.未完成已完成都没有数据的时候
            if ([info[@"code"] longLongValue] == 20400) {
                if (self.isRequest == NO) {
                    self.isRequest = YES;
                    if (self.dataArray1.count == 0) {
                        [self queryFinishedData];
                        NSLog(@"1.未完成没有数据，需要请求已完成数据");
                    } else {
                        NSLog(@"2.未完成有数据，无需请求已完成数据");
                    }
                }
            } else {
                self.emptyView.hidden = YES;
            }
            
            //4.停止刷新
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];

            //5.刷新列表
            [self.tableView reloadData];
        } else {
            YHLogERROR(@"");
            [YJProgressHUD hide];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
    } onError:^(NSError *error) {
        [YJProgressHUD hide];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - 6.查询已完成数据
- (void)queryFinishedData
{
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] queryWorkOrderListWithToken:[YHTools getAccessToken]
                                                                     WithKeyword:@""
                                                                   WithPartnerId:self.partnerId
                                                                        WithPage:1
                                                                    WithPageSize:10
                                                                         WithTag:2
                                                                      onComplete:^(NSDictionary *info) {
        NSLog(@"\n工单已完成列表:\n%@,%@,%@",info,info[@"msg"],info[@"code"]);
        if ([info[@"code"] longLongValue] == 20400) {
            self.emptyView.hidden = NO;
        } else {
            self.emptyView.hidden = YES;
        }
    } onError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - ----------------------------------UITextField代理方法----------------------------------------
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.cancelWidth.constant = 40;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.isSearch == NO) {
        NSArray *indexPathArray = self.tableView.indexPathsForVisibleRows;
        NSIndexPath *indexPath = indexPathArray[0];
        self.visibleRows = indexPath.row;
        NSLog(@"----记录可见行起始行：%ld----",self.visibleRows);
    } else {
        NSLog(@"不是第一次由普通状态转为搜索状态");
    }

    //1.发起搜索
    if (!IsEmptyStr(self.searchTF.text)) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        
        //设置为搜索状态
        self.isSearch = YES;
        
        //发起搜索
        if (self.tag == 1) {
            [self loadNewData3];
        } else {
            [self loadNewData4];
        }
    } else {
        [MBProgressHUD showError:@"请输入搜索内容"];
    }
    
    //2.键盘收起
    return [textField resignFirstResponder];
}

- (IBAction)cancel:(UIButton *)sender
{
    //1.设置为未搜索状态
    self.isSearch = NO;
    
    //2.清空输入框内容
    self.searchTF.text = @"";
    
    //3.“取消按钮”隐藏
    self.cancelWidth.constant = 0;

    //4.键盘收起
    [self.searchTF resignFirstResponder];

    //5.刷新列表
    [self.tableView reloadData];
    
    //6.回到搜索前的位置
    if (self.tag == 1) {
        if (self.dataArray1.count == 0) {
            [self loadNewData1];
        } else {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.visibleRows inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
    } else {
        if (self.dataArray2.count == 0) {
            [self loadNewData2];
        } else {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.visibleRows inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
    }
}

#pragma mark - ----------------------------------tableView代理方法----------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //搜索框未处于搜索状态
    if (self.isSearch == NO) {
        if (self.tag == 1) {
            if (self.dataArray1.count != 0) {
                return self.dataArray1.count;
            } else {
                return 1;
            }
        } else {
            if (self.dataArray2.count != 0) {
                return self.dataArray2.count;
            } else {
                return 1;
            }
        }
    //搜索框处于搜索状态
    } else {
        if (self.tag == 1) {
            if (self.searchArray1.count != 0) {
                return self.searchArray1.count;
            } else {
                return 1;
            }
        } else {
            if (self.searchArray2.count != 0) {
                return self.searchArray2.count;
            } else {
                return 1;
            }
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //搜索框处于未搜索状态
    if (self.isSearch == NO) {
        if (self.tag == 1) {
            if (self.dataArray1.count != 0) {
                YHCheckListDetailCell0 *cell0 = [self.tableView dequeueReusableCellWithIdentifier:@"YHCheckListDetailCell0"];
                [cell0 refreshUIWithModel:self.dataArray1[indexPath.row] WithTag:self.tag WithType:self.type];
                return cell0;
            } else {
                YHNoDataCell *NoDataCell = [self.tableView dequeueReusableCellWithIdentifier:@"YHNoDataCell"];
                return NoDataCell;
            }
        } else {
            if (self.dataArray2.count != 0) {
                YHCheckListDetailCell0 *cell0 = [self.tableView dequeueReusableCellWithIdentifier:@"YHCheckListDetailCell0"];
                [cell0 refreshUIWithModel:self.dataArray2[indexPath.row] WithTag:self.tag WithType:self.type];
                return cell0;
            } else {
                YHNoDataCell *NoDataCell = [self.tableView dequeueReusableCellWithIdentifier:@"YHNoDataCell"];
                return NoDataCell;
            }
        }
    //搜索框处于搜索状态
    } else {
        if (self.tag == 1) {
            if (self.searchArray1.count != 0) {
                YHCheckListDetailCell0 *cell0 = [self.tableView dequeueReusableCellWithIdentifier:@"YHCheckListDetailCell0"];
                [cell0 refreshUIWithModel:self.searchArray1[indexPath.row] WithTag:self.tag WithType:self.type];
                return cell0;
            } else {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                YHNoDataCell *NoDataCell = [self.tableView dequeueReusableCellWithIdentifier:@"YHNoDataCell"];
                NoDataCell.remindL.text = @"没有搜索到相应工单";
                return NoDataCell;
            }
        } else {
            if (self.searchArray2.count != 0) {
                YHCheckListDetailCell0 *cell0 = [self.tableView dequeueReusableCellWithIdentifier:@"YHCheckListDetailCell0"];
                [cell0 refreshUIWithModel:self.searchArray2[indexPath.row] WithTag:self.tag WithType:self.type];
                return cell0;
            } else {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                YHNoDataCell *NoDataCell = [self.tableView dequeueReusableCellWithIdentifier:@"YHNoDataCell"];
                NoDataCell.remindL.text = @"没有搜索到相应工单";
                return NoDataCell;
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //搜索框未处于搜索状态
    if (self.isSearch == NO) {
        if (self.tag == 1) {
            if (self.dataArray1.count != 0) {
                return 156;
            } else {
                return self.tableView.frame.size.height;
            }
        } else {
            if (self.dataArray2.count != 0) {
                return 156;
            } else {
                return self.tableView.frame.size.height;
            }
        }
    //搜索框处于搜索状态
    } else {
        if (self.tag == 1) {
            if (self.searchArray1.count != 0) {
                return 156;
            } else {
                return self.tableView.frame.size.height;
            }
        } else {
            if (self.searchArray2.count != 0) {
                return 156;
            } else {
                return self.tableView.frame.size.height;
            }
        }
    }
}

- (void)jumpRepairpatternView:(NSString *)billId{
    
    YHWebFuncViewController *controller = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
    controller.urlStr = [NSString stringWithFormat:@"%@%@/maintenance_report.html?token=%@&&status=ios&billId=%@&type=1",SERVER_PHP_URL_Statements_H5 ,SERVER_PHP_H5_Trunk,[YHTools getAccessToken],billId];
    controller.barHidden = YES;
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tag == 1) {
        
        self.didSelectedRow = indexPath.row;
        YHCheckListDetailModel0 *model;
        if (self.isSearch == NO) {
            model = self.dataArray1[indexPath.row];
        } else {
            model = self.searchArray1[indexPath.row];
        }
        
        if ([model.nextStatusCode isEqualToString:@"storeUsedCarCheckReportQuote"]) {
            // 维修方案页
            [self jumpRepairpatternView:[NSString stringWithFormat:@"%d",model.ID]];
            
        }else{
            
            YHDiagnosisProjectVC *VC = [[YHDiagnosisProjectVC alloc] init];
            YHBillStatusModel *billModel = [[YHBillStatusModel alloc] init];
            billModel.billId = [NSString stringWithFormat:@"%d",model.ID];
            VC.billModel = billModel;
            [self.navigationController pushViewController:VC animated:YES];
        }
       
    } else {
        
        YHCheckListDetailModel0 *model;
        if (self.isSearch == NO) {
            model = self.dataArray2[indexPath.row];
        } else {
            model = self.searchArray2[indexPath.row];
        }
        
        [[YHNetworkPHPManager sharedYHNetworkPHPManager] getBillDetail:[YHTools getAccessToken] billId:[NSString stringWithFormat:@"%d",model.ID] isHistory:NO onComplete:^(NSDictionary *info) {
            
            NSString *codeStr = [NSString stringWithFormat:@"%@",info[@"code"]];
            if ([codeStr isEqualToString:@"20000"]) {
                NSDictionary *data = info[@"data"];
                NSDictionary *reportData = data[@"reportData"];
                
                if (!reportData || [reportData isKindOfClass:[NSNull class]] || reportData.count == 0) {
                    YHCarValuationViewController *VC = [[UIStoryboard storyboardWithName:@"YHCarValuation" bundle:nil] instantiateViewControllerWithIdentifier:@"YHCarValuationViewController"];
                    VC.billId = [NSString stringWithFormat:@"%d",model.ID];
                    [self.navigationController pushViewController:VC animated:YES];
                    return;
                }
                // 维修方案页
                [self jumpRepairpatternView:[NSString stringWithFormat:@"%d",model.ID]];
                
            }else{
                
                [MBProgressHUD showError:info[@"msg"]];
            }
            
        } onError:^(NSError *error) {
            if (error) {
                NSLog(@"%@",error);
            }
        }];
    }
}

#pragma mark - 车辆估值接口
- (void)test{

}


#pragma mark - 检车
- (IBAction)checkCar:(UIButton *)sender
{
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Register" bundle:nil];
    NewBillViewController *controller = [board instantiateViewControllerWithIdentifier:@"NewBillViewController"];
    controller.type = YYNewBillStyleUsedSale;
    controller.billId = [NSString stringWithFormat:@"%d",self.partnerId];

//    NSString *reportType = nil;
//    if(arrFucnameAndParameter.count>2){
//        reportType = [arrFucnameAndParameter objectAtIndex:2];
//    }
//
//    if(arrFucnameAndParameter.count>3){
//        NSString *orderType = [arrFucnameAndParameter objectAtIndex:3];
//        controller.isShowImageBtn = [orderType isEqualToString:@"J003"];
//    }
//    controller.reportType = reportType;
    [self.navigationController pushViewController:controller animated:YES];




    return;
    
    YHNewOrderController *VC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"YHNewOrderController"];
    VC.bucheBookingId = self.partnerId;
    VC.isPushByOrderList = YES;
    [self.navigationController pushViewController:VC animated:NO];
}

#pragma mark - 懒加载
- (NSMutableArray *)dataArray1
{
    if (!_dataArray1) {
        _dataArray1 = [[NSMutableArray alloc]init];
    }
    return _dataArray1;
}

- (NSMutableArray *)dataArray2
{
    if (!_dataArray2) {
        _dataArray2 = [[NSMutableArray alloc]init];
    }
    return _dataArray2;
}

- (NSMutableArray *)searchArray1
{
    if (!_searchArray1) {
        _searchArray1 = [[NSMutableArray alloc]init];
    }
    return _searchArray1;
}

- (NSMutableArray *)searchArray2
{
    if (!_searchArray2) {
        _searchArray2 = [[NSMutableArray alloc]init];
    }
    return _searchArray2;
}

@end
