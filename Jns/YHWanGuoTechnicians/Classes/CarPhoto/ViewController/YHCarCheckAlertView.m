//
//  YHCarCheckAlertView.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 2018/3/13.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHCarCheckAlertView.h"

#import "YHCheckProjectModel.h"

#import "YHCommon.h"

#import <Masonry/Masonry.h>

@interface YHAlertListView()
@property (nonatomic, weak) UILabel *valLB;
@property (nonatomic, weak) UILabel *nameLB;
@end
@implementation YHAlertListView
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *valLB = [[UILabel alloc] init];
        valLB.font = [UIFont systemFontOfSize:16];
        valLB.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:valLB];
        
        UILabel *nameLB = [[UILabel alloc] init];
        nameLB.textColor = YHColorWithHex(0x696969);
        nameLB.font = [UIFont systemFontOfSize:16];
        nameLB.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:nameLB];
        _valLB = valLB;
        _nameLB = nameLB;
        
        [valLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.top.equalTo(self.contentView);
            make.right.equalTo(nameLB.mas_left).offset(-8);
            make.width.equalTo(nameLB.mas_width);
        }];
        
        [nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.top.equalTo(self.contentView);
            make.height.equalTo(nameLB.mas_height);
        }];


    }
    return self;
}


- (void)setModel:(YHSurveyCheckProjectModel *)model
{
    _model = model;
    self.valLB.text = model.name;
    self.nameLB.text = model.val;
    self.valLB.textColor = model.nameColor;
//    if ([model.val isEqualToString:@"项正常"]) {
//        self.valLB.textColor = YHColorWithHex(0x46AEF7);
//
//    }else if([model.val isEqualToString:@"项异常"]) {
//        self.valLB.textColor = YHColorWithHex(0x696969);
//
//
//    }else{
//        self.valLB.textColor = YHColorWithHex(0xF24E4E);
//
//    }
}

@end


@interface YHCarCheckAlertView ()<UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewH;

@end

@implementation YHCarCheckAlertView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  -  事件监听

- (IBAction)submitAction:(UIButton *)sender {
    [self cannelAction:nil];
    !(_submitBlock)? : _submitBlock();
}
- (IBAction)cannelAction:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark  -  <UITableViewDataSource>

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YHAlertListView *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.model = self.models[indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.models.count;
}

#pragma mark  -  自定义方法

- (void)setUI{
    kViewRadius(self.alertView, 10);
    
    [self.tableView registerClass:[YHAlertListView class] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 30;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableViewH.constant = self.models.count * 30;
    self.tableView.scrollEnabled = NO;
}


@end
