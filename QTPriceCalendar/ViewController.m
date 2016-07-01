//
//  ViewController.m
//  QTPriceCalendar
//
//  Created by lq09984 on 16/6/29.
//  Copyright © 2016年 L.Q. All rights reserved.
//

#import "ViewController.h"
#import "QTCalendarView.h"

@interface ViewController ()<QTCalendarViewDelegate,QTCalendarViewDataSource>

@property (nonatomic, strong) NSMutableDictionary *dic;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    QTCalendarView *view = [[QTCalendarView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, 320) direction:QTCalendarViewDirectionHorizontal];
    view.delegate = self;
    view.dataSource = self;
    [self.view addSubview:view];
    
    _dic = [NSMutableDictionary dictionary];
    NSString *strDate = @"2015-12-05";
    QTCalendarItem *item = [[QTCalendarItem alloc] init];
    item.topLeft = @"班";
    item.topRight = @"休";
    item.price = @"￥1500";
    item.isSelect = NO;
    item.isEnabled = YES;
    [_dic setValue:item forKey:strDate];
    
    NSString *strDate2 = @"2015-12-08";
    QTCalendarItem *item2 = [[QTCalendarItem alloc] init];
    item2.topLeft = @"班";
    item2.topRight = @"休";
    item2.price = @"￥1500";
    item2.isSelect = NO;
    item2.isEnabled = YES;
    [_dic setValue:item2 forKey:strDate2];
    
    NSString *strDate1 = @"2016-05-01";
    QTCalendarItem *item1 = [[QTCalendarItem alloc] init];
    item1.topLeft = @"班";
    item1.topRight = @"休";
    item1.price = @"￥1500";
    item1.isSelect = NO;
    item1.isEnabled = YES;
    [_dic setValue:item1 forKey:strDate1];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSDate *)beginDateInCalendarView:(QTCalendarView *)calendarView {
    NSString *strDate = @"2015-12-05";
    NSDateFormatter *fmt = [NSDateFormatter new];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    return [fmt dateFromString:strDate];
}

- (NSDate *)endDateInCalendarView:(QTCalendarView *)calendarView {
    NSString *strDate = @"2016-09-05";
    NSDateFormatter *fmt = [NSDateFormatter new];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    return [fmt dateFromString:strDate];
}

- (id<QTCalendarItem>)calendarView:(QTCalendarView *)calendarView itemForCalendarInDate:(NSString *)sDate {
    return _dic[sDate];
}

- (void)calendarView:(QTCalendarView *)calendarView previousSelectDate:(NSDate *)preDate currentSelectDate:(NSDate *)currentDate {
    NSDateFormatter *fmt = [NSDateFormatter new];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *sdate = [fmt stringFromDate:currentDate];
    NSString *sPreDate = [fmt stringFromDate:preDate];
    
    QTCalendarItem *itemCurrent = _dic[sdate];
    itemCurrent.isSelect = YES;
    
    QTCalendarItem *itemPre = _dic[sPreDate];
    itemPre.isSelect = NO;
}

- (void)calendarView:(QTCalendarView *)calendarView didSelectDate:(NSDate *)selectDate {
    

    
}

- (void)calendarViewDidEndDecelerating:(QTCalendarView *)calendarView {
    
}

- (void)calendarViewDidScroll:(QTCalendarView *)calendarView {
    
}

@end
