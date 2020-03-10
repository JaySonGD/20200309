//
//  PCMusculatureController.m
//  penco
//
//  Created by Jay on 5/7/2019.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import "PCMusculatureController.h"

#import "PCMusculatureModel.h"

#import "YHCommon.h"

#import <UIImageView+WebCache.h>

@interface PCMusculatureController ()<UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *tableViewBox;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewH;

@end

@implementation PCMusculatureController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addShadowToView:self.tableViewBox withColor:YHColor0X(0xD2B081, 1.0)];
    
    

    // 获取准确的contentSize前调用
    [self.tableView layoutIfNeeded];
    
    
    CGFloat h =self.tableView.contentSize.height;
    if (h >= (screenHeight - 44)) {
        h = (screenHeight - 44);
        self.tableView.scrollEnabled = YES;
    }
    
    self.tableViewH.constant = h;
}
- (IBAction)hideView:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    UILabel *bodyPartName = cell.contentView.subviews.firstObject;
    UILabel *bodyPartDescribe = cell.contentView.subviews.lastObject;
    UIImageView *bodyPartImage = cell.contentView.subviews[1];

    
    bodyPartDescribe.text = self.model.bodyPartDescribe;
    bodyPartName.text = self.model.bodyPartName;
    [bodyPartImage sd_setImageWithURL:[NSURL URLWithString:self.model.bodyPartImage]];
    

    
    return cell;
}

/// 添加四边阴影效果
- (void)addShadowToView:(UIView *)theView withColor:(UIColor *)theColor {
    // 阴影颜色
    theView.layer.shadowColor = theColor.CGColor;
    // 阴影偏移，默认(0, -3)
    theView.layer.shadowOffset = CGSizeMake(0,0);
    // 阴影透明度，默认0
    theView.layer.shadowOpacity = 0.5;
    // 阴影半径，默认3
    theView.layer.shadowRadius = 5;
    
    //圆角
    theView.layer.cornerRadius = 15;
    
}


@end
