//
//  YHCheckDetailViewController.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/6/26.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHCheckDetailViewController.h"
#import "YHCheckCarDetailCell.h"
#import "YHCheckCarDetailHeaderView.h"
#import "TTZSurveyModel.h"
#import "NSObject+MJKeyValue.h"

@interface YHCheckDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *checkTableview;
/** 异常的数据源数据 */
@property (nonatomic, strong) NSMutableArray *checkDataArr;
/** 数据源数据 */
@property (nonatomic, strong) NSMutableArray *allSourceData;
/** 最初的异常的数据源数据 */
@property (nonatomic, strong) NSMutableArray *originCheckDataArr;

@end

@implementation YHCheckDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initCheckDetailBase];
    
    [self initCheckDetailUI];
    
    [self initCheckDetailData];
    
}
- (void)initCheckDetailData{
    
    [MBProgressHUD showMessage:@"" toView:self.view];
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] getBillDetail:[YHTools getAccessToken] billId:self.orderDetailInfo[@"id"] isHistory:NO onComplete:^(NSDictionary *info) {
        
        [MBProgressHUD hideHUDForView:self.view];
        
        NSLog(@"%@",info);
        NSString *msg = info[@"msg"];
        int code = [info[@"code"] intValue];
        if (code == 20000) {
        
        NSDictionary *data = info[@"data"];
        NSArray *initialSurveyItemVal = [self.orderDetailInfo[@"billType"] isEqualToString:@"J007"] ? data[@"m_item_val"] : data[@"initialSurveyItemVal"];
        initialSurveyItemVal = initialSurveyItemVal.count ? initialSurveyItemVal : data[@"recheck_item"];
        NSMutableArray *resultArr = [NSMutableArray array];
        NSMutableArray *problemResultArr = [NSMutableArray array];
//        NSMutableArray <TTZSYSModel *>*models = [TTZSYSModel mj_objectArrayWithKeyValuesArray:initialSurveyItemVal];
            
            if ([self.orderDetailInfo[@"billType"] isEqualToString:@"J003"]) {
                
                
                for (int j = 0; j<initialSurveyItemVal.count; j++) {
                    
                    NSDictionary *childDict = initialSurveyItemVal[j];
                    NSArray *inListArr = childDict[@"list"];
                    if (inListArr.count == 0) {
                        continue;
                    }
                    NSString *classTitle = childDict[@"name"];
                    NSMutableDictionary *newSecDict = [NSMutableDictionary dictionary];
                    NSMutableArray *childArr = [NSMutableArray array];
                    NSMutableArray *problemChildArr = [NSMutableArray array];
                    [newSecDict setValue:classTitle forKey:@"className"];
                    [newSecDict setValue:@"NO" forKey:@"isOpen"];
                    
                    
                    for (NSDictionary *item in inListArr) {
                        
                        NSString *projectName = item[@"projectName"];
                        NSString *projectVal = [NSString stringWithFormat:@"%@",item[@"projectVal"]];
                        if (projectVal.length > 0) {
                            projectVal = [NSString stringWithFormat:@"%@ %@",projectVal,item[@"unit"]];
                        }
                        NSMutableDictionary *newChildDict = [NSMutableDictionary dictionary];
                        [newChildDict setValue:[NSString stringWithFormat:@"%@",projectName] forKey:@"projectName"];
                        [newChildDict setValue:projectVal forKey:@"projectVal"];
                        [newChildDict setValue:item[@"projectRelativeImgList"] forKey:@"imgList"];
                        [newChildDict setValue:[NSString stringWithFormat:@"%@",item[@"errorLevel"]] forKey:@"errorLevel"];
                        // 问题级别：1-正常，0-不正常
                        if ([[NSString stringWithFormat:@"%@",item[@"errorLevel"]] isEqualToString:@"0"]) {
                            [problemChildArr addObject:newChildDict];
                        }
                        [childArr addObject:newChildDict];
                        
                    }
                    
                    [newSecDict setValue:childArr forKey:@"list"];
                    if (childArr.count) {
                        [resultArr addObject:newSecDict];
                    }
                    
                    NSMutableDictionary *problemNewSecDict = [newSecDict mutableCopy];
                    [problemNewSecDict setValue:problemChildArr forKey:@"list"];
                    [problemResultArr addObject:problemNewSecDict];
                }
            }else{
                // 非J003
                for (int i = 0; i<initialSurveyItemVal.count; i++) {
                    
                    NSDictionary *secDict = initialSurveyItemVal[i];
                    NSMutableDictionary *newSecDict = [NSMutableDictionary dictionary];
                    [newSecDict setValue:secDict[@"name"] forKey:@"className"];
                    [newSecDict setValue:@"NO" forKey:@"isOpen"];
                   
                    NSMutableArray *childArr = [NSMutableArray array];
                    NSMutableArray *problemChildArr = [NSMutableArray array];
                    
                    NSArray *childList = secDict[@"list"];
                    for (int j = 0; j<childList.count; j++) {
                        
                        NSDictionary *childDict = childList[j];
                        NSString *classTitle = childDict[@"projectName"];
                        NSArray *inListArr = childDict[@"list"];
                        
                        for (NSDictionary *item in inListArr) {
                            NSString *projectName = item[@"projectName"];
                            NSString *projectVal = [NSString stringWithFormat:@"%@",item[@"projectVal"]];
                            if (projectVal.length > 0) {
                                projectVal = [NSString stringWithFormat:@"%@ %@",projectVal,item[@"unit"]];
                            }
                            NSMutableDictionary *newChildDict = [NSMutableDictionary dictionary];
                            [newChildDict setValue:[NSString stringWithFormat:@"%@-%@",classTitle,projectName] forKey:@"projectName"];
                            [newChildDict setValue:projectVal forKey:@"projectVal"];
                            [newChildDict setValue:item[@"projectRelativeImgList"] forKey:@"imgList"];
                            [newChildDict setValue:[NSString stringWithFormat:@"%@",item[@"errorLevel"]] forKey:@"errorLevel"];
                            // 问题级别：1-正常，0-不正常
                            if ([[NSString stringWithFormat:@"%@",item[@"errorLevel"]] isEqualToString:@"0"]) {
                                [problemChildArr addObject:newChildDict];
                            }
                            [childArr addObject:newChildDict];
                            
                        }
                        
                        if([childDict isEqual:childList.lastObject]){
                            NSArray *arr = childDict[@"list"];
                            [newSecDict setValue:arr.lastObject[@"projectVal"] forKey:@"projectVal"];
                            //                            TTZSYSModel *model = [
                        }
                    }
                    [newSecDict setValue:childArr forKey:@"list"];
                    if (childArr.count) {
                        [resultArr addObject:newSecDict];
                    }
                    NSMutableDictionary *problemNewSecDict = [newSecDict mutableCopy];
                    [problemNewSecDict setValue:problemChildArr forKey:@"list"];
                    [problemResultArr addObject:problemNewSecDict];
                }
            }
            
        self.allSourceData = resultArr;
        self.checkDataArr = problemResultArr;
        self.originCheckDataArr = [problemResultArr mutableCopy];
        
        [self.checkTableview reloadData];
            
        }else{
            [MBProgressHUD showError:msg toView:self.view];
        }
        
    } onError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        if (error) {
            NSLog(@"%@",error);
        }
    }];
    
}

- (void)initCheckDetailBase{
    
    self.title = @"检测明细";
    self.view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)initCheckDetailUI{
    
     CGFloat topMargin = iPhoneX ? 88 : 64;
    CGFloat bottomMargin = iPhoneX ? 34 : 0;
    
    UITableView *checkTableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    checkTableview.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    checkTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.checkTableview = checkTableview;
    checkTableview.delegate = self;
    checkTableview.dataSource = self;
    checkTableview.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:checkTableview];
    
    [checkTableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(topMargin + 10));
        make.left.equalTo(@0);
        make.width.equalTo(checkTableview.superview);
        make.bottom.equalTo(checkTableview.superview).offset(-bottomMargin);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.checkDataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSDictionary *sectionDict = self.checkDataArr[section];
    NSArray *seclistArr = sectionDict[@"list"];
    
    return seclistArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"checkCarCell";
    YHCheckCarDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[YHCheckCarDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *sectionDict = self.checkDataArr[indexPath.section];
    NSArray *seclistArr = sectionDict[@"list"];
    cell.info = seclistArr[indexPath.row];
    
    cell.maxRows = seclistArr.count;
    cell.indexPath = indexPath;
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    YHCheckCarDetailHeaderView *sectionHeaderView = [[YHCheckCarDetailHeaderView alloc] init];
    sectionHeaderView.billType = self.orderDetailInfo[@"billType"];
    [sectionHeaderView initCheckCarDetailHeaderViewUI];
    
    NSDictionary *sectionDict = nil;
    if (self.checkDataArr.count > 0) {
        sectionDict = self.checkDataArr[section];
        [sectionHeaderView setHeaderTitle:sectionDict[@"className"]];
        [sectionHeaderView setHeaderResultTitle:sectionDict[@"projectVal"]];
        sectionHeaderView.sectionIndex = section;
    }
 
    if (self.originCheckDataArr.count > 0) {
        NSDictionary *originSectionDict = self.originCheckDataArr[section];
        NSArray *seclistArr = originSectionDict[@"list"];
        sectionHeaderView.problemCount = seclistArr.count;
    }

    if (self.allSourceData.count > 0 && section < self.allSourceData.count) {
        NSDictionary *allSourceSectionDict = self.allSourceData[section];
        NSArray *allSourceArr = allSourceSectionDict[@"list"];
        sectionHeaderView.sectionCount = allSourceArr.count;
    }
    
    [sectionHeaderView isNeedOpen:[sectionDict[@"isOpen"] boolValue]];
    __weak typeof(self)weakSelf = self;
    sectionHeaderView.rigitBtnClickedEvent = ^(BOOL isOpen, NSInteger sectionIndex) {
        
         NSString *value = isOpen ? @"YES": @"NO";
        if (isOpen) {
            // 将要展开
            NSMutableDictionary *sectionDict = [self.allSourceData[sectionIndex] mutableCopy];
            [sectionDict setValue:[NSString stringWithFormat:@"%@",value] forKey:@"isOpen"];
            [self.checkDataArr replaceObjectAtIndex:sectionIndex withObject:sectionDict];
            
        }else{
            // 将要关闭
            NSMutableDictionary *sectionDict = [self.originCheckDataArr[sectionIndex] mutableCopy];
            [sectionDict setValue:[NSString stringWithFormat:@"%@",value] forKey:@"isOpen"];
            [self.checkDataArr replaceObjectAtIndex:sectionIndex withObject:sectionDict];
           
        }
        [weakSelf.checkTableview reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationNone];
    };
    return sectionHeaderView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    return [[UIView alloc] init];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    NSDictionary *sectionDict = self.checkDataArr[indexPath.section];
    NSArray *seclistArr = sectionDict[@"list"];
    NSDictionary *item = seclistArr[indexPath.row];
    NSArray *imgList = item[@"imgList"];
    if (imgList.count) {
        return 45 + 94;
    }else{
        return 45.0;
    }
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [self.orderDetailInfo[@"billType"] isEqualToString:@"J007"] ? 66.0 : 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.0;
}

@end
