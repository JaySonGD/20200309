//
//  YHReservationModel
//  YHReservation
//  汽车修理站点列表 模型


#import "YHBaseModel.h"

@interface YHReservationModel : YHBaseModel

//@property (nonatomic, copy)NSString *addr;             //汽车修理站点地址
//@property (nonatomic, copy)NSString *contactName;      //联系人名称
//@property (nonatomic, copy)NSString *ID;                 //站点ID
//@property (nonatomic, copy)NSString *latitude;        //纬度
//@property (nonatomic, copy)NSString *longitude;       //经度
//@property (nonatomic, copy)NSString *name;            //站点名称
//@property (nonatomic, copy)NSString *tel;             //联系人电话
//
//@property (nonatomic, copy) NSString *smsNotifyPhone;
//
//@property (nonatomic, copy) NSString *bookDate;
//@property (nonatomic, copy) NSString *stationId;
//@property (nonatomic, copy) NSString *stationName;

@property (nonatomic, copy)NSString *ID;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *contact_name;
@property (nonatomic, copy)NSString *contact_tel;
@property (nonatomic, copy)NSString *lng;
@property (nonatomic, copy)NSString *lat;
@property (nonatomic, copy)NSString *coordinate_ico;
@property (nonatomic, copy)NSString *address;

@property (nonatomic, assign)double distance;//目标经纬度和当前经纬度的距离

@end
