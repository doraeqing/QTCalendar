//
//  QTCalendarItem.h
//  QTPriceCalendar
//
//  Created by lq09984 on 16/5/23.
//  Copyright © 2016年 L.Q. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol QTCalendarItem <NSObject>

@property (nonatomic, copy) NSString *topLeft;
@property (nonatomic, copy) NSString *topRight;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *day;
@property (nonatomic, strong) NSDate *relateDate;
//可使用的
@property (nonatomic, assign) BOOL isEnabled;
@property (nonatomic, assign) BOOL isSelect;

@end

@interface QTCalendarItem : NSObject<QTCalendarItem>

- (instancetype)initWithDate:(NSString *)date;

@end
