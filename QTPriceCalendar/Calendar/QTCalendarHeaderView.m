//
//  QTCalendarHeaderView.m
//  QTPriceCalendar
//
//  Created by lq09984 on 16/5/25.
//  Copyright © 2016年 L.Q. All rights reserved.
//

#import "QTCalendarHeaderView.h"

@interface QTCalendarHeaderView ()
@property (nonatomic, weak) UILabel *labelYMD;
@end

@implementation QTCalendarHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.clipsToBounds = YES;
    
    UILabel *labelYMD = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 20)];
    labelYMD.textAlignment = NSTextAlignmentCenter;
    labelYMD.text = self.textHeader;
    [self addSubview:labelYMD];
    self.labelYMD = labelYMD;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.calendar = [NSCalendar currentCalendar];
    NSArray *weekDays = [dateFormatter veryShortStandaloneWeekdaySymbols];
    self.backgroundColor = [UIColor whiteColor];
    for (int i = 0; i < weekDays.count; i++) {
        UILabel *lableWeek = [[UILabel alloc] init];
        lableWeek.textAlignment = NSTextAlignmentCenter;
        lableWeek.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f];
        lableWeek.text = weekDays[i];
        CGFloat labelWeekWidth = (self.frame.size.width - 10 - 25) / 7;
        CGFloat labelX =  5 + labelWeekWidth * i + (i * 5);
        lableWeek.frame = CGRectMake(labelX,
                                     20,
                                     labelWeekWidth,
                                     self.frame.size.height - 20);
        [self addSubview:lableWeek];
    }
    UIImageView *bottomLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line_all"]];
    bottomLine.frame = CGRectMake(10, self.frame.size.height - 1, self.frame.size.width - 20, 1);
    [self addSubview:bottomLine];
}
- (void)setTextHeader:(NSString *)textHeader {
    _textHeader = textHeader;
    self.labelYMD.text = _textHeader;
}
@end
