//
//  QTCalendarCollectionCell.m
//  QTPriceCalendar
//
//  Created by lq09984 on 16/5/24.
//  Copyright © 2016年 L.Q. All rights reserved.
//

#import "QTCalendarCollectionCell.h"

@implementation QTCalendarCollectionCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
        
        self.lblDay = [[UILabel alloc] init];
        self.lblDay.textAlignment = NSTextAlignmentCenter;
        self.lblDay.font = [UIFont fontWithName:@"Helvetica" size:15.0];
        
        self.lblPrice = [[UILabel alloc] init];
        self.lblPrice.textAlignment = NSTextAlignmentCenter;
        self.lblPrice.font = [UIFont fontWithName:@"Helvetica" size:13.0];
        self.lblPrice.textColor = [UIColor orangeColor];
        
        self.lblHolidy = [[UILabel alloc] init];
        self.lblHolidy.textAlignment = NSTextAlignmentCenter;
        self.lblHolidy.font = [UIFont fontWithName:@"Helvetica" size:9.0];
        self.lblHolidy.textColor = [UIColor greenColor];
        
        [self addSubview:self.lblHolidy];
        [self addSubview:self.lblPrice];
        [self addSubview:self.lblDay];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.lblDay.center = CGPointMake(self.frame.size.width / 2,
                                     (self.frame.size.height / 2) - 5);
    self.lblDay.bounds = CGRectMake(0, 0, self.frame.size.width, 20);
    
    self.lblPrice.frame = CGRectMake(0, self.lblDay.frame.size.height + 5, self.frame.size.width, 20);
    self.lblHolidy.frame = CGRectMake(0, 0, 20, 20);
}



//- (void)setCalendarModel:(LQCalendarModel *)calendarModel {
//    
//    if (_calendarModel != calendarModel) {
//        _calendarModel = calendarModel;
//    }
//    self.lblDay.text = calendarModel.day;
//    self.lblPrice.text = calendarModel.price;
//    if (calendarModel.isEnable) {
//        
//        self.lblPrice.textColor = [UIColor orangeColor];
//        self.lblDay.textColor = [UIColor blackColor];
//    }else {
//        self.lblPrice.textColor = [UIColor darkGrayColor];
//        self.lblDay.textColor = [UIColor darkGrayColor];
//    }
//    if (calendarModel.holidayType.length > 0) {
//        switch ([calendarModel.holidayType integerValue])
//        {
//            case 0:
//                self.lblHolidy.text = @"休";
//                break;
//            case 1:
//                self.lblHolidy.text = @"休";
//                break;
//            case 2:
//                self.lblHolidy.text = @"班";
//                break;
//            case 3:
//                self.lblHolidy.text = @"";
//            default:
//                self.lblHolidy.text = @"";
//                break;
//        }
//    }
//    if (calendarModel.holidayName.length > 0) {
//        if ([calendarModel.holidayType integerValue] == 0 || [calendarModel.holidayType integerValue] == 3) {
//            self.lblDay.text = calendarModel.holidayName;
//            self.lblDay.font = [UIFont systemFontOfSize:12];
//        }
//    }
//}

@end
