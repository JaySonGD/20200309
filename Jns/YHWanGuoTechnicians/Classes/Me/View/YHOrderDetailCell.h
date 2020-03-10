//
//  YHOrderDetailCell.h
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/4/17.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTZPhotoCell : UICollectionViewCell
@property (strong, nonatomic)  UIImageView *imageView;
@end


@interface YHOrderDetailCell : UITableViewCell
- (void)loadDatasourceBaseInfo:(NSDictionary*)sysInfo isBlockPolicy:(NSNumber*)isBlockPolicy billType:(NSString*)billType;
- (void)loadDatasourcefaultPhenomenonDescs:(NSString*)desc title:(NSString*)title;
- (void)loadDatasourceFaultPhenomenon:(NSArray*)info title:(NSString*)title;
- (void)loadDatasourceConsultingLamp:(NSDictionary*)lampInfo title:(NSString*)title;
- (void)loadreportBillData:(NSDictionary*)info title:(NSString*)title;
- (void)loadDatasourceConsulting:(NSArray*)consultingInfo title:(NSString*)title;
- (void)loadDatasource:(NSArray*)infos title:(NSString*)title;
- (void)loadDatasourceInitialSurveyProject:(NSArray*)info sysClassId:(NSString*)sysClassId;
- (void)loadDatasourceInitialSurveyProject:(NSArray*)info sysClassId:(NSString*)sysClassId isPrice:(BOOL)isPrice isEditPrice:(BOOL)isEditPrice;
- (void)loadDatasource:(NSDictionary*)sysInfo;
- (void)loadDatasourceResult:(NSString*)result title:(NSString*)title;
- (void)loadDatasourceResult:(NSString*)result;

- (void)loadDatasourceConsulting:(NSDictionary*)consultingInfo;
- (void)loadDatasourceTime:(NSDictionary*)modeInfo;
- (void)loadDatasourceProgramme:(NSDictionary*)modeInfo;
- (void)loadDatasourceMode:(NSDictionary*)modeInfo isShowAllPrice:(BOOL)isShowAllPrice;
@end
