//
//  YHNetworkManager.h
//  FTBOCOpSdk
//
//  Created by 朱文生 on 15-1-30.
//  Copyright (c) 2015年 FTSafe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHCommon.h"
#import "SynthesizeSingleton.h"
#import "YHNetBaseManager.h"
//FIXME: 生产环境
#ifdef YHProduction
//生产
//#define SERVER_JAVA_URL "https://www.wanguoqiche.com"
#define SERVER_JAVA_URL "https://www.51buche.com"
//#define SERVER_JAVA_URL "https://vin.wanguoqiche.com"
//#define SERVER_JAVA_URL "http://192.168.1.42:8080"
//#define SERVER_JAVA_URL "http://192.168.1.56:8080"
//#define SERVER_JAVA_URL "http://119.29.10.240"
#define SERVER_JAVA_Image_URL "https://www.51buche.com/files/upload/images/car/"
#define SERVER_JAVA_Trunk @"/buche/api"
#define signKeyBoss @"mafubang@mh.Key"
#define signKeyManager @"402881yy55dcd8ad0155dddd7f89006a"

#define SERVER_PHP_H5_Trunk "/bucheService"
#define SERVER_PHP_URL_Statements_H5 "https://www.51buche.com"
#define SERVER_PHP_URL_H5_Vue @"https://www.wanguoqiche.com/jns"
//报告
#define SERVER_JAVA_REPORT_URL @"https://www.wanguoqiche.com/owner/look_report.html?push=1&report_type=E&hideId=1"  //生产

#define SERVER_SHARE_URL_H5 @"https://www.51buche.com/jns"


#endif
//TODO: 生产demo
#ifdef YHProduction_Demo
//生产demo

#define SERVER_JAVA_URL "https://vin.wanguoqiche.com"
//#define SERVER_JAVA_URL "https://www.51buche.com"
#define SERVER_JAVA_Image_URL "https://www.51buche.com/demoFiles/upload/images/car/"
#define SERVER_JAVA_Trunk @"/csc-demo"
#define signKeyBoss @"mafubang@mh.Key"
#define signKeyManager @"4028816455dcd8ad0asdfddd7f89006a"
https://www.51buche.com/bcFiles/helpsellcar/20180330/1522409642527O1D0B8KXTI.jpg
#endif
//MARK: 测试环境
#ifdef YHTest
//测试环境

//#define SERVER_JAVA_URL "https://vin.wanguoqiche.com"
//#define SERVER_JAVA_URL "http://192.168.1.200:8080"
#define SERVER_JAVA_URL "http://www.mhace.cn"
#define SERVER_JAVA_Image_URL "https://www.51buche.com/files/upload/images/car/"
#define SERVER_JAVA_Trunk @"/bucheTest/api"
#define signKeyBoss @"mafubang@mh.Key"
#define signKeyManager @"4028816455dcd8ad0155dddd7f89006a"

#define SERVER_PHP_H5_Trunk "/bucheServiceTest"
#define SERVER_PHP_URL_Statements_H5 "http://192.168.1.200"
//报告
#define SERVER_JAVA_REPORT_URL @"http://static.demo.com/chezhu/look_report.html?push=1&report_type=E&hideId=1"  //测试

#define SERVER_SHARE_URL_H5 @"http://www.mhace.cn/jnsTest"


#endif
//FIXME: 开发环境
#ifdef YHDev
//开发环境

//#define SERVER_JAVA_URL "http://www.wanguoqiche.cn"
//#define SERVER_JAVA_URL "https://vin.wanguoqiche.com"
#define SERVER_JAVA_URL "http://www.mhace.cn"
//#define SERVER_JAVA_URL "http://192.168.1.222"

//#define SERVER_JAVA_URL "http://192.168.1.56:8080"
//#define SERVER_JAVA_URL "http://119.29.10.240"
#define SERVER_JAVA_Image_URL "https://www.51buche.com/files/upload/images/car/"
#define SERVER_JAVA_Trunk @"/bucheDev/api"
#define signKeyBoss @"mafubang@mh.Key"
#define signKeyManager @"44676A3E62E4489DB209D6AC6F291FEF"

#define SERVER_PHP_H5_Trunk "/bucheServiceDev"
//#define SERVER_PHP_URL_Statements_H5 "http://192.168.1.200"
#define SERVER_PHP_URL_Statements_H5 "http://www.mhace.cn"
#define SERVER_PHP_URL_H5_Vue @"http://www.mhace.cn/jnsDev"

//报告
#define SERVER_JAVA_REPORT_URL @"http://dev.demo.com/chezhu/look_report.html?push=1&report_type=E&hideId=1"  //开发

#define SERVER_SHARE_URL_H5 @"https://www.mhace.cn/jnsDev"


#endif

#ifdef YHLocation

//#define SERVER_JAVA_URL "http://www.wanguoqiche.cn"
//#define SERVER_JAVA_URL "https://vin.wanguoqiche.com"
//#define SERVER_JAVA_URL "http://192.168.1.222"//先清
//#define SERVER_JAVA_URL "http://192.168.1.252"//刘行
//#define SERVER_JAVA_URL "http://192.168.1.236"//高层
#define SERVER_JAVA_URL "http://192.168.1.233"
#define SERVER_JAVA_Image_URL "https://www.51buche.com/files/upload/images/car/"
#define SERVER_JAVA_Trunk @"/buche/api"
#define signKeyBoss @"mafubang@mh.Key"
#define signKeyManager @"44676A3E62E4489DB209D6AC6F291FEF"

#define SERVER_PHP_H5_Trunk "/bucheService"
#define SERVER_PHP_URL_Statements_H5 "http://192.168.1.200"
#define SERVER_PHP_URL_H5_Vue "http://192.168.1.200"
//报告
#define SERVER_JAVA_REPORT_URL @"http://dev.demo.com/owner/look_report.html?push=1&report_type=E&hideId=1"  //开发

//轮播图
#define SERVER_JAVA_IMAGE_URL @"http://imgs.static.com/" 

#endif
@interface YHNetworkManager : YHNetBaseManager
DEFINE_SINGLETON_FOR_HEADER(YHNetworkManager);
/**
 提现
 token 登录标识
 **/
- (void)getCash:(NSString *)token onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError;
/**
 银行卡信息
 token   登录标识
 **/
- (void)getBankCardInfo:(NSString *)token onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError;
/**
 增加或者修改银行卡信息
 token   登录标识
 bankCardid 记录ID 新增的时候 留空， 修改时，必填
 bank 银行
 accountName 账户名称
 cardNum 银行卡号
 **/
- (void)addOrModifyBindBankCard:(NSString *)token bankCardId:(NSString *)bankCardid bank:(NSString *)bank accountName:(NSString *)accountName cardNum:(NSString *)cardNum onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError;
/**
 账户余额信息
 token   登录标识
 **/
- (void)surplusAccountInfo:(NSString *)token onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError;
/**
 提现列表
 token   登录标识
 startTime 开始时间 格式：yyyy-MM-dd 00:00:00
 endTime 结束时间 格式：yyyy-MM-dd 23:59:59
 page 页码，从1开始
 pageSize 每页数量
 **/
- (void)getProfitDetailList:(NSString *)token startTime:(NSString *)startTime endTime:(NSString *)endTime page:(NSString *)page pageSize:(NSString *)pageSize onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError;
/**
 获取收益明细列表
 token   登录标识
 **/
- (void)getProfitDetailList:(NSString *)token onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError;
/**
返现数据接口
 fullName 汽车全名称
 vin  车架号
 cbDate  开单时间 格式：yyyy-MM-dd HH:mm:ss
 totalPrice  保单金额（税后）
 **/
- (void)backCash:(NSString *)fullName vin:(NSString *)vin cbDate:(NSString *)cbDate totalPrice:(NSString *)totalPrice onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError;
/**
 检测手机号码是否重复
 mobile   手机号码
 type   0-注册，1-忘记密码
 **/
- (void)checkMobileRepeatType:(NSString *)type mobile:(NSString *)mobile onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError;
/**
 发送验证码
 mobile   手机号码
 type   0-注册，1-忘记密码
 **/
- (void)sendVerifyCodeType:(NSString *)type mobile:(NSString *)mobile onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError;

/**
 * 发送验证码(MWF修改)
 *
 **/
- (void)sendVerifyCodeWithToken:(NSString *)token
                           Type:(NSString *)type
                         mobile:(NSString *)mobile
                     onComplete:(void (^)(NSDictionary *info))onComplete
                        onError:(void(^)(NSError *error))onError;
/**
 验证码校验
 mobile   手机号码
 verifyCode  验证码
 type 新密码  0-注册，1-忘记密码
 
 **/
- (void)verifyCodeCheck:(NSString *)verifyCode type:(NSString *)type mobile:(NSString *)mobile onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError;
/**
 重置密码密码
 verifyCode 验证码
 newPassword  最新密码
 mobile 手机号码
 
 **/
- (void)reSetPasswordVerifyCode:(NSString *)verifyCode newPassword:(NSString *)newPassword mobile:(NSString *)mobile userName:(NSString *)userName onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError;
/**
 修改密码
 token   登录标识
 oldPasswd   旧密码
 newPassword 新密码  MD5(登录账号+密码明文) 并转为大写
 
 **/
- (void)modifyPassword:(NSString *)token oldPasswd:(NSString *)oldPasswd newPassword:(NSString *)newPassword onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError;

/**
 登录
 userName    用户登录账号
 password    密码     MD5(登录账号+密码明文) 并转为大写
 
 **/

- (void)login:(NSString*)userName
     password:(NSString*)password
   onComplete:(void (^)(NSDictionary *info))onComplete
      onError:(void (^)(NSError *error))onError;

/**
 注册
 userName    用户登录账号
 userPhone    用户手机号
 userPwd    用户密码   MD5(登录账号+密码明文) 并转为大写
 type    商户类型 0 企业  1 个人
 name    商铺名称/ 联系人名称
 address    商户地址/ 所在城市
 userHeadId    图片ID
 **/

- (void)newAcount:(NSString*)userName
        userPhone:(NSString*)userPhone
          verCode:(NSString*)verCode
          userPwd:(NSString*)userPwd
             type:(NSString*)type
             name:(NSString*)name
             city:(NSString*)cityId
          address:(NSString*)address
       userHeadId:(NSString*)userHeadId
       onComplete:(void (^)(NSDictionary *info))onComplete
          onError:(void (^)(NSError *error))onError;

/**
 获取个人/企业车商认证信息
 token    token    Y
 
 **/

- (void)userInfo:(NSString*)token
      onComplete:(void (^)(NSDictionary *info))onComplete
         onError:(void (^)(NSError *error))onError;


/**
 缴纳保证金
 token    token
 account    汇款账号
 bankName    开户行名称
 name    汇款人名称
 number    汇款流水号
 remittingTime    汇款时间
 isNew    是否是 新注册
 
 **/

- (void)paymentPledgeMoney:(NSString*)token
                   account:(NSString*)account
                  bankName:(NSString*)bankName
                      name:(NSString*)name
                    number:(NSString*)number
             remittingTime:(NSString*)remittingTime
                     isNew:(BOOL)isNew
                onComplete:(void (^)(NSDictionary *info))onComplete
                   onError:(void (^)(NSError *error))onError;


/**
 车源信息—支付接口
 token    token串
 auctionId    竞价id
 payType     是     string     支付类型 1买家支付 2卖家支付
 
 **/

- (void)getPayId:(NSString*)token
       auctionId:(NSString*)auctionId
         payType:(NSString*)payType
      onComplete:(void (^)(NSDictionary *info))onComplete
         onError:(void (^)(NSError *error))onError;


#pragma mark - 1.汽车列表
/**
 汽车列表
 menuType  是否是竞价现场 0 不是  1 是
 type      类型 0 参与的竞价 1 竞价意向 2 竞价中 3 即将开拍 4 竞价成功 5 竞价记录
 page      页数
 rows      每页条数
 **/
- (void)requestCarListWithMenuType:(NSString *)menuType
                              Type:(NSString *)type
                              page:(NSString *)page
                              rows:(NSString *)rows
                        onComplete:(void (^)(NSDictionary *info))onComplete
                           onError:(void (^)(NSError *error))onError;

#pragma mark - 2.车辆详情
/**
 汽车列表
 auctionId    竞价id
 **/
- (void)requestCarDetailsWithAuctionId:(NSString *)auctionId
                            onComplete:(void (^)(NSDictionary *info))onComplete
                               onError:(void (^)(NSError *error))onError;


#pragma mark - 3.车源信息—获取状态和价格
/**
 用户进入车源信息页面时，页面最下方展示的价格、状态或其他信息
 auctionId    竞价id
 **/
- (void)getStatusInfoAndPriceWithAuctionId:(NSString *)auctionId
                   onComplete:(void (^)(NSDictionary *info))onComplete
                      onError:(void (^)(NSError *error))onError;

#pragma mark - 4.车源信息—(竞价中)获取出价信息
/**
 汽车列表
 auctionId    竞价id
 **/
- (void)getBidInfo:(NSString *)auctionId
        onComplete:(void (^)(NSDictionary *info))onComplete
           onError:(void (^)(NSError *error))onError;

#pragma mark - 5.车源信息——(竞价中)保存出价
/**
 汽车列表
 auctionId    竞价id
 **/
- (void)saveBidPriceWithAuctionId:(NSString *)auctionId
                         bidPrice:(NSString *)bidPrice
                       onComplete:(void (^)(NSDictionary *info))onComplete
                          onError:(void (^)(NSError *error))onError;

#pragma mark - 6.车源信息—竞价意向
/**
 汽车列表
 auctionId    竞价id
 FavStatus    竞价意向状态 0收藏 1取消
 **/
- (void)auctionInatentionWithAuctionId:(NSString *)auctionId
                             FavStatus:(NSString *)FavStatus
                            onComplete:(void (^)(NSDictionary *info))onComplete
                               onError:(void (^)(NSError *error))onError;

#pragma mark - 7.车辆详情
/**
 accId    接入者账号
 token    token
 carId    车辆ID
 **/
- (void)requestCarDetailsWithToken:(NSString *)token carId:(NSString *)carId onComplete:(void (^)(NSDictionary *info))onComplete onError:(void (^)(NSError *error))onError;

#pragma mark - 8.设置帮卖价
/**
 token    token
 carId    车辆ID
 price    价格(万)
 **/
- (void)setHelpSellPriceWithToken:(NSString *)token carId:(NSString *)carId price:(NSString *)price onComplete:(void (^)(NSDictionary *info))onComplete onError:(void (^)(NSError *error))onError;

#pragma mark - 9.找帮卖/上捕车
/**
 token    token
 carId    车辆ID
 price    竞拍起拍价，type=1时必填
 type     交易类型 0、找帮卖  1、上捕车
 **/
- (void)helpSellAndUpCaptureCarWithToken:(NSString *)token carId:(NSString *)carId price:(NSString *)price type:(NSString *)type onComplete:(void (^)(NSDictionary *info))onComplete onError:(void (^)(NSError *error))onError;

#pragma mark - 10.取消找帮卖/上捕车
/**
 token        token
 carId        车辆ID
 auctionId    竞拍ID（取消捕车时必传）
 type         类型 0、取消上帮卖  1、取消上捕车
 **/
- (void)cancelHelpSellAndUpCaptureCarWithToken:(NSString *)token carId:(NSString *)carId auctionId:(NSString *)auctionId type:(NSString *)type onComplete:(void (^)(NSDictionary *info))onComplete onError:(void (^)(NSError *error))onError;

#pragma mark - 11.下架
/**
 帮卖的随时都可以下架或者售出，竞拍的在待安排状态下可以下架或售出，已安排（待开拍）的如果需要下架需要先取消竞拍，取消竞拍或者取消帮卖后状态变成 库存
 token    token
 carId    车辆ID
 price    竞拍起拍价，type=1时必填
 type     交易类型 0、找帮卖  1、上捕车
 **/
- (void)downShelfWithToken:(NSString *)token carId:(NSString *)carId price:(NSString *)price type:(NSString *)type onComplete:(void (^)(NSDictionary *info))onComplete onError:(void (^)(NSError *error))onError;

#pragma mark - 12.收藏/取消收藏
/**
 对车源进行收藏和取消收藏
 token        token
 carId        车辆ID
 favStatus    收藏状态 0 取消1 收藏
 **/
- (void)favoriteWithToken:(NSString *)token carId:(NSString *)carId favStatus:(NSString *)favStatus onComplete:(void (^)(NSDictionary *info))onComplete onError:(void (^)(NSError *error))onError;

#pragma mark - 13.竞拍结束
/**
 token        token
 auctionId    auctionId
 **/
- (void)auctionEndWithToken:(NSString *)token auctionId:(NSString *)auctionId onComplete:(void (^)(NSDictionary *info))onComplete onError:(void (^)(NSError *error))onError;

#pragma mark - 14.帮检列表
/**
 对车源进行收藏和取消收藏
 page         页码 ，从1开始
 pageSize     每页数量
 **/
- (void)requestHelpCheckListWithToken:(NSString *)token Page:(NSString *)page pageSize:(NSString *)pageSize onComplete:(void (^)(NSDictionary *info))onComplete onError:(void (^)(NSError *error))onError;

#pragma mark - 15.申请退款
/**
 token        用户会话标识
 ID           帮检记录ID
 reason       退款原因
 **/
- (void)applyRefundWithToken:(NSString *)token ID:(NSString *)ID  reason:(NSString *)reason onComplete:(void (^)(NSDictionary *info))onComplete onError:(void (^)(NSError *error))onError;

#pragma mark - 16.扫一扫-获取报告列表
/**
 reqAct         请求方法，固定填写 rptList
 accId          接入者账号
 token          用户会话标识
 vin            车架号
 pageNo         页码 ，从1开始
 pageSize       每页数量
 time           请求时间，格式yyyy-MM-dd HH:mm:ss
 sign           md5签名
 **/
- (void)rptListWithToken:(NSString *)token
                     vin:(NSString *)vin
                  pageNo:(NSString *)pageNo
                pageSize:(NSString *)pageSize
              onComplete:(void (^)(NSDictionary *info))onComplete
                 onError:(void (^)(NSError *error))onError;

#pragma mark - 17.扫一扫-获取报告详情
- (void)rptDetailWithToken:(NSString *)token
                reportCode:(NSString *)reportCode
                  billType:(NSString *)billType
                billNumber:(NSString *)billNumber
              creationTime:(NSString *)creationTime
                onComplete:(void (^)(NSDictionary *info))onComplete
                   onError:(void (^)(NSError *error))onError;

#pragma mark - 18.扫一扫-支付报告费
- (void)payReportFeeWithToken:(NSString *)token
                   reportCode:(NSString *)reportCode
                     billType:(NSString *)billType
                   billNumber:(NSString *)billNumber
                 creationTime:(NSString *)creationTime
                   onComplete:(void (^)(NSDictionary *info))onComplete
                      onError:(void (^)(NSError *error))onError;

#pragma mark - 19.扫一扫-APP支付回调接口
- (void)payCallBackWithToken:(NSString *)token
                     orderId:(NSString *)orderId
                  onComplete:(void (^)(NSDictionary *info))onComplete
                     onError:(void (^)(NSError *error))onError;

#pragma mark - 20.修改手机号
- (void)updatePhoneWithToken:(NSString *)token
                      mobile:(NSString *)mobile
                  verifyCode:(NSString *)verifyCode
                  onComplete:(void (^)(NSDictionary *info))onComplete
                     onError:(void (^)(NSError *error))onError;

#pragma mark - 21.检测用户手机本月是否还有修改次数
- (void)checkUpdatePhoneNumWithToken:(NSString *)token
                          onComplete:(void (^)(NSDictionary *info))onComplete
                             onError:(void (^)(NSError *error))onError;
/*
 上传图片
 请求方式   POST
 
 http://192.168.1.248/btlmch/index.php
 */
- (void)updatePictureImageDate:(NSArray*)images
                    onComplete:(void (^)(NSDictionary *info))onComplete
                       onError:(void (^)(NSError *error))onError;


#pragma mark - 修理厂站点列表
/*
修理厂站点列表 list     /buche/api/station
 token          是    string    用户会话标识
 addrKeyWord    否    string    站点地址关键字（如：城市名）
 */
-(void)repairShopListAddrWithToken:(NSString*)token
                           keyWord:(NSString *)addrKeyWord
                        onComplete:(void (^)(NSDictionary *info))onComplete
                           onError:(void (^)(NSError *error))onError;

#pragma mark - 预约检测
/*
预约检测 book     /buche/api/test
 token       是    string    用户会话标识
 amount      是    string    预约数量
 addr        是    string    预约地址
 tel         是    string    联系电话
 bookDate    是    string    预约日期
 stationId   是    string    修理厂ID
 stationName 是    string    修理厂名称
 */
-(void)appointmentInspectionWithToken:(NSString*)token
                               amount:(NSString *)amount
                                 addr:(NSString *)addr
                                  tel:(NSString *)tel
                             bookDate:(NSString *)bookDate
                            stationId:(NSString *)stationId
                          stationName:(NSString *)stationName
                           onComplete:(void (^)(NSDictionary *info))onComplete
                              onError:(void (^)(NSError *error))onError;

#pragma mark -  预约检测结果通知
/*
 预约检测结果通知 result    /buche/api/test
 bookId       是    long      预约id
 carDealerId  是    long      车商id
 vin          是    string    车架号
 brand        是    string    品牌型号
 desc         是    string    车型描述
 prodDate     是    string    生产时间
 regDate      否    string    注册日期（第一次上牌时间）
 km           是    decmial   公里数
 emisStandard 否    string    排放标准
 plateNo      否    string    车牌号
 addr         否    string    车辆所在地
 carNature    否    string    车辆性质
 useNature    否    string    使用性质
 insuDate     否    string    保险到期日
 keyAmount    否    int       钥匙数量
 pic          否    string    车辆图片（后缀）,多个图片以逗号分
 link         是    string    报告链接后缀
 techId       是    string    检测技师id
 techName     是    string    检测技师姓名
 */
-(void)appointmentTestResultsNotification:(NSDictionary *)dict
                     onComplete:(void (^)(NSDictionary *info))onComplete
                        onError:(void (^)(NSError *error))onError;

#pragma mark - 检测记录列表
/*
检测记录列表 detecList  /buche/api/test
 token     是    string    用户会话标识
 pageNo    是    int    当前页码，从1开始
 pageSize  是    int    每页显示数量
 */
-(void)testRecordListWithToken:(NSString*)token
                        pageNo:(NSInteger)pageNo
                      pageSize:(NSInteger)pageSize
                    onComplete:(void (^)(NSDictionary *info))onComplete
                       onError:(void (^)(NSError *error))onError;

#pragma mark - 设置车辆价格
/*
 设置车辆价格 setPrice    /buche/api/car
 token    是    string    用户会话标识
 carId    是    string    车辆id
 price    是    decimal    车辆价格（万元）
 */
-(void)SetVehiclePricesWithToken:(NSString*)token
                           carId:(NSString*)carId
                           price:(NSString*)price
                      onComplete:(void (^)(NSDictionary *info))onComplete
                         onError:(void (^)(NSError *error))onError;

#pragma mark - 车辆信息详情
/*
车辆信息详情  detail   /buche/api/car
 token    是    string    用户会话标识
 carId    是    string    车辆id
 */
-(void)vehicleInformationDetailsWithToken:(NSString*)token
                                    carId:(NSString*)carId
                               onComplete:(void (^)(NSDictionary *info))onComplete
                                  onError:(void (^)(NSError *error))onError;

#pragma mark - 待检测列表
/*
待检测列表  bookList   /buche/api/test
 token    是    string    用户会话标识
 pageNo   是    int    当前页码，从1开始
 pageSize 是    int    每页显示数量
 */
-(void)toBeDetectedlistWithToken:(NSString*)token
                          pageNo:(NSInteger)pageNo
                        pageSize:(NSInteger)pageSize
                      onComplete:(void (^)(NSDictionary *info))onComplete
                         onError:(void (^)(NSError *error))onError;

#pragma mark - 车辆信息详情
/**
 根据车辆id，获取车辆信息详情
 token     是     string     用户会话标识
 carId     是     string     车辆id
 **/
-(void)carDetail:(NSString*)token
           carId:(NSString*)carId
      onComplete:(void (^)(NSDictionary *info))onComplete
         onError:(void (^)(NSError *error))onError;

#pragma mark - 车源管理  检测录入
/**
 reqAct    请求方法，固定填写 input
 accId    接入者账号
 token    token串
 vin    车架号
 carBrandName    车系车型
 carStyle    年款
 dynamicParameter    动力参数
 model    型号
 plateNo    车牌号
 userName    联系人名称
 phone    联系人电话
 carAddress    看车地址
 emissionsStandards    排放标准
 tripDistance    里程
 productionDate    生产时间（出厂时间）
 registrationDate    注册时间
 issueDate    发证时间
 carNature    车辆性质 0 营运  1 非营运
 userNature    车辆所有者性质 0 私户  1 公户
 endAnnualSurveyDate    年检到期时间
 trafficInsuranceDate    交强险到期时间
 businessInsuranceDate    商业险到期时间
 offer    售价（帮卖价，页面新增的输入项，只能输入数字）
 carDesc    描述
 
 token     是     string     用户会话标识
 
 */
-(void)submitBasicInformationWithDictionary:(NSDictionary *)dict token:(NSString*)token onComplete:(void (^)(NSDictionary *info))onComplete onError:(void (^)(NSError *error))onError;


#pragma mark - 根据VIN获取车辆信息 只有生产可测试
/**
 获取车辆信息
 token     是     string     token
 vin     是     string     vin号
 **/
-(void)getCarInfoByVin:(NSString*)token
                   vin:(NSString*)vin
            onComplete:(void (^)(NSDictionary *info))onComplete
               onError:(void (^)(NSError *error))onError;


- (void)helpSellAndUpCaptureCarWithToken:(NSString *)token
                                   carId:(NSString *)carId
                                   price:(NSString *)price
                                    free:(NSString *)free
                                    type:(NSString *)type
                              onComplete:(void (^)(NSDictionary *info))onComplete
                                 onError:(void (^)(NSError *error))onError;
#pragma mark - 预约检测(新)
/**
 **/
-(void)appointmentInspectionWithToken:(NSString*)token
                                orgId:(NSString *)orgId
                            userPhone:(NSString *)userPhone
                              orgName:(NSString *)orgName
                             userName:(NSString *)userName
                     arrivalStartTime:(NSString *)arrivalStartTime
                       arrivalEndTime:(NSString *)arrivalEndTime
                                 desc:(NSString *)desc
                           onComplete:(void (^)(NSDictionary *info))onComplete
                              onError:(void (^)(NSError *error))onError;

#pragma mark - 补充车辆基本信息接口
/**
 
 **/
-(void)setCarBaseInfoBytoken:(NSString*)token
                       dic:(NSDictionary *)dict
                onComplete:(void (^)(NSDictionary *info))onComplete
                   onError:(void (^)(NSError *error))onError;
@end
