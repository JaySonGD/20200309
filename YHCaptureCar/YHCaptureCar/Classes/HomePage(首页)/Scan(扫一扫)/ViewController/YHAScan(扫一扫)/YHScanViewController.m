//
//  YHScanViewController.m
//  YHCaptureCar
//
//  Created by mwf on 2018/9/12.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHScanViewController.h"
#import "YHScanCell.h"
#import "YHReportListViewController.h"
#import "SmartOCRCameraViewController.h"

@interface YHScanViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *showView;
@property (weak, nonatomic) IBOutlet UITextField *vinTF;
@property (weak, nonatomic) IBOutlet UIButton *scanVinBtn;
@property (weak, nonatomic) IBOutlet UILabel *scanRecordLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *tempArrayA;
@property (nonatomic, strong) NSMutableArray *tempArrayB;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *vin;

@end

@implementation YHScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化变量
    [self initVar];
    
    //初始化UI
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    //初始化数据
    [self initData];
}

#pragma mark - ------------------------------------初始化变量----------------------------------------
- (void)initVar {
    [self.tableView registerNib:[UINib nibWithNibName:@"YHScanCell" bundle:nil] forCellReuseIdentifier:@"YHScanCell"];
}

#pragma mark - -------------------------------------初始化UI------------------------------------------
- (void)initUI {
    self.showView.image = self.image;
    self.vinTF.text = self.vin;
    self.vinTF.delegate = self;
}

#pragma mark - ------------------------------------初始化数据------------------------------------------
- (void)initData {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.dataArray = [defaults objectForKey:@"vinCode"];
    if (self.dataArray.count != 0) {
        self.tableView.hidden = NO;
        [self.tableView reloadData];
    } else {
        self.tableView.hidden = YES;
    }
}

- (void)loaddata:(NSString*)vin image:(UIImage*)image{
    self.vin = vin;
    self.image = image;
    self.showView.image = self.image;
    self.vinTF.text = self.vin;
    self.tableView.hidden = NO;
}

- (void)reloadTableView{
    //1.获取最初数据源
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.tempArrayA = [defaults objectForKey:@"vinCode"];
    NSLog (@"%@",self.tempArrayA);
    
    //2.拷贝初始数据源
    self.tempArrayB = [self.tempArrayA mutableCopy];
    
    //3.把最新提交的插入到第0位
    [self.tempArrayB insertObject:self.vinTF.text atIndex:0];
    
    //4.大于5条时，删除多余数据
    if (self.tempArrayB.count > 5) {
        for (int i = 5; i < self.tempArrayB.count; i++) {
            [self.tempArrayB removeObjectAtIndex:i];
        }
    }
    
    //5.把最新的数据存储到userDefaults当中
    [defaults setObject:self.tempArrayB forKey:@"vinCode"];
    
    //6.确定显示最终数据源
    self.dataArray = self.tempArrayB;
    
    //7.刷新列表
    [self.vinTF resignFirstResponder];
}

#pragma mark - ------------------------------------控件代理方法----------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YHScanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YHScanCell"];
    [cell refreshUIWithVinStr:self.dataArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *vin = self.dataArray[indexPath.row];
    if (vin.length == 17) {
        YHReportListViewController *VC = [[UIStoryboard storyboardWithName:@"YHScan" bundle:nil] instantiateViewControllerWithIdentifier:@"YHReportListViewController"];
        VC.vin = vin;
        [self.navigationController pushViewController:VC animated:YES];
    } else {
        [MBProgressHUD showError:@"请选择17位的字母数字组合车架号"];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.vinTF) {
        if (self.vinTF.text.length < 17) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return YES;
    }
}

#pragma mark - -------------------------------------点击事件-------------------------------------------
#pragma mark - 1.提交
- (IBAction)submit:(UIButton *)sender {
    if (self.vinTF.text.length == 17) {
        YHReportListViewController *VC = [[UIStoryboard storyboardWithName:@"YHScan" bundle:nil] instantiateViewControllerWithIdentifier:@"YHReportListViewController"];
        VC.vin = self.vinTF.text;
        [self.navigationController pushViewController:VC animated:YES];
        
        [self reloadTableView];
    } else {
        [MBProgressHUD showError:@"请输入17位字母数字组合车架号"];
    }
}

#pragma mark - 2.扫描
- (IBAction)scan:(UIButton *)sender {
    SmartOCRCameraViewController *smartVC = [[SmartOCRCameraViewController alloc]init];
    smartVC.recogOrientation = RecogInVerticalScreen;
    smartVC.preController = self;
    [self.navigationController pushViewController:smartVC animated:YES];
}

#pragma mark - --------------------------------------懒加载--------------------------------------------
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (NSMutableArray *)tempArrayA{
    if (!_tempArrayA) {
        _tempArrayA = [[NSMutableArray alloc]init];
    }
    return _tempArrayA;
}

- (NSMutableArray *)tempArrayB{
    if (!_tempArrayB) {
        _tempArrayB = [[NSMutableArray alloc]init];
    }
    return _tempArrayB;
}

@end
