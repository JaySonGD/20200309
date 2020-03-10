//
//  YHOrderCell.m
//  YHWanGuoOwner
//
//  Created by Zhu Wensheng on 2017/3/14.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHOrderCell.h"
#import "YHFunctionsEditerController.h"
#import "YHCommon.h"
#import "YHOrderTypeCell.h"
#import "EqualSpaceFlowLayoutEvolve.h"
#import "YHTools.h"
#import <UIImageView+WebCache.h>
@interface YHOrderCell ()
@property (weak, nonatomic) IBOutlet UILabel *numberL;

@property (weak, nonatomic) IBOutlet UILabel *timeL;

//当前状态按钮
@property (weak, nonatomic) IBOutlet UIButton *stateB;
@property (weak, nonatomic) IBOutlet UILabel *stateL;

@property (weak, nonatomic) IBOutlet UILabel *phoneNumberL;
@property (weak, nonatomic) IBOutlet UILabel *nameL;

//最新指派技师姓名
@property (weak, nonatomic) IBOutlet UILabel *techNicknameL;
@property (weak, nonatomic) IBOutlet UILabel *orderStep;
@property (weak, nonatomic) IBOutlet UIImageView *carImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeCollectionViewBottomLC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeCollectionViewHeightLC;
@property (weak, nonatomic) IBOutlet UILabel *amountL;
@property (weak, nonatomic) IBOutlet UILabel *amountPL;
@property (weak, nonatomic) IBOutlet UILabel *orderEnd;
@property (weak, nonatomic) IBOutlet UILabel *assignF;
@property (weak, nonatomic) IBOutlet UIButton *timeOutB;
@property (weak, nonatomic) IBOutlet UIButton *receiveB;
@property (weak, nonatomic) IBOutlet UILabel *cashFL;
@property (weak, nonatomic) IBOutlet UILabel *orderIdL;
@property (weak, nonatomic) IBOutlet UILabel *payStateL;
@property (weak, nonatomic) IBOutlet UILabel *payOrderModelL;
@property (weak, nonatomic) IBOutlet UILabel *payL;
@property (weak, nonatomic) IBOutlet UILabel *payModelL;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *AssignFTop;
@property (weak, nonatomic) IBOutlet UILabel *yuyueLB;
@property (weak, nonatomic) IBOutlet UILabel *userAndPhoneLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeColletionTop;
@property (weak, nonatomic)NSDictionary *datasource;
@property (weak, nonatomic) IBOutlet UICollectionView *typeColletionView;
@property (strong, nonatomic) NSArray *orderSubs;
@property (weak, nonatomic) IBOutlet UILabel *dateL;
@end

@implementation YHOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    //    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    //    layout.itemSize = CGSizeMake(1300, 130);
    //    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //    //最小行间距(默认为10)
    //    layout.minimumLineSpacing = 5;
    //    //最小item间距（默认为10）
    //    layout.minimumInteritemSpacing = 10;
    
    EqualSpaceFlowLayoutEvolve *layout = [[EqualSpaceFlowLayoutEvolve new] initWthType:AlignWithLeft];
    layout.betweenOfCell = 10;
    
    _typeColletionView.collectionViewLayout = layout;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)loadName:(NSString*)name{
    _nameL.text = name;
}


- (void)loadDatassource:(NSDictionary*)datasource functionId:(YHFunctionId)functionId index:(NSUInteger)index {
    _receiveB.tag = index;
    
    self.datasource =datasource;
    

    //未处理订单、历史订单
    if (functionId == YHFunctionIdUnprocessedOrder || functionId == YHFunctionIdHistoryOrder) {
        _payStateL.hidden = functionId == YHFunctionIdUnprocessedOrder;
        _payModelL.hidden = functionId == YHFunctionIdUnprocessedOrder;
        _cashFL.textColor = ((functionId == YHFunctionIdUnprocessedOrder) ? (YHNaviColor) : (YHCellColor));
        _payL.textColor = ((functionId == YHFunctionIdUnprocessedOrder) ? (YHNaviColor) : (YHCellColor));
        _payL.text = datasource[@"payAmount"];
        _payOrderModelL.text = datasource[@"productName"];
        _payStateL.text = @{@"notPay" : @"待支付", @"succeedPay" : @"支付成功", @"payIng" : @"支付中", @"closePay" : @"取消支付"}[datasource[@"isPay"]];
        _payModelL.text = @{@"WXPAY" : @"微信支付", @"EXPPAY" : @"体验金支付", @"VIP" : @"会员优惠"}[datasource[@"payForm"]];
        _orderIdL.text = [NSString stringWithFormat:@"订单号：%@", datasource[@"orderOpenId"]];
        _numberL.text = datasource[@"plateNumber"];
        _phoneNumberL.text = EmptyStr(datasource[@"phone"]) ;
        _timeL.text = datasource[@"creationTime"];
        
    }else{
        
        NSString *phone = [datasource valueForKey:@"phone"];
        NSString *userName = [datasource valueForKey:@"userName"];
        NSString *channelCode = [datasource valueForKey:@"channelCode"];
        
        if (YHFunctionIdUnfinishedWorkOrder == functionId && !IsEmptyStr(channelCode) && (!IsEmptyStr(phone) || !IsEmptyStr(userName)) ) {
            self.AssignFTop.constant = 28 + 47;
            self.typeColletionTop.constant = 79 + 47;
            self.yuyueLB.hidden = NO;
            self.userAndPhoneLB.hidden = NO;

            self.userAndPhoneLB.text = [NSString stringWithFormat:@"%@ %@",userName,phone];
            
        }else{
            self.AssignFTop.constant = 28;
            self.typeColletionTop.constant = 79;
            self.yuyueLB.hidden = YES;
            self.userAndPhoneLB.hidden = YES;

        }
        
        self.orderSubs = datasource[@"billTypeNameData"];
        _typeCollectionViewHeightLC.constant = 50 * ((_orderSubs.count / 2) + (((_orderSubs.count % 2) > 0)? (1) : (0)));
        _assignF.hidden = !(functionId == YHFunctionIdUnfinishedWorkOrder);
        _techNicknameL.hidden = !(functionId == YHFunctionIdUnfinishedWorkOrder);
        _dateL.hidden = !(functionId == YHFunctionIdUnfinishedWorkOrder);
        _orderStep.hidden = !((functionId == YHFunctionIdUnfinishedWorkOrder)
                              && [datasource[@"ownerChooseRepairMode"] isEqualToString:@"1"] && datasource[@"ownerChooseRepairMode"]);
        
        _nameL.hidden = (functionId == YHFunctionIdUnfinishedWorkOrder);
        _timeL.hidden = (functionId == YHFunctionIdUnfinishedWorkOrder);
        _phoneNumberL.hidden = (functionId == YHFunctionIdUnfinishedWorkOrder);
        
        
        
        NSString *billStatus = datasource[@"billStatus"];
        _orderEnd.hidden = !([billStatus isEqualToString:@"close"] && (functionId == YHFunctionIdHistoryWorkOrder));
        _amountL.hidden = !([billStatus isEqualToString:@"complete"] && (functionId == YHFunctionIdHistoryWorkOrder));
        _amountPL.hidden = !([billStatus isEqualToString:@"complete"] && (functionId == YHFunctionIdHistoryWorkOrder));
        
        
        _typeCollectionViewBottomLC.constant = ((((functionId == YHFunctionIdUnfinishedWorkOrder)
                                                  && [datasource[@"ownerChooseRepairMode"] isEqualToString:@"1"] && datasource[@"ownerChooseRepairMode"])
                                                 || ([billStatus isEqualToString:@"close"] && (functionId == YHFunctionIdHistoryWorkOrder))
                                                                                                                                                                                                                                                                                                                                                                                                             || ([billStatus isEqualToString:@"complete"] && (functionId == YHFunctionIdHistoryWorkOrder)))? (36) : (10));
        
        _stateB.hidden = (functionId == YHFunctionIdHistoryWorkOrder);
        
        _timeOutB.layer.borderWidth  = 1;
        _timeOutB.layer.borderColor  = [UIColor redColor].CGColor;
        
        
        
        BOOL appointmentDated =  ((NSNumber*)datasource[@"appointmentDated"]).intValue == 0;
        _timeOutB.hidden =  appointmentDated;
        _timeL.textColor =  ((appointmentDated)? ([UIColor blackColor]) : ([UIColor redColor]));
        
        BOOL notFound =  YES;
        
        _receiveB.hidden = ![datasource[@"channelCode"] isEqualToString:@"YHSYS10000"] || !notFound || (functionId == YHFunctionIdHistoryWorkOrder) ;
        
        if (notFound && (functionId != YHFunctionIdHistoryWorkOrder)) {
            if (([datasource[@"nowStatusCode"] isEqualToString:@"carAppointment"] &&  [datasource[@"nextStatusCode"] isEqualToString:@"consulting"])) {
                [_receiveB setTitle:@"接单" forState:UIControlStateNormal];
                _receiveB.backgroundColor = YHNaviColor;
                [_receiveB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }else{
                _receiveB.hidden = YES;
                [_receiveB setTitle:@"已接单" forState:UIControlStateNormal];
                _receiveB.backgroundColor = [UIColor whiteColor];
                [_receiveB setTitleColor:YHCellColor forState:UIControlStateNormal];
            }
        }
        
        _numberL.text = [NSString stringWithFormat:@"%@ %@%@", datasource[@"plateNumberP"],datasource[@"plateNumberC"],datasource[@"plateNumber"]];
        [_stateB setTitle:datasource[@"nowStatusName"] forState:UIControlStateNormal];
        
        NSLog(@"-----====%@====------",datasource[@"nowStatusName"]);
        
        //未完成工单
        if (functionId == YHFunctionIdUnfinishedWorkOrder) {
            _techNicknameL.text = datasource[@"techNickname"];
        }else{
            _nameL.text = datasource[@"userName"];
            _phoneNumberL.text = datasource[@"phone"];
            _amountPL.text = [NSString stringWithFormat:@"¥%@", datasource[@"realAmount"]];
        }
        
        _timeL.text = datasource[@"appointmentDate"];
        
        //预约单
        if ([datasource[@"nowStatusCode"] isEqualToString:@"carAppointment"]) {
            if (!IsEmptyStr(datasource[@"arrivalTime"])) {
                _dateL.text = [NSString stringWithFormat:@"约定到店 %@",datasource[@"arrivalTime"]];
            }else{
                if (!IsEmptyStr(datasource[@"appointmentDate"])) {
                    _dateL.text = [NSString stringWithFormat:@"预约时间 %@",datasource[@"appointmentDate"]];
                }else{
                    _dateL.text = @"预约时间待定";
                }
            }
        //其它
        }else{
            _dateL.text = datasource[@"appointmentDate"];
        }
    
        
        NSString *url = [NSString stringWithFormat:@"https://www.wanguoqiche.com/files/logo/%@.jpg", datasource[@"carBrandLogo"]];
        [self.carImage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"carModelDefault"]];
        [_typeColletionView reloadData];
        
        

    }
}

- (void)loadDatassource:(NSDictionary*)datasource functionId:(YHFunctionId)functionId{
    [self loadDatassource:datasource functionId:functionId index:0];
}


#pragma mark - collectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _orderSubs.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YHOrderTypeCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell loadInfo:_orderSubs[indexPath.row]];
    return cell;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = _orderSubs[indexPath.row];
    
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:11]};
    CGSize size = [str boundingRectWithSize:CGSizeMake(10000, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    return CGSizeMake(20 + size.width, 20);
}

- (IBAction)checkAction:(id)sender {
}

- (IBAction)cancelAction:(id)sender {
}
@end
