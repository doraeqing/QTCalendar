//
//  QTCalendarView.h
//  QTPriceCalendar
//
//  Created by lq09984 on 16/5/23.
//  Copyright © 2016年 L.Q. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QTCalendarItem.h"

typedef NS_ENUM(NSInteger, QTCalendarViewDirection) {
    QTCalendarViewDirectionHorizontal,//水平方向滚动 默认
    QTCalendarViewDirectionVertical,//垂直方向滚动
};

@protocol QTCalendarViewDelegate,QTCalendarViewDataSource;

@interface QTCalendarView : UIView

- (instancetype)initWithFrame:(CGRect)frame direction:(QTCalendarViewDirection)direction;

@property (nonatomic, assign) QTCalendarViewDirection direction;
@property (nonatomic, weak) id <QTCalendarViewDelegate> delegate;
@property (nonatomic, weak) id <QTCalendarViewDataSource> dataSource;

- (CGFloat)calendarViewHeight;
- (void)reloadCalendarViewData;
- (void)scrollToRowAtDate:(NSDate *)date;

@end
#pragma mark - QTCalendarViewDelegate
@protocol QTCalendarViewDelegate <NSObject>

@optional
- (void)calendarViewDidScroll:(QTCalendarView *)calendarView;
- (void)calendarViewDidEndDecelerating:(QTCalendarView *)calendarView;

- (void)calendarView:(QTCalendarView *)calendarView didSelectDate:(NSDate *)selectDate;
- (void)calendarView:(QTCalendarView *)calendarView previousSelectDate:(NSDate *)preDate currentSelectDate:(NSDate *)currentDate;
@end

#pragma mark - QTCalendarViewDataSource
//_______________________________________________________________________________________________________________
@protocol QTCalendarViewDataSource <NSObject>

@optional
- (NSDate *)beginDateInCalendarView:(QTCalendarView *)calendarView;
- (NSDate *)endDateInCalendarView:(QTCalendarView *)calendarView;

- (id<QTCalendarItem>)calendarView:(QTCalendarView *)calendarView itemForCalendarInRow:(NSInteger)row;

- (id<QTCalendarItem>)calendarView:(QTCalendarView *)calendarView itemForCalendarInDate:(NSString *)sDate;

- (UIView *)calnedarView:(QTCalendarView *)calendarView elementViewForContentAtRow:(NSInteger)row;

@end
