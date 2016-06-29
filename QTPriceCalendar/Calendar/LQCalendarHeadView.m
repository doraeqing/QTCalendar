//
//  LQCalendarHeadView.m
//  AdvancedCalendar
//
//  Created by lq09984 on 15/12/30.
//  Copyright © 2015年 Ql. All rights reserved.
//

#import "LQCalendarHeadView.h"

@implementation LQCalendarHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}
- (void)setupView {
    self.clipsToBounds = YES;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.calendar = [NSCalendar currentCalendar];
    
    NSArray *weekDays = [dateFormatter veryShortStandaloneWeekdaySymbols];
    
    for (int i = 0; i < weekDays.count; i++) {
        UILabel *lableWeek = [[UILabel alloc] init];
        lableWeek.textAlignment = NSTextAlignmentCenter;
        lableWeek.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f];
        lableWeek.text = weekDays[i];
        CGFloat labelWeekWidth = (self.frame.size.width - 10 - 25) / 7;
        CGFloat labelX =  5 + labelWeekWidth * i + (i * 5);
        lableWeek.frame = CGRectMake(labelX,
                                     0,
                                     labelWeekWidth,
                                     self.frame.size.height - 1);
        [self addSubview:lableWeek];
    }
    UIImageView *bottomLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line_all"]];
    bottomLine.frame = CGRectMake(10, self.frame.size.height - 1, self.frame.size.width - 20, 1);
    [self addSubview:bottomLine];
}
@end
