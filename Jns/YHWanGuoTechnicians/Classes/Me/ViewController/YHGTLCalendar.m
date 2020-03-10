//
//  YHGTLCalendar.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/12/15.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHGTLCalendar.h"
#import "YHCommon.h"
#import "GTLCalendarView.h"

NSString *const notificationConditionDate = @"YHNotificationConditionDate";
@interface YHGTLCalendar () <GTLCalendarViewDataSource, GTLCalendarViewDelegate>
@property (strong, nonatomic)NSString *fromDate;
@property (strong, nonatomic)NSString *toDate;
@property (weak, nonatomic) IBOutlet UIButton *rightB;
@end

@implementation YHGTLCalendar

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_isOnly) {
        self.title = @"选择日期 ";
        _rightB.hidden = YES;
    }
    [self setupGTLCalendarViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)comfireAction:(id)sender {
    if (!_fromDate || !_toDate) {
        [MBProgressHUD showError:@"请选择起始结束时间！"];
        return;
    }
    [[NSNotificationCenter
      defaultCenter]postNotificationName:notificationConditionDate
     object:Nil
     userInfo:@{@"fromDate" : _fromDate,
                @"toDate" : _toDate}];
    [self popViewController:nil];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


#pragma mark - GTLCalendarViewDataSource

- (NSDate *)minimumDateForGTLCalendar {
    if (_isOnly) {
        return [NSDate date];
    }else{
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        return [dateFormatter dateFromString:@"2015-05-01"];
    }
}

- (NSDate *)maximumDateForGTLCalendar {
    if (_isOnly) {
        return  [self getPriousorLaterDateFromDate:[NSDate date] withMonth:12];
    }else{
        return  [self getPriousorLaterDateFromDate:[NSDate date] withMonth:-1];
    }
}

- (NSDate *)defaultSelectFromDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    return [dateFormatter dateFromString:@"2017-05-10"];
}

- (NSDate *)defaultSelectToDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    return [dateFormatter dateFromString:@"2017-05-26"];
}

#pragma mark - GTLCalendarViewDelegate

- (NSInteger)rangeDaysForGTLCalendar {
    return 30 * 3;
}

- (void)selectNSStringFromDate:(NSString *)fromDate toDate:(NSString *)toDate {
    YHLog(@"fromDate: %@, toDate: %@", fromDate, toDate);
    if (_isOnly) {
        [[NSNotificationCenter
          defaultCenter]postNotificationName:notificationConditionDate
         object:Nil
         userInfo:@{@"fromDate" : fromDate,
                    @"toDate" : toDate}];
        [self popViewController:nil];
    }else{
    self.fromDate = fromDate;
    self.toDate = toDate;
    }
}


-(NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withMonth:(int)month

{
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    [comps setMonth:month];
    
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    
    return mDate;
    
}

#pragma mark - private instance method

#pragma mark * init values

- (void)setupGTLCalendarViews {
    CGRect frame = CGRectMake(0, 0, screenWidth, screenHeight);
    
    GTLCalendarView *gtlCalendarView = [[GTLCalendarView alloc] initWithFrame:frame];
    gtlCalendarView.dataSource = self;
    gtlCalendarView.delegate = self;
    [self.view addSubview:gtlCalendarView];
}

@end
