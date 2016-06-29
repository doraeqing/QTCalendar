//
//  QTCalendarCell.h
//  QTPriceCalendar
//
//  Created by lq09984 on 16/5/23.
//  Copyright © 2016年 L.Q. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QTCalendarItem.h"

@interface QTCalendarCell : UICollectionViewCell

@property (nonatomic, strong) id <QTCalendarItem> calendarItem;

@property (nonatomic, copy) NSString *day;
@property (nonatomic, strong) UILabel *lblDay;
@property (nonatomic, strong) UILabel *lblPrice;
@property (nonatomic, strong) UILabel *lblTopLeft;

- (void)performSelecting;

@end
