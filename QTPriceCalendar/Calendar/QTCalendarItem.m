//
//  QTCalendarItem.m
//  QTPriceCalendar
//
//  Created by lq09984 on 16/5/23.
//  Copyright © 2016年 L.Q. All rights reserved.
//

#import "QTCalendarItem.h"

@implementation QTCalendarItem
@synthesize isSelect = _isSelect;
@synthesize price = _price;
@synthesize topRight = _topRight;
@synthesize topLeft = _topLeft;
@synthesize relateDate = _relateDate;
@synthesize isEnabled = _isEnabled;
@synthesize day = _day;

- (instancetype)initWithDate:(NSString *)date {
    if (self = [super init]) {
    }
    return self;
}

@end
