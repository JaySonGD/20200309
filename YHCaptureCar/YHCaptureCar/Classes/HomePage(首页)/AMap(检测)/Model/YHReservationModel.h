//
//  YHReservationModel
//  YHReservation
//  汽车修理站点列表 模型


#import "YHBaseModel.h"

@interface YHReservationModel : YHBaseModel

@property (nonatomic, copy)NSString *addr;             //汽车修理站点地址
@property (nonatomic, copy)NSString *contactName;      //联系人名称
@property (nonatomic, copy)NSString *ID;                 //站点ID
@property (nonatomic, copy)NSString *latitude;        //纬度
@property (nonatomic, copy)NSString *longitude;       //经度
@property (nonatomic, copy)NSString *name;            //站点名称
@property (nonatomic, copy)NSString *tel;             //联系人电话

@property (nonatomic, copy) NSString *smsNotifyPhone;

@property (nonatomic, copy) NSString *bookDate;
@property (nonatomic, copy) NSString *stationId;
@property (nonatomic, copy) NSString *stationName;

@property (nonatomic, assign)double distance;//目标经纬度和当前经纬度的距离


//—jnsDeptId    String    JNS站点ID
@property (nonatomic, copy) NSString *jnsDeptId;
//—isOnline    String    支持在线预约 0-不支持 1-支持
@property (nonatomic, assign) BOOL isOnline;
//—sceneIcon    String    图片名称 xh-小虎检车 bc-捕车 jns - JNS
@property (nonatomic, copy) NSString *sceneIcon;


@end
