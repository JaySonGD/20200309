//
//  YHWenXunCell.h
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/4/14.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, YHWenXunModel) {
    YHWenXunModelOil ,//油
    YHWenXunModelLamp ,//故障灯
    YHWenXunModelEngine ,//发动机
    YHWenXunModelDesc ,//描述
};
@interface YHWenXunCell : UITableViewCell

- (void)loadDatasourceInitialInspection:(NSMutableDictionary*)info index:(NSUInteger)index isExtrend:(BOOL)isExtrend;
- (void)loadDatasource:(NSDictionary*)desc number:(NSString*)number isSel:(BOOL)isSel;
- (void)loadDatasource:(NSDictionary*)desc number:(NSString*)number;
- (void)loadDatasource:(NSDictionary*)desc assign:(NSString*)assign;
- (void)loadDatasource:(NSDictionary*)desc descSub:(NSString*)descSub model:(YHWenXunModel)model;
- (void)loadDatasourceInitialInspection:(NSMutableDictionary*)info;
- (void)loadDatasource:(NSString*)desc unit:(NSString*)unit isOnly:(BOOL)isOnly;
- (void)loadDatasource:(NSString*)desc unit:(NSString*)unit isOnly:(BOOL)isOnly index:(NSUInteger)index isOn:(BOOL)isOn;
/** 是否是保养单下面的空调泄露 */
@property (nonatomic, assign) BOOL isDelayCare;
/** 是否是保养单下面的空调泄露选项数据 */
@property (nonatomic, copy) NSDictionary *optionInfo;
/** 是否点击了泄露按钮 */
@property (nonatomic,assign) BOOL isClickLeakBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoH;

@property (weak, nonatomic) IBOutlet UICollectionView *photoView;

@property (nonatomic, strong)NSIndexPath *indexPath;

@end
