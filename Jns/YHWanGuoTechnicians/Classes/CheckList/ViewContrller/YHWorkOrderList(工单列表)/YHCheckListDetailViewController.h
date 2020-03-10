//
//  YHCheckListDetailViewController.h
//  YHWanGuoTechnicians
//
//  Created by mwf on 2018/3/2.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHBaseViewController.h"

@interface YHCheckListDetailViewController : YHBaseViewController

@property (nonatomic, strong)NSString *carDealerName;
@property (nonatomic, assign) int partnerId;
@property (nonatomic, assign)BOOL isSearch; //是否搜索状态
@property (nonatomic, assign)int code;

/** type    否    int    1-代售检测分类,2-二手车帮检分类(暂只用app)*/
@property (nonatomic, assign) NSInteger type;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelWidth;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;

- (void)backRefresh;

- (void)loadNewData1;

- (void)loadNewData3;

@end
