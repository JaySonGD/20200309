//
//  PCChartController.m
//  penco
//
//  Created by Jay on 27/6/2019.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import "PCChartController.h"
#import "PCMusculatureController.h"

#import "PCReportModel.h"
#import "YHModelItem.h"
#import "PCMusculatureModel.h"
#import "PCTestRecordModel.h"
#import "PCAAPopCell.h"


#import "YHCommon.h"
#import "YHTools.h"
#import "UIView+add.h"
#import "YHNetworkManager.h"
#import "MBProgressHUD+MJ.h"

#import <AAChartKit.h>
#import <MJExtension.h>
#import <Masonry/Masonry.h>

static const DDLogLevel ddLogLevel = DDLogLevelInfo;
@interface PCChartController ()<UITableViewDataSource,UIScrollViewDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *chartV;
@property (nonatomic, weak) AAChartView *aaChartView;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *value;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chartVH;

@property (nonatomic, strong) NSArray *xs;
@property (nonatomic, strong) NSArray *ys;
@property (nonatomic, strong) NSArray *ms;
@property (nonatomic, strong) NSArray *ms2;
@property (nonatomic, strong) NSDictionary *xyt;

@property (nonatomic, weak) UIScrollView * monitorScrollView;
@property (weak, nonatomic) IBOutlet UIView *lineBak;

@property (weak, nonatomic) IBOutlet UILabel *moreL;
@property (nonatomic, weak) UITableView *popView;
@property (nonatomic, weak) UIView *popBoxView;

@property (nonatomic, strong) NSArray <NSString *>*popYs;
@property (nonatomic, strong) NSMutableDictionary *popXYs;
@property (nonatomic, assign) NSInteger row;
@property (weak, nonatomic) IBOutlet UILabel *kL;


@end

@implementation PCChartController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self initChartView];
    
    self.icon.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@1", self.item.icon]];
    self.name.text = self.item.name;
    
    self.kL.text = [NSString stringWithFormat:@"%@趋势", self.item.name];
    [self partCheckModel:PCPartCheckModelNormal];
}

-(void)partCheckModel:(PCPartCheckModel)model{
    NSNumber *value = @[@(self.item.up), @(self.item.value), @(self.item.down),@(self.item.normal)][model];
    //NSString *vstr = [NSString stringWithFormat:@"%.1fcm", roundf(value.floatValue*10)*0.1];
    //NSString *vstr = [NSString stringWithFormat:@"%.1fcm",((NSInteger)(value.floatValue*10+0.5)) * 0.1];
    NSString *vstr = [NSString stringWithFormat:@"%.1fcm",[YHTools roundNumberStringWithRound:1 number:value.floatValue]];

    

    NSMutableAttributedString *varrt = [[NSMutableAttributedString alloc] initWithString:vstr];
    [varrt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:[vstr rangeOfString:@"cm"]];
    
    self.value.attributedText = varrt;
}

- (void)setXyPt:(PCReportModel *)xyPt{
    //    xyPt.xaxisData = @[@"20190511",@"20190512",@"20190513",@"20190514",@"20190515",@"20190516",@"20190517",@"20190518",@"20190519"].mutableCopy;
    //    xyPt.yaxisData = @[@13.1,@13.2,@13.3,@13.1,@13.2,@13.3,@13.1,@13.2,@13.3].mutableCopy;
    //    xyPt.xaxisData = @[@"20190511"].mutableCopy;
    //    xyPt.yaxisData = @[@13.1].mutableCopy;
    
    //    xyPt.xaxisData = [[xyPt.xaxisData reverseObjectEnumerator] allObjects].mutableCopy;
    //    xyPt.yaxisData = [[xyPt.yaxisData reverseObjectEnumerator] allObjects].mutableCopy;
    
    
    [MBProgressHUD showMessage:nil toView:self.view];
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t serialQueue = dispatch_queue_create("com.tikeyc.tikeyc", DISPATCH_QUEUE_SERIAL);
    NSMutableArray *xaxisData = xyPt.xaxisData.mutableCopy;
    [xaxisData enumerateObjectsUsingBlock:^(NSString * _Nonnull x, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *date = [NSString stringWithFormat:@"%@-%@-%@",[x substringToIndex:4],[x substringWithRange:NSMakeRange(4, 2)],[x substringWithRange:NSMakeRange(6, 2)]];
        dispatch_group_enter(group);
        dispatch_group_async(group, serialQueue, ^{
            [[YHNetworkManager sharedYHNetworkManager] getReportDate:@{@"personId":self.personId,@"reportDate":date,@"bodyParts":self.item.bodyParts,@"accountId":self.accountId} onComplete:^(NSMutableArray<PCTestRecordModel *> * _Nonnull models) {
                [models enumerateObjectsUsingBlock:^(PCTestRecordModel * _Nonnull recordModel, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    
                    
                    [xyPt.xaxisData addObject:x];
                    [xyPt.yaxisData addObject:@(recordModel.measureResults.normal.value)];
                }];
                dispatch_group_leave(group);
                
            } onError:^(NSError * _Nonnull error) {
                
                dispatch_group_leave(group);
                
            }];
            
        });
    }];
    
    // 所有网络请求结束后会来到这个方法
    dispatch_group_notify(group, serialQueue, ^{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                // 刷新UI
                [MBProgressHUD hideHUDForView:self.view];
                
                _xyPt = xyPt;
                NSMutableDictionary *xyt = [NSMutableDictionary dictionary];
                NSMutableArray *xs = [NSMutableArray array];
                
                [xyPt.xaxisData enumerateObjectsUsingBlock:^(NSString * _Nonnull xobj, NSUInteger idx, BOOL * _Nonnull stop) {
                    xobj = [NSString stringWithFormat:@"%@.%@",[xobj substringWithRange:NSMakeRange(4, 2)],[xobj substringWithRange:NSMakeRange(6, 2)]];
                    NSMutableArray *v = [xyt valueForKey:xobj];
                    if (!v) {
                        v = [NSMutableArray array];
                        [xyt setValue:v forKey:xobj];
                        [xs addObject:xobj];
                    }
                    [v addObject:xyPt.yaxisData[idx]];
                    
                }];
                
                NSMutableArray *ys = [NSMutableArray array];
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                
                [xs enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    //CGFloat avg = [[xyt[obj] valueForKeyPath:@"@avg.self"] floatValue];
                    NSMutableArray *list = xyt[obj];
                    CGFloat avg = [[list firstObject] floatValue];
                    if(list.count>1) [list removeObjectAtIndex:0];
                    
                    //[ys addObject:@(roundf(avg*10)*0.1)];
                    [ys addObject:@(((NSInteger)(avg*10+0.5))*0.1)];
                    
                    
                }];
                
                NSMutableArray *ms = [NSMutableArray array];
                CGFloat maxValue = [[ys valueForKeyPath:@"@max.floatValue"] floatValue];
                CGFloat minValue = [[ys valueForKeyPath:@"@min.floatValue"] floatValue];
                minValue = minValue? 0:minValue;
                
                BOOL isMax = YES;
                if (xs.count < 9 && xs.count) {
                    NSNumber *obj  = @[@NO,@YES,@YES,@NO,@NO,@YES,@YES,@NO,@NO][xs.count-1];
                    isMax = [obj boolValue];
                    //isMax = (BOOL)((9 - (xs.count%2)? :(xs.count+1))%2);//3 max
                }
                
                [xs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    CGFloat y = [ys[idx] floatValue];
                    CGFloat ymax = maxValue+(maxValue-minValue)*0.2;
                    if (y<0) {
                        ymax = 0-maxValue-(maxValue-minValue)*0.2;
                    }
                    [ms addObject:(idx%2 != isMax)?@(0) : @(ymax)];
                }];
                
                
                NSMutableDictionary *tipS = [NSMutableDictionary dictionary];
                [xs enumerateObjectsUsingBlock:^(NSString *  xk, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSArray *ys = xyt[xk];
                    //NSString *v = [NSString stringWithFormat:@"%.1f cm",((NSInteger)([ys.firstObject floatValue]*10+0.5))*0.1];
                    NSString *v = [NSString stringWithFormat:@"%.1f cm",[YHTools roundNumberStringWithRound:1 number:[ys.firstObject floatValue]]];
                    
                    
                    
                    NSMutableArray *vs = [NSMutableArray array];
                    if(ys.count > 1) {
                        //NSMutableString *string = [NSMutableString string];
                        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                        formatter.numberStyle = kCFNumberFormatterRoundHalfDown;
                        
                        [ys enumerateObjectsUsingBlock:^(id  obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            
                            
                            NSString *cnNum = [formatter stringFromNumber:[NSNumber numberWithInt: idx+1]];
                            
                            //[vs addObject:[NSString stringWithFormat:@"测量%@: %.1f cm",cnNum,roundf([obj floatValue]*10)*0.1]];
                            [vs addObject:[NSString stringWithFormat:@"测量%@: %.1f cm",cnNum,((NSInteger)([obj floatValue]*10+0.5))*0.1]];
                            
                            
                            
                            //[string appendFormat:@"%@测量%ld: %.1f cm",idx? @"</span> <br/>":@"",idx+1,roundf([obj floatValue]*10)*0.1];
                        }];
                        //v = string;
                        
                    }else{
                        [vs addObject:v];
                    }
                    //[tipS setValue:v forKey:xk];
                    [tipS setValue:vs forKey:xk];
                    
                }];
                
                
                self.xs = xs;
                self.ys = ys;
                self.xyt = xyt;
                self.ms = ms;//@[@0,@53.4,@0,@53.4,@0,@53.4,@0,@53.4,@0];//ms;
                self.popXYs = tipS;
                
                
                NSMutableArray *ms2 = [ms mutableCopy];
                BOOL isless  = ms2.count < 9;
                if (ms2.count < 9 && ms2.count % 2 == 0) {
                    if ([ms2.lastObject floatValue] != 0 ) {
                        [ms2 addObject:@0];
                    }else{
                        [ms2 addObject:@(fabsf([ms.firstObject floatValue]))];
                    }
                }
                
                if (isless) {
                    
                CGFloat ms2MaxValue = maxValue+(maxValue-minValue)*0.2;
               

                
                //CGFloat ms2MaxValue = [[self.ms valueForKeyPath:@"@max.floatValue"] floatValue];
                BOOL isM = ([ms2.lastObject floatValue] != 0);
                NSUInteger count = (9 - ms2.count)/2;
                for (NSInteger i = 0; i < count; i ++) {
                    [ms2 insertObject:(i%2)? @(ms2MaxValue):@(0) atIndex:i];
                    [ms2 addObject:(i%2 != isM)? @(ms2MaxValue):@(0)];
                }
                [ms2 addObject:@0];

                ms2[4] = @0;
                
                NSMutableArray *ms3 = [NSMutableArray array];
                for (NSInteger i = 0 ; i < 9; i ++) {
                    [ms3 addObject:(i%2)? @(ms2MaxValue? : 22):@(0)];
                }
                [ms3 addObject:@0];

                self.ms2 = ms3;//@[@0,@53.4,@0,@53.4,@0,@53.4,@0,@53.4,@0,@0];
                }

                
                [self initChartView];
                
                
            });
        });
    });
    
    
    return;
    _xyPt = xyPt;
    NSMutableDictionary *xyt = [NSMutableDictionary dictionary];
    NSMutableArray *xs = [NSMutableArray array];
    
    [xyPt.xaxisData enumerateObjectsUsingBlock:^(NSString * _Nonnull xobj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *v = [xyt valueForKey:xobj];
        if (!v) {
            v = [NSMutableArray array];
            [xyt setValue:v forKey:xobj];
            [xs addObject:xobj];
        }
        [v addObject:xyPt.yaxisData[idx]];
        
    }];
    
    NSMutableArray *ys = [NSMutableArray array];
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    
    [xs enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat avg = [[xyt[obj] valueForKeyPath:@"@avg.self"] floatValue];
        NSNumber *avgNum = [f numberFromString:[NSString stringWithFormat:@"%.2f",avg]];
        [ys addObject:avgNum];
    }];
    
    NSMutableArray *ms = [NSMutableArray array];
    CGFloat maxValue = [[ys valueForKeyPath:@"@max.floatValue"] floatValue];
    
    [xs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [ms addObject:(idx%2==1)?@(0):@(maxValue+5)];
        //        [ms addObject:@[@(0),@(maxValue+5)]];
    }];
    
    self.xs = xs;
    self.ys = ys;
    self.xyt = xyt;
    self.ms = ms;
    
    
}



- (void)initChartView{
    self.chartVH.constant = screenHeight * 0.25+SafeAreaBottomHeight;
    CGRect cellFrameStart = self.chartV.frame;
    CGRect cellFrameEnd = self.chartV.frame;
    cellFrameStart.origin.y = screenHeight;
    self.chartV.frame = cellFrameStart;
    self.chartV.hidden = NO;
    self.chartV.alpha = 0.;
    WeakSelf
    [UIView animateWithDuration:0.4 animations:^{
        self.chartV.frame = cellFrameEnd;
        self.chartV.alpha = 1.;
    } completion:^(BOOL finisahed){
        weakSelf.kL.hidden = NO;
        weakSelf.moreL.hidden = NO;
        weakSelf.lineBak.hidden = NO;
    }];
    
    CGFloat contentSizeWidth = (self.xs.count > 9)? (self.xs.count * (screenWidth / 9.0)) : screenWidth;
    
    UIScrollView * monitorScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,screenWidth , self.chartVH.constant - SafeAreaBottomHeight)];
    //monitorScrollView.bounces = NO;
    monitorScrollView.delegate = self;
    monitorScrollView.showsHorizontalScrollIndicator = NO;
    monitorScrollView.contentSize = CGSizeMake(contentSizeWidth,0);
    [self.chartV insertSubview:monitorScrollView atIndex:0];
    _monitorScrollView = monitorScrollView;
    
    //[self.chartV setRounded:self.chartV.bounds corners:UIRectCornerTopLeft|UIRectCornerTopRight radius:30];
    AAChartView *aaChartView = [[AAChartView alloc]init];
    // + 10 为了在conunt 小于9时适配日期位置不够展示
    //CGFloat aaChartViewWidth = (self.xs.count >= 9)? (self.xs.count * (screenWidth / 9.0)) : (self.xs.count * (screenWidth / 9.0 + 10));
    CGFloat aaChartViewWidth = (self.xs.count >= 9)? (self.xs.count * (screenWidth / 9.0)) : (self.xs.count * (screenWidth / 9.0)+20);

    CGFloat w = (aaChartViewWidth > screenWidth)? screenWidth : aaChartViewWidth;
    CGFloat x = (screenWidth - w) * 0.5;
    
//    if(self.xs.count == 1) aaChartViewWidth += 15;
    aaChartView.frame = CGRectMake(x,0,aaChartViewWidth, self.chartVH.constant - SafeAreaBottomHeight);
    
    if ((self.xs.count < 9) && self.xs.count%2 == 0) {
        CGFloat x = 0.5 * (screenWidth - ((self.xs.count +1)* (screenWidth / 9.0)+20));
        aaChartView.frame = CGRectMake(x,0,aaChartViewWidth, self.chartVH.constant - SafeAreaBottomHeight);
    }
    //    aaChartView.frame = CGRectMake(0, 0,contentSizeWidth , self.chartVH.constant - SafeAreaBottomHeight);
    
    ////禁用 AAChartView 滚动效果(默认不禁用)
    aaChartView.scrollEnabled = NO;
    aaChartView.chartSeriesHidden = YES;
    ////设置图表视图的内容高度(默认 contentHeight 和 AAChartView 的高度相同)
    //aaChartView.contentWidth = chartViewWidth * 2;
    
    //    aaChartView.isClearBackgroundColor = YES;
    
    if (self.xs.count<9) {
        aaChartView.isClearBackgroundColor = YES;
        CGFloat squareW = self.xs.count? (aaChartViewWidth - 20)/self.xs.count :(screenWidth-20)/9.0;
        //        CGFloat satrtx =  (self.chartV.bounds.size.width - 9*squareW)*0.5;
        //        CGFloat satrty = 40;
        //        CGFloat squareH = (self.chartV.subviews.lastObject.frame.origin.y - satrty);
        //
        ////243, 241, 237
        //        for (NSInteger i = 0; i < 9; i++) {
        //            UIView *v = [[UIView alloc] init];
        //            v.frame = CGRectMake(satrtx + i * squareW, 40, squareW, i%2? squareH:0);
        //            v.backgroundColor = i%2 ? [UIColor colorWithRed:243/255.0 green:241/255.0 blue:237/255.0 alpha:1.0] : [UIColor clearColor];
        //            [monitorScrollView addSubview:v];
        //        }
        
        AAChartView *bbChartView = [[AAChartView alloc]init];
        bbChartView.frame = CGRectMake(-10,0,squareW * 10+20, self.chartVH.constant - SafeAreaBottomHeight);
        [monitorScrollView addSubview:bbChartView];
        [bbChartView aa_drawChartWithOptions:[self configureChartOptions2]];
        bbChartView.scrollEnabled = NO;

        
    }
    
    [monitorScrollView addSubview:aaChartView];
    self.aaChartView = aaChartView;

    if (aaChartViewWidth>screenWidth) {
        monitorScrollView.contentOffset = CGPointMake(aaChartViewWidth-screenWidth, 0);
    }
    
    
    //    AAChartModel *aaChartModel= AAObject(AAChartModel)
    //    .chartTypeSet(AAChartTypeLine)//设置图表的类型(这里以设置的为折线图为例)
    //    .titleSet(@"")//设置图表标题
    //    //.subtitleSet(@"虚拟数据")//设置图表副标题
    //    .categoriesSet(@[@"Java",@"Swift",@"Python",@"Ruby", @"PHP",@"Go",@"C",@"C#",@"C++"])//图表横轴的内容
    //    .yAxisTitleSet(@"")//设置图表 y 轴的单位
    //    .seriesSet(@[
    //                 AAObject(AASeriesElement)
    //                 .nameSet(@"多次测量显示当天平均值")
    //                 .dataSet(@[@7.1, @6.9, @9.5, @14.5, @18.2, @21.5, @25.2, @26.5, @23.3, @18.3, @13.9, @9.6])
    //                 ])
    //    ;
    /*图表视图对象调用图表模型对象,绘制最终图形*/
    //[_aaChartView aa_drawChartWithChartModel:[self configureGradientColorAreasplineChart]];
    
    
    [_aaChartView aa_drawChartWithOptions:[self configureChartOptions]];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.chartV setRounded:self.chartV.bounds corners:UIRectCornerTopLeft|UIRectCornerTopRight radius:30];
    });
    
    UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.aaChartView addGestureRecognizer:myTap];
    myTap.delegate = self;
    myTap.cancelsTouchesInView = NO;
    
    
    UITableView *popView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    popView.rowHeight = 22;
    [popView registerClass:[PCAAPopCell class] forCellReuseIdentifier:@"cell"];
    popView.dataSource = self;
    popView.contentInset = UIEdgeInsetsMake(8, 0, 8, 0);
    popView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 11.0, *)) {
        popView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    UIView *popBoxView = [[UIView alloc] init];
    popBoxView.hidden = YES;
    [popBoxView addSubview:popView];
    [popView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.top.right.mas_equalTo(popBoxView);
    }];
    [self.chartV addSubview:popBoxView];
    
    _popView = popView;
    _popBoxView = popBoxView;
    
    popView.layer.cornerRadius = 5;
    popView.layer.masksToBounds = YES;
    
    popBoxView.layer.borderWidth = 1.0;
    popBoxView.layer.borderColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00].CGColor;
    popBoxView.layer.cornerRadius = 5;
    popBoxView.layer.shadowColor= [UIColor blackColor].CGColor;
    popBoxView.layer.shadowOffset = CGSizeMake(2, 2);
    popBoxView.layer.shadowOpacity = 0.8;
    popBoxView.layer.shadowRadius = 5;
    popBoxView.layer.masksToBounds = NO;
    
}

- (AAOptions *)configureChartOptions2 {
    /*Custom Tooltip Style --- 自定义图表浮动提示框样式及内容*/
    AAOptions *aaOptions = [AAOptionsConstructor configureChartOptionsWithAAChartModel:[self configureGradientColorAreasplineChart2]];
    aaOptions.plotOptions.column.groupPadding = @0.0;//Padding between each column or bar, in x axis units. default：0.1.
    aaOptions.plotOptions.column.pointPadding = @0.0;//Padding between each value groups, in x axis units. default：0.2.
    AAXAxis *xAxis = aaOptions.xAxis;
    xAxis.tickColorSet(@"#FFFFFF")
    .lineColorSet(@"#FFFFFF")
//    .visibleSet(false)
    ;
    
    AATooltip *tooltip = aaOptions.tooltip;
    tooltip
    .useHTMLSet(true)
    .enabledSet(false)
    .formatterSet(@AAJSFunc(function () {
        
        return '';
        
        
    }))
    .valueDecimalsSet(@2)//设置取值精确到小数点后几位
    .backgroundColorSet(@"#FFFFFF")
    .borderColorSet(@"#FFFFFF")
    .styleSet((id)AAStyle.new
              .colorSet(@"#000000")
              .fontSizeSet(@"16px")
              )
    ;
    return aaOptions;
}




- (AAChartModel *)configureGradientColorAreasplineChart2 {
    NSDictionary *gradientColorDic1 =
    @{@"linearGradient": @{
              @"x1": @0.0,
              @"y1": @0.0,
              @"x2": @0.0,
              @"y2": @1.0
    },
      //      @"stops": @[@[@0.00, @"RGBA(220, 194, 161, 0.10)"],//深粉色, alpha 透明度 1
      //                  @[@1.00, @"RGBA(254, 254, 254, 0.10)"],//热情的粉红, alpha 透明度 0.1
      //                  ]//颜色字符串设置支持十六进制类型和 rgba 类型
      @"stops": @[@[@0.00, @"RGBA(211, 176, 129, 0.60)"],//深粉色, alpha 透明度 1 //#D3B081
                  @[@1.00, @"RGBA(254, 254, 254, 0.10)"],//热情的粉红, alpha 透明度 0.1
      ]//颜色字符串设置支持十六进制类型和 rgba 类型
    };
    
    
    //    NSDictionary *tipS = [NSMutableDictionary dictionary];
    //    [self.xs enumerateObjectsUsingBlock:^(NSString *  xk, NSUInteger idx, BOOL * _Nonnull stop) {
    //        NSArray *ys = self.xyt[xk];
    //        NSString *v = [NSString stringWithFormat:@"%.1f cm",[ys.firstObject floatValue]];
    //        if(ys.count > 1) {
    //            NSMutableString *string = [NSMutableString string];
    //            [ys enumerateObjectsUsingBlock:^(id  obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //
    //
    //                [string appendFormat:@"%@测量%ld: %.1f cm",idx? @"</span> <br/>":@"",idx+1,roundf([obj floatValue]*10)*0.1];
    //            }];
    //            v = string;
    //
    //        }
    //        [tipS setValue:v forKey:xk];
    //    }];
    //
    //    NSString *nameJs = [YHTools URLEncodedString: [tipS mj_JSONString]];
    
    
    return AAChartModel.new
    //    .chartTypeSet(AAChartTypeAreaspline)
    //    .chartTypeSet(AAChartTypeColumn)
    //    .touchEventEnabledSet(true)
    .xAxisGridLineWidthSet(@0.0)
    .titleSet(@"")
    .subtitleSet(@"")
    .categoriesSet(@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"1"])
    
    .yAxisTitleSet(@"")
    .yAxisVisibleSet(NO)
    //    .yAxisMaxSet(@([[self.ys valueForKeyPath:@"@max.floatValue"] floatValue] + 0))
    //    .yAxisMinSet(@([[self.ys valueForKeyPath:@"@min.floatValue"] floatValue] - 0))
    
    .markerRadiusSet(@5.0)//marker点半径为8个像素
    .markerSymbolStyleSet(AAChartSymbolStyleTypeInnerBlank)//marker点为空心效果
    .markerSymbolSet(AAChartSymbolTypeCircle)//marker点为圆形点○
    .yAxisLineWidthSet(@0)
    .yAxisGridLineWidthSet(@0)
    .legendEnabledSet(false)
    .easyGradientColorsSet(true)
    .xAxisCrosshairWidthSet(@1)// 准星线宽度为1
    .xAxisCrosshairColorSet(@"rgba(0,0,0,0)")//准星线背景色为透明色
    //    .dataLabelEnabledSet(true)
    //    .dataLabelFontColorSet(@"#A9A8AB")
    .seriesSet(@[
        
        
        AASeriesElement.new
        .typeSet(AAChartTypeColumn)
        .nameSet(nil)
        .colorSet(@"RGBA(243, 241, 237, 1.00)")//#F3F1ED
        .dataSet(self.ms2),
        
    ]
               
               );
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.popYs.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = self.popYs[indexPath.row];
    return cell;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.popBoxView.hidden = YES;
    self.popYs = nil;
    self.row = 0;
    [self.popView reloadData];
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender{
    //CGPoint gesturePoint = [sender locationInView:self.view];
    CGPoint gesturePoint = [sender locationInView:self.aaChartView];
    
    YHLog(@"handleSingleTap--- x:%f,y:%f",gesturePoint.x,gesturePoint.y);
    
    CGFloat xRallerWidth = _monitorScrollView.contentSize.width;
    NSInteger PostNum = self.xs.count;
    
    // 点击区域
    NSInteger row = 0;
    
    if( gesturePoint.y <= (screenHeight * 0.25 - 15) ){
        
        CGFloat postWidth = (xRallerWidth - 20)/PostNum;
        //postWidth = (( screenWidth - (self.aaChartView.frame.origin.x? 20:10) ) / 9.0);
        postWidth = (( self.aaChartView.bounds.size.width - 20 ) / PostNum);
        
        
        for (int i=0; i<PostNum; i++) {
            //if((gesturePoint.x + _monitorScrollView.contentOffset.x) >= (postWidth*i + 10) &&
            //(gesturePoint.x + _monitorScrollView.contentOffset.x) <= (postWidth*(i+1) + 0)){
            if((gesturePoint.x) >= (postWidth*i + 10) &&
               (gesturePoint.x) <= (postWidth*(i+1) + 10)){
                YHLog(@"🖱点击了第%d行柱", i+1);
                row = i+1;
                
                if (self.row) {
                    self.popBoxView.hidden = YES;
                    self.popYs = nil;
                    self.row = 0;
                    [self.popView reloadData];
                    return;
                }
                self.row = row;
                
                self.popYs = self.popXYs[self.xs[i]];
                NSInteger count = self.popYs.count;
                NSInteger lineCount = (self.popYs.count > 3)? 3 : self.popYs.count;
                CGFloat w = (count>1)? ((count>10)? 150:135) : 78 ;
                CGFloat h =  22 * lineCount+16;
                
                CGFloat x = gesturePoint.x;
                CGFloat y = 64;
                
                CGPoint orgin = [self.aaChartView convertPoint:CGPointMake(x, y) toView:self.chartV];
                x = orgin.x;
                
                x = ((x + w) > (self.view.bounds.size.width - 10))? (self.view.bounds.size.width - 10-w) : x;
                
                self.popBoxView.frame = CGRectMake(x, y, w,h);
                [self.popView layoutIfNeeded];
                self.popView.scrollEnabled = (self.popYs.count > 3);
                self.popBoxView.hidden = NO;
                [self.popView reloadData];
                [self.popView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                break;
            }
        }
    }
    
    if(!row) {
        self.popBoxView.hidden = YES;
        self.popYs = nil;
        self.row = 0;
        [self.popView reloadData];
    }
}

- (AAOptions *)configureChartOptions {
    /*Custom Tooltip Style --- 自定义图表浮动提示框样式及内容*/
    AAOptions *aaOptions = [AAOptionsConstructor configureChartOptionsWithAAChartModel:[self configureGradientColorAreasplineChart]];
    aaOptions.plotOptions.column.groupPadding = @0.0;//Padding between each column or bar, in x axis units. default：0.1.
    aaOptions.plotOptions.column.pointPadding = @0.0;//Padding between each value groups, in x axis units. default：0.2.
    AAXAxis *xAxis = aaOptions.xAxis;
    xAxis.tickColorSet(@"#FFFFFF")
    .lineColorSet(@"#FFFFFF")
    //    .visibleSet(false);
    ;
    
    AATooltip *tooltip = aaOptions.tooltip;
    tooltip
    .useHTMLSet(true)
    .enabledSet(false)
    .formatterSet(@AAJSFunc(function () {
        
        return '';
        var serieName = this.points[1].series.name;
        //console.log(serieName);
        var json = decodeURIComponent(serieName);
        //console.log(json);
        var obj = JSON.parse(json);
        return obj[this.x];
        
        let wholeContentString =' ';
        for (let i = 0;i < 2;i++) {
            let thisPoint = this.points[i];
            let isShow = this.points[3].y;
            
            if (isShow == 0) {
                return '<b>'
                +  this.y
                + ' </b>cm ';
            }
            
            let yValue = thisPoint.y;
            if (yValue != 0) {
                let spanStyleEndStr = '</span> <br/>';
                wholeContentString +=  thisPoint.series.name + ': ' + thisPoint.y + 'cm' + spanStyleEndStr;
            }
        }
        return wholeContentString;
        
        
    }))
    .valueDecimalsSet(@2)//设置取值精确到小数点后几位
    .backgroundColorSet(@"#FFFFFF")
    .borderColorSet(@"#FFFFFF")
    .styleSet((id)AAStyle.new
              .colorSet(@"#000000")
              .fontSizeSet(@"16px")
              )
    ;
    return aaOptions;
}




- (AAChartModel *)configureGradientColorAreasplineChart {
    NSDictionary *gradientColorDic1 =
    @{@"linearGradient": @{
              @"x1": @0.0,
              @"y1": @0.0,
              @"x2": @0.0,
              @"y2": @1.0
    },
      //      @"stops": @[@[@0.00, @"RGBA(220, 194, 161, 0.10)"],//深粉色, alpha 透明度 1
      //                  @[@1.00, @"RGBA(254, 254, 254, 0.10)"],//热情的粉红, alpha 透明度 0.1
      //                  ]//颜色字符串设置支持十六进制类型和 rgba 类型
      @"stops": @[@[@0.00, @"RGBA(211, 176, 129, 0.60)"],//深粉色, alpha 透明度 1 //#D3B081
                  @[@1.00, @"RGBA(254, 254, 254, 0.10)"],//热情的粉红, alpha 透明度 0.1
      ]//颜色字符串设置支持十六进制类型和 rgba 类型
    };
    
    
    NSString *sqColor = (self.xs.count <9)? @"RGBA(243, 241, 237, 0.00)":@"RGBA(243, 241, 237, 1.00)";
    
    //    NSDictionary *tipS = [NSMutableDictionary dictionary];
    //    [self.xs enumerateObjectsUsingBlock:^(NSString *  xk, NSUInteger idx, BOOL * _Nonnull stop) {
    //        NSArray *ys = self.xyt[xk];
    //        NSString *v = [NSString stringWithFormat:@"%.1f cm",[ys.firstObject floatValue]];
    //        if(ys.count > 1) {
    //            NSMutableString *string = [NSMutableString string];
    //            [ys enumerateObjectsUsingBlock:^(id  obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //
    //
    //                [string appendFormat:@"%@测量%ld: %.1f cm",idx? @"</span> <br/>":@"",idx+1,roundf([obj floatValue]*10)*0.1];
    //            }];
    //            v = string;
    //
    //        }
    //        [tipS setValue:v forKey:xk];
    //    }];
    //
    //    NSString *nameJs = [YHTools URLEncodedString: [tipS mj_JSONString]];
    
    
    return AAChartModel.new
    //    .chartTypeSet(AAChartTypeAreaspline)
    //    .chartTypeSet(AAChartTypeColumn)
    //    .touchEventEnabledSet(true)
    .xAxisGridLineWidthSet(@0.0)
    .titleSet(@"")
    .subtitleSet(@"")
    .categoriesSet(self.xs)
    
    .yAxisTitleSet(@"")
    .yAxisVisibleSet(NO)
    //    .yAxisMaxSet(@([[self.ys valueForKeyPath:@"@max.floatValue"] floatValue] + 0))
    //    .yAxisMinSet(@([[self.ys valueForKeyPath:@"@min.floatValue"] floatValue] - 0))
    
    .markerRadiusSet(@5.0)//marker点半径为8个像素
    .markerSymbolStyleSet(AAChartSymbolStyleTypeInnerBlank)//marker点为空心效果
    .markerSymbolSet(AAChartSymbolTypeCircle)//marker点为圆形点○
    .yAxisLineWidthSet(@0)
    .yAxisGridLineWidthSet(@0)
    .legendEnabledSet(false)
    .easyGradientColorsSet(true)
    .xAxisCrosshairWidthSet(@1)// 准星线宽度为1
    .xAxisCrosshairColorSet(@"rgba(0,0,0,0)")//准星线背景色为透明色
    //    .dataLabelEnabledSet(true)
    //    .dataLabelFontColorSet(@"#A9A8AB")
    .seriesSet(@[
        
        
        AASeriesElement.new
        .typeSet(AAChartTypeColumn)
        .nameSet(nil)
        .colorSet(sqColor)//#F3F1ED
        .dataSet(self.ms),
        
        AASeriesElement.new
        .typeSet(AAChartTypeAreaspline)
        //                 .nameSet(nameJs)
        .lineWidthSet(@3.0)
        .colorSet(@"RGBA(211, 167, 106, 1.00)")
        .fillColorSet((id)gradientColorDic1)
        .dataLabelsSet(AADataLabels.new
                       .enabledSet(true)
                       .styleSet(AAStyle.new
                                 //                                          .fontSizeSet(@"20px")
                                 //                                          .fontWeightSet(AAChartFontWeightTypeBold)
                                 .colorSet(@"#A9A8AB")
                                 //                                          .textOutlineSet(@"1px 1px contrast")
                                 )
                       .formatSet(@"{point.y:.1f}")
                       //                                .xSet(@3)
                       //                                .verticalAlignSet(AALegendVerticalAlignTypeMiddle)
                       )
        .dataSet(self.ys),
        
    ]
               
               );
}

- (IBAction)closeAction:(UIButton *)sender {
    !(_closeBlock)? : _closeBlock();
    [self removeFromParentViewController];
    [self.view removeFromSuperview];
    
    //    [self dismissViewControllerAnimated:NO completion:nil];
}
- (IBAction)showMusclature:(UIButton *)sender {
    
    NSString *bodyParts = self.item.bodyParts;
    
    if (!bodyParts) {
        
        return;
    }
    
    
    [MBProgressHUD showMessage:nil toView:self.view];
    [[YHNetworkManager sharedYHNetworkManager] getMusculature:@{@"bodyParts":bodyParts} onComplete:^(PCMusculatureModel *model) {
        [MBProgressHUD hideHUDForView:self.view];
        
        //    PCMusculatureModel *model = [PCMusculatureModel new];
        //    model.bodyPartName = @"左上臂";
        //    model.bodyPartDescribe = @"正常情况下在微信";
        //    model.bodyPartImage = @"https://upload-images.jianshu.io/upload_images/13346451-7def13415c3df82f.jpg";
        
        PCMusculatureController *vc = [[UIStoryboard storyboardWithName:@"profile" bundle:nil] instantiateViewControllerWithIdentifier:@"PCMusculatureController"];
        vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
        vc.model = model;
        [self presentViewController:vc animated:NO completion:nil];
        
        
    } onError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        
    }];
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
