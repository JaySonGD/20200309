//
//  ViewController.m
//  tableView之cell缩放
//
//  Created by imac on 16/9/1.
//  Copyright © 2016年 imac. All rights reserved.
//

#import "YHOrderDetailViewNewCell.h"
#import "YHOrderDetailViewSupCell.h"
#import "YHOrderDetailViewSubCell.h"

#define Screenwidth [UIScreen mainScreen].bounds.size.width

@interface YHOrderDetailViewNewCell ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *WBTableView;

@end

@implementation YHOrderDetailViewNewCell

- (instancetype)init
{
    self = [super init];
    if (self) {
              //创建
              _WBTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
              _WBTableView.dataSource = self;
              _WBTableView.delegate = self;
              _WBTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
              _WBTableView.estimatedRowHeight = 29.5;
              [self.contentView addSubview:self.WBTableView];
        
    }
    return self;
}


//数据源方法的实现
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    TTZSYSModel *model = self.dataArr[section];
    
    if ([model.close  isEqual: @0] || !model.close) {
        return 0;
    }
    
    
    return model.Sublist.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     
    YHOrderDetailViewSubCell *cell = [[YHOrderDetailViewSubCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    TTZSYSModel *model = self.dataArr[indexPath.section];
    TTZSYSNewSubModel *Mod = model.Sublist[indexPath.row];
    ////问题严重程度：e-未检测 1-正常 0-轻微 2-中等  3-严重",//当为1时 ，显示 检测结果+换行+工程师评估+空格+用车建议;当不为1时，显示detectionResult
    cell.status = Mod.level;
    cell.resultStr =  Mod.detectionResult;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
       
//      TTZSYSModel *model = self.dataArr[indexPath.section];
//       TTZSYSNewSubModel *Mod = model.Sublist[indexPath.row];
//       ////问题严重程度：e-未检测 1-正常 0-轻微 2-中等  3-严重",//当为1时 ，显示 检测结果+换行+工程师评估+空格+用车建议;当不为1时，显示detectionResult
//       NSString *resultStr = Mod.detectionResult;
    
    return UITableViewAutomaticDimension;
}

//组头的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

//创建组头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    YHOrderDetailViewSupCell *orderDetailCell = [[YHOrderDetailViewSupCell alloc]initWithFrame:CGRectMake(0, 0, Screenwidth, 44)];
    orderDetailCell.tag = 1000 + section;
   orderDetailCell.cellModel = self.dataArr[section];
//   [view addSubview:orderDetailCell];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sectionClick:)];
    [orderDetailCell addGestureRecognizer:tap];
    
    return orderDetailCell;
    
}

/**
 *  cell收缩/展开 刷新
 *
 */
-(void)sectionClick:(UITapGestureRecognizer *)tap{
    
    //获取点击的组
    NSInteger i = tap.view.tag - 1000;
    //取反
    TTZSYSModel *model = self.dataArr[i];
    model.close = [model.close isEqual:@1] ? @0 : @1;
     
    //刷新列表
    NSIndexSet * index = [NSIndexSet indexSetWithIndex:i];
    [UIView performWithoutAnimation:^{
        [_WBTableView reloadSections:index withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    [_WBTableView layoutIfNeeded];
    
//    CGRect rect = [_WBTableView rectForSection:self.dataArr.count - 1];
    
    self.frame =  CGRectMake(0, self.frame.origin.y, screenWidth, _WBTableView.contentSize.height);
    self.click(self.frame.size.height);
   
}

- (void)setFrame:(CGRect)frame{
    
    frame.origin.x += 8;
    frame.size.width -= 16;
    [super setFrame:frame];
    
    _WBTableView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}


////区头部悬停
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
// 
//    CGFloat sectionHeaderHeight = 44;
//    CGFloat sectionFooterHeight = 0;
//    CGFloat offsetY = scrollView.contentOffset.y;
//    if (offsetY >= 0 && offsetY <= sectionHeaderHeight)
//    {
//        scrollView.contentInset = UIEdgeInsetsMake(-offsetY, 0, -sectionFooterHeight, 0);
//    }else if (offsetY >= sectionHeaderHeight && offsetY <= scrollView.contentSize.height - scrollView.frame.size.height - sectionFooterHeight)
//    {
//        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, -sectionFooterHeight, 0);
//    }else if (offsetY >= scrollView.contentSize.height - scrollView.frame.size.height - sectionFooterHeight && offsetY <= scrollView.contentSize.height - scrollView.frame.size.height)
//    {
//        scrollView.contentInset = UIEdgeInsetsMake(-offsetY, 0, -(scrollView.contentSize.height - scrollView.frame.size.height - sectionFooterHeight), 0);
//    }
//}

@end
