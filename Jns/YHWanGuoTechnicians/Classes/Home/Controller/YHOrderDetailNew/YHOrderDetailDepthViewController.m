//
//  YHOrderDetailDepthViewController.m
//  YHWanGuoTechnicians
//

//  Created by Liangtao Yu on 2019/10/16.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import "YHOrderDetailDepthViewController.h"
#import "YHDetailDepthCell.h"

@interface YHOrderDetailDepthViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *WBTableView;

@property (nonatomic,strong)NSArray *dataArr;

@end

@implementation YHOrderDetailDepthViewController

-(void)loadView{
    
    self.view = [[UIScrollView alloc]init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:242/255.0 alpha:1];
          _WBTableView = [[UITableView alloc] initWithFrame:CGRectMake(12, 15, [UIScreen mainScreen].bounds.size.width  - 24, 0) style:UITableViewStylePlain];
          _WBTableView.dataSource = self;
          _WBTableView.delegate = self;
          _WBTableView.scrollEnabled = NO;
          _WBTableView.backgroundColor = [UIColor whiteColor];
          _WBTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
          _WBTableView.estimatedRowHeight = 44;
          [_WBTableView registerNib:[UINib nibWithNibName:@"YHDetailDepthCell" bundle:nil] forCellReuseIdentifier:@"YHDetailDepthCell"];
          _WBTableView.contentInset = UIEdgeInsetsMake(0, 0, 24, 0);
         _WBTableView.layer.cornerRadius = 10;
         _WBTableView.layer.masksToBounds = YES;
          [self.view addSubview:self.WBTableView];
    
        [_WBTableView addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];  [self.WBTableView   addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
            
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
        CGRect frame = _WBTableView.frame;
        frame.size = _WBTableView.contentSize;
        _WBTableView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height + 18);
        UIScrollView *scl = (UIScrollView *)self.view;
        scl.contentSize = CGSizeMake(frame.size.width, frame.size.height + 24);
}

-(void)setDiagnoseModel:(YHSchemeModel *)diagnoseModel{
    
    _diagnoseModel = diagnoseModel;
    
    NSMutableArray *arr1 = [NSMutableArray arrayWithCapacity:100];
    [arr1 addObjectsFromArray:diagnoseModel.parts];
    for (YHConsumableModel *model in diagnoseModel.consumable) {
        YHPartsModel *partsModel = [[YHPartsModel alloc]init];
        partsModel.part_name = model.consumable_name;
        partsModel.part_price = model.consumable_price;
        [arr1 addObject:partsModel];
        
    }
    
     NSMutableArray *arr2 = [NSMutableArray arrayWithCapacity:10];
     [arr2 addObjectsFromArray:diagnoseModel.labor];
    
     self.dataArr = @[arr1,arr2,@[]];
    
}


//数据源方法的实现
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArr[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YHDetailDepthCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YHDetailDepthCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(indexPath.section == 0){
        YHPartsModel *model = self.dataArr[indexPath.section][indexPath.row];
        cell.nameStr = model.part_name;
        cell.subNameStr = model.part_price;
        cell.isLast = indexPath.row == [self.dataArr[indexPath.section] count] -1;
    }
    
    if(indexPath.section == 1){
        YHLaborModel *model = self.dataArr[indexPath.section][indexPath.row];
        cell.nameStr = model.labor_name;
        cell.subNameStr = model.labor_price;
        cell.isLast = indexPath.row == [self.dataArr[indexPath.section] count] -1;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

//组头的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

//创建组头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

   UIView *bgView = [[UIView alloc] init];
    
   UILabel *titleLB = [[UILabel alloc] init];
   titleLB.font = [UIFont systemFontOfSize:18];
   titleLB.textColor = [UIColor colorWithHexString:@"0x363636"];
   titleLB.text = !section ? @"配件耗材" : section == 1 ? @"维修项目" : @"费用总计";
   [bgView addSubview:titleLB];
    [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.top.equalTo(@20);
    }];
    
    UILabel *titleLS = [[UILabel alloc] init];
    titleLS.font = section == 2 ? [UIFont systemFontOfSize:19] : [UIFont systemFontOfSize:16];
    titleLS.textColor = section == 2 ? [UIColor colorWithHexString:@"0x363636"] : [UIColor colorWithHexString:@"0x727272"];
   [bgView addSubview:titleLS];
    titleLS.text = !section ? @"价格(元)" : section == 1 ? @"工时费" : [NSString stringWithFormat:@"%@元",IsEmptyStr(self.diagnoseModel.total_price) ? @"0" : self.diagnoseModel.total_price];
    [titleLS mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-12);
        make.centerY.equalTo(titleLB);
    }];
   
    
    
    return bgView;
}

@end
