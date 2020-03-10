//
//  YHHelpSellService.h
//  YHCaptureCar
//
//  Created by Jay on 2018/3/22.
//  Copyright © 2018年 YH. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TTZCarModel,YHReservationModel,offerModel,ZZCity,YTCarModel;

#define kPageSize 10

@interface YHHelpSellService : NSObject
#pragma mark -    检测车商是否是关联车商

//参数名    必选    类型    说明
//reqAct    是    string    请求方法，固定填写 checkDealer
//accId    是    string    接入者账号
//token    是    string    用户会话标识
//time    是    string    yyyy-MM-dd HH:mm:ss
//sign    是    string    MD5签名
+(void)checkDealerOnComplete:(void (^)(YHReservationModel *))success
                     onError:(void (^)(NSError *error))failure;

#pragma mark -    捕车广告列表

//参数名    必选    类型    说明
//reqAct    是    string    请求方法，固定填写 advList
//accId    是    string    接入者账号
//token    是    string    用户会话标识
//time    是    string    yyyy-MM-dd HH:mm:ss
//sign    是    string    MD5签名
+(void)advListOnComplete:(void (^)(NSDictionary *))success
                 onError:(void (^)(NSError *error))failure;


#pragma mark -    APP支付回调接口
/**
 参数名    必选    类型    说明
 reqAct    是    string    请求方法，固定填写 rptPayCallBack
 accId    是    string    接入者账号
 token    是    string    token
 id    是    string    支付订单号(支付接口返回的orderId)
 time    是    string    yyyy-MM-dd HH:mm:ss
 sign    是    string    MD5签名
 **/
+(void)rptPayCallBackWithId:(NSString *)Id
                 onComplete:(void (^)(NSString *))success
                    onError:(void (^)(NSError *error))failure;


#pragma mark -支付报告费接口


//reqAct    是    string    请求方法，固定填写 toHelpRptPay
//accId    是    string    接入者账号
//token    是    string    token
//code    是    string    前端返给app的code
//time    是    string    yyyy-MM-dd HH:mm:ss
//sign    是    string    MD5签名

+(void)toHelpRptPayCode:(NSString *)code
             onComplete:(void (^)(NSDictionary *))success
                onError:(void (^)(NSError *error))failure;



#pragma mark -根据VIN获取报告信息

//参数名    必选    类型    说明
//reqAct    是    string    请求方法，固定填写 findVinReport
//accId    是    string    接入者账号
//token    是    string    用户会话标识
//vin    是    string    车架号
//time    是    string    yyyy-MM-dd HH:mm:ss
//sign    是    string    MD5签名

+(void)findVinReportWithVin:(NSString *)vin
                 onComplete:(void (^)(NSDictionary *))success
                    onError:(void (^)(NSError *error))failure;


#pragma mark -    检测车商是否是关联车商

//参数名    必选    类型    说明
//reqAct    是    string    请求方法，固定填写 checkDealer
//accId    是    string    接入者账号
//token    是    string    用户会话标识
//time    是    string    yyyy-MM-dd HH:mm:ss
//sign    是    string    MD5签名
+(void)checkDealerOnComplete:(void (^)(YHReservationModel *))success
                     onError:(void (^)(NSError *error))failure;


#pragma mark -    捕车广告列表

//参数名    必选    类型    说明
//reqAct    是    string    请求方法，固定填写 advList
//accId    是    string    接入者账号
//token    是    string    用户会话标识
//time    是    string    yyyy-MM-dd HH:mm:ss
//sign    是    string    MD5签名
+(void)advListOnComplete:(void (^)(NSDictionary *))success
                 onError:(void (^)(NSError *error))failure;


#pragma mark -    支付报告费接口
//参数名    必选    类型    说明
//reqAct    是    string    请求方法，固定填写 toRptPay
//accId    是    string    接入者账号
//token    是    string    token
//code    是    string    前端返给app的code
//time    是    string    yyyy-MM-dd HH:mm:ss
//sign    是    string    MD5签名
+(void)payRptTradeWithCode:(NSString *)code
                onComplete:(void (^)(NSString *wxPrepayId,NSString *orderId))success
                   onError:(void (^)(NSError *error))failure;

#pragma mark -    支付报告费接口(梅文峰)
//参数名    必选    类型    说明
//reqAct    是    string    请求方法，固定填写 toRptPay
//accId    是    string    接入者账号
//token    是    string    token
//code    是    string    前端返给app的code
//time    是    string    yyyy-MM-dd HH:mm:ss
//sign    是    string    MD5签名
+(void)payRptTradeVersionTwoWithCode:(NSString *)code
                          onComplete:(void (^)(NSDictionary *info))success
                             onError:(void (^)(NSError *error))failure
;

#pragma mark -    APP支付回调接口
/**
 参数名    必选    类型    说明
 reqAct    是    string    请求方法，固定填写 payCallBack
 accId    是    string    接入者账号
 token    是    string    token
 id    是    string    帮检id
 time    是    string    yyyy-MM-dd HH:mm:ss
 sign    是    string    MD5签名
 **/
+(void)payCallBackWithId:(NSString *)Id
              onComplete:(void (^)(void))success
                 onError:(void (^)(NSError *error))failure;


#pragma mark -    发起帮检费的支付
/**
 参数名    必选    类型    说明
 reqAct    是    string    请求方法，固定填写 toPay
 accId     是    string    接入者账号
 token     是    string    token
 id        是    string    帮检id
 time      是    string    yyyy-MM-dd HH:mm:ss
 sign      是    string    MD5签名
 **/
+(void)payHelpTradeWithId:(NSString *)Id
               onComplete:(void (^)(NSString *wxPrepayId,NSString *orderId))success
                  onError:(void (^)(NSError *error))failure;

#pragma mark - 发起帮检费的支付(梅文峰)
/**
 参数名    必选    类型    说明
 reqAct    是    string    请求方法，固定填写 toPay
 accId     是    string    接入者账号
 token     是    string    token
 id        是    string    帮检id
 time      是    string    yyyy-MM-dd HH:mm:ss
 sign      是    string    MD5签名
 **/
+(void)payHelpTradeVersionTwoWithId:(NSString *)Id
                         onComplete:(void (^)(NSDictionary *info))success
                            onError:(void (^)(NSError *error))failure;

#pragma mark -    获取检测费用
/**
 参数名    必选    类型    说明
 reqAct    是    string    请求方法，固定填写 findDetectionFee
 accId    是    string    接入者账号
 token    是    string    用户会话标识
 carModelId    否    string    车型车系ID
 carLineId    否    string    车系ID
 carBrandId    否    string    品牌ID
 time    是    string    请求时间，格式yyyy-MM-dd HH:mm:ss
 sign    是    string    md5签名
 **/
+(void)detectionFeeForCarModelId:(NSString *)carModelId
                       carLineId:(NSString *)carLineId
                      carBrandId:(NSString *)carBrandId
                             vin:(NSString *)vinStr
                      onComplete:(void (^)(NSString *))success
                         onError:(void (^)(NSError *error))failure;

#pragma mark -    预约帮检
/**
 reqAct    是    string    请求方法，固定填写 input
 accId    是    string    接入者账号
 token    是    string    用户会话标识
 vin    是    string    车架号
 carFullName    是    string    车型车系
 contactUser    是    string    联系人
 contactTel    是    string    联系人电话
 org_id    是    string    检测站ID
 orgName    是    string    检测站点名称
 time    是    string    请求时间，格式yyyy-MM-dd HH:mm:ss
 sign    是    string    md5签名
 
 **/
+(void)inputWithVin:(NSString *)vin
        carFullName:(NSString *)carFullName
        contactUser:(NSString *)contactUser
         contactTel:(NSString *)contactTel
     smsNotifyPhone:(NSString *)smsNotifyPhone
           bookDate:(NSString *)bookDate
             org_id:(NSString *)org_id
            orgName:(NSString *)orgName
          carLineId:(NSString *)carLineId
         carBrandId:(NSString *)carBrandId
         onComplete:(void (^)(NSString *Id))success
            onError:(void (^)(NSError *error))failure;

#pragma mark -    站点列表
/**
 reqAct    是    string    请求方法，固定填写 stationList
 accId    是    string    接入者账号
 token    是    string    用户会话标识
 addrKeyWord    否    string    站点地址关键字（如：城市名）
 **/
+(void)stationListOnComplete:(void (^)( NSMutableArray <YHReservationModel *>*models))success
                     onError:(void (^)(NSError *error))failure;





#pragma mark -    正在竞拍 或者 竞拍记录
/**
 reqAct 请求方法，固定填写 findAuctionList  Y
 accId  接入者账号   Y
 token  token串  Y
 type   0、正在竞拍  1、竞拍记录 Y
 page   当前页数    Y
 rows   每页条数    Y
 time   请求时间，格式yyyy-MM-dd HH:mm:ss  Y
 sign   md5签名   Y
 **/
+(void)findAuctionListForPage:(NSInteger)page
                 isAuctioning:(BOOL)type
                   onComplete:(void (^)( NSMutableArray <TTZCarModel *>*models, NSInteger time))success
                      onError:(void (^)(NSError *error))failure;


#pragma mark -    销售记录
/**
 reqAct 请求方法，固定填写 sellRecordList  Y
 accId  接入者账号   Y
 token  token串  Y
 page   当前页数    Y
 rows   每页条数    Y
 time   请求时间，格式yyyy-MM-dd HH:mm:ss  Y
 sign   md5签名   Y
 **/
+(void)sellRecordListForPage:(NSInteger)page
                  onComplete:(void (^)( NSMutableArray <TTZCarModel *>*models))success
                     onError:(void (^)(NSError *error))failure;



#pragma mark -    在库车辆
/**
 reqAct 请求方法，固定填写 inventoryList  Y
 accId  接入者账号   Y
 token  token串  Y
 page   当前页数    Y
 rows   每页条数    Y
 time   请求时间，格式yyyy-MM-dd HH:mm:ss  Y
 sign   md5签名   Y
 **/
+(void)inventoryListForPage:(NSInteger)page
                 onComplete:(void (^)( NSMutableArray <TTZCarModel *>*models))success
                    onError:(void (^)(NSError *error))failure;


#pragma mark -    我的收藏
/**
 reqAct 请求方法，固定填写 collectList  Y
 accId  接入者账号   Y
 token  token串  Y
 page   当前页数    Y
 rows   每页条数    Y
 time   请求时间，格式yyyy-MM-dd HH:mm:ss  Y
 sign   md5签名   Y
 **/
+(void)myCollectListForPage:(NSInteger)page
                 onComplete:(void (^)( NSMutableArray <TTZCarModel *>*models))success
                    onError:(void (^)(NSError *error))failure;


+(void)payRptTradeVersionTwoWithCode:(NSString *)code
                          onComplete:(void (^)(NSDictionary *info))success
                             onError:(void (^)(NSError *error))failure;
#pragma mark -    车商联盟搜索
/**
 reqAct 请求方法，固定填写 findEntrustTradeList Y
 accId  接入者账号   Y
 token  token串  Y
 searchContent  搜索的内容   N
 page   当前页数    Y
 rows   每页条数    Y
 **/
+(void)searchEntrustTradeForPage:(NSInteger)page
                   searchContent:(NSString *)keyword
                         carType:(NSInteger)type
                      onComplete:(void (^)( NSMutableArray <TTZCarModel *>*models))success
                         onError:(void (^)(NSError *error))failure;


#pragma mark -    车商联盟
/**
 reqAct 请求方法，固定填写 findEntrustTradeList Y
 accId  接入者账号   Y
 token  token串  Y
 searchContent  搜索的内容   N
 page   当前页数    Y
 rows   每页条数    Y
 **/
+(void)getEntrustTradeListForPage:(NSInteger)page
                          carType:(NSInteger)type
                       onComplete:(void (^)( NSMutableArray <TTZCarModel *>*models))success
                          onError:(void (^)(NSError *error))failure;

#pragma mark -    报价咨询
/**
 参数名    必选    类型    说明
 reqAct    是    string    请求方法，固定填写 findSuggestPrice
 accId    是    string    接入者账号
 token    是    string    用户会话标识
 type    是    string    类型 0 查询价格 1 询价
 carId    是    string    车辆ID
 **/
+(void)findSuggestPriceWithCarId:(NSString *)carId
                            type:(NSInteger)type
                      onComplete:(void (^)(NSString *suggestPrice ,BOOL isEnquiry))success
                         onError:(void (^)(NSError *error))failure;

#pragma mark -    买家出价列表
/**
 参数名    必选    类型    说明
 reqAct    是    string    请求方法，固定填写 findOfferList
 accId    是    string    接入者账号
 token    是    string    用户会话标识
 carId    是    string    车辆id
 startTime    否    string    开始时间 yyyy-MM-dd
 endTime    否    string    结束时间 yyyy-MM-dd
 **/
+(void)findOfferListWithCarId:(NSString *)carId
                    startTime:(NSString *)startTime
                      endTime:(NSString *)endTime
                   onComplete:(void (^)( NSMutableArray <offerModel *>*models))success
                      onError:(void (^)(NSError *error))failure;



#pragma mark -    保存买家报价
/**
 参数名    必选    类型    说明
 reqAct    是    string    请求方法，固定填写 saveBuyerOffer
 accId    是    string    接入者账号
 carId    是    string    车辆ID
 price    是    string    报价
 brokerage    是    string    佣金
 **/
+(void)saveBuyerOfferWithCarId:(NSString *)carId
                         price:(NSString *)price
                     brokerage:(NSString *)brokerage
                    onComplete:(void (^)(void))success
                       onError:(void (^)(NSError *error))failure;


+(void)findCityListOnComplete:(void (^)(ZZCity*city))success
                      onError:(void (^)(NSError *error))failure;


#pragma mark -    在库车辆详情

/**
 参数名    必选    类型    说明
 reqAct    是    string    请求方法，固定填写 detail
 accId    是    string    接入者账号
 token    是    string    用户会话标识
 carId    是    string    车辆ID
 **/
+(void)erpAuthDetailWithCarId:(NSString *)carId
            onComplete:(void (^)(YTCarModel *))success
               onError:(void (^)(NSError *error))failure;

+(void)helpBuyAuthDetailWithCarId:(NSString *)carId
                       onComplete:(void (^)(YTCarModel *))success
                          onError:(void (^)(NSError *error))failure;

+(void)toHelpBuyCarPayWithId:(NSString *)workOrderId
                     payType:(NSInteger )payType
                  onComplete:(void (^)(NSDictionary *h5Par,NSDictionary *wxPar))success
                     onError:(void (^)(NSError *error))failure;
@end
