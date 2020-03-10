//
//  YHHelpCenterController.m
//  penco
//
//  Created by Jay on 21/6/2019.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import <Masonry/Masonry.h>
#import "UIViewController+RESideMenu.h"
#import "YHHelpCenterController.h"
#import "PCTextController.h"
#import "PCHelpCell.h"
#import "YHCommon.h"
@interface YHHelpCenterController ()
@property (nonatomic, strong)NSArray *data;
@property (nonatomic)NSInteger sel;
@end

@implementation YHHelpCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.sel = 0XFFF1;
    self.data = @[
        @{@"title" : @"1.设备安装时，如何避免安装倾斜？",
          @"detail" : @"将水平仪水平放置气泡居中，安装设备底座。"},
        @{@"title" : @"2.蓝牙无法搜索到设备？",
          @"detail" : @"确认设备处于开机状态，多次尝试；\n按开关键重启塑形尺；\n可以用尖锐物体按塑形尺reset键进行重启。"},
        @{@"title" : @"3.如何给塑形尺进行配网？",
          @"detail" : @"开启手机蓝牙，和塑形尺设备进行蓝牙配对成功后，选择可连接的网络即成功给塑形尺进行配网。"},
        @{@"title" : @"4.已经站在设备正前面，还总是提示“没有看到您，请站在设备前2米处？",
          @"detail" : @"站在设备正前方2米处，左右前后移动一下身体。"},
        @{@"title" : @"5.设备语音 “测量对象被遮挡，请移开障碍物或调整位置。",
          @"detail" : @"请移开人与设备之间的障碍物；或调整位置姿势。"},
        @{@"title" : @"6.在测量过程中，设备总是提示“请移除设备前方的障碍物。",
          @"detail" : @"确保设备安装在视野比较开阔的地方，设备周边是否有障碍物，有障碍物请把障碍物移除；\n若无障碍物，测量者需左右移动一下身体，或者检查一下测量者的着装，确保让手和脚都可被设备识别，比如宽松的衣服，遮住脚踝的裤子，都会影响测量。"},
        @{@"title" : @"7.测量过程是否有着装要求？",
          @"detail" : @"请穿着紧身衣裤或贴身衣物。如穿着宽松衣服，则无法准确测得您的身体数据。为了更精确地测量身体数据，请勿穿着皮鞋进行测量。"},
        @{@"title" : @"8.体态测量是否要求？",
          @"detail" : @"保持自然放松的站立\n避免彩色背景，或者有人物图片的背景。"},
        @{@"title" : @"9.升级失败怎么办？",
          @"detail" : @"网络出现故障，无法下载升级固件，检查网络，APP连接设备，重新升级；\n设备电量低于30%，无法进行固件升级，充电后再次进行升级；\n 固件升级失败，下次联网时重新进行升级，APP蓝牙连接设备，重新升级。"},
        @{@"title" : @"10.设备电量低于10%，无法进行测量？",
          @"detail" : @"充电后再次使用。"}
    ];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
//    view.backgroundColor = [UIColor redColor];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
    title.text = @[@"常见问题", @"APP使用说明", @"塑形尺使用说明"][section];
    [view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.bottom.mas_equalTo(0);
    }];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
    btn.tag = section;
    [btn addTarget:self action:@selector(helpShow:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
//    btn.backgroundColor = [UIColor blueColor];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    UIImageView *imageV = [UIImageView new];
    [imageV setImage:[UIImage imageNamed:(self.sel == section ? @"up" : @"down")]];
    imageV.tag = section;
    [view addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(13);
    }];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectZero];
    [line setBackgroundColor:YHColor(230, 230, 230)];
    [view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    return (section == self.sel? 1 : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    UIImageView *imageV = cell.contentView.subviews.firstObject;
    [imageV setImage:[UIImage imageNamed:@[@"help1", @"help2", @"help3"][indexPath.section]]];
    return cell;
}

- (void)helpShow:(UIButton*)btn{
    if (btn.tag == self.sel){
        self.sel = 0XFFFF;
        [self.tableView reloadData];
        return;
    }
    self.sel = btn.tag;
    
    [self.tableView reloadData];
    //获取到需要跳转位置的行数
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:self.sel];

    //滚动到其相应的位置
    [[self tableView] scrollToRowAtIndexPath:scrollIndexPath
            atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)popViewController:(id)sender{
    [super popViewController:sender];
    [self presentLeftMenuViewController:sender];
}
@end
