//
//  QTCalendarCell.m
//  QTPriceCalendar
//
//  Created by lq09984 on 16/5/23.
//  Copyright © 2016年 L.Q. All rights reserved.
//

#import "QTCalendarCell.h"
#import "QTCalendarConst.h"

@interface QTCalendarCell ()

@end

@implementation QTCalendarCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}
- (void)commonInit {
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
    self.lblDay = [[UILabel alloc] init];
    self.lblDay.textAlignment = NSTextAlignmentCenter;
    self.lblDay.font = [UIFont fontWithName:@"Helvetica" size:15.0];
    self.lblDay.textColor = [UIColor blueColor];
    
    self.lblPrice = [[UILabel alloc] init];
    self.lblPrice.textAlignment = NSTextAlignmentCenter;
    self.lblPrice.font = [UIFont fontWithName:@"Helvetica" size:13.0];
    self.lblPrice.textColor = [UIColor orangeColor];
    
    self.lblTopLeft = [[UILabel alloc] init];
    self.lblTopLeft.textAlignment = NSTextAlignmentCenter;
    self.lblTopLeft.font = [UIFont fontWithName:@"Helvetica" size:9.0];
    self.lblTopLeft.textColor = [UIColor greenColor];
    
    [self addSubview:self.lblTopLeft];
    [self addSubview:self.lblPrice];
    [self addSubview:self.lblDay];
    
    
//    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
//    shapeLayer.backgroundColor = [UIColor clearColor].CGColor;
//    shapeLayer.hidden = YES;
//    [self.contentView.layer insertSublayer:shapeLayer below:self.lblDay.layer];
//    self.backgroundLayer = shapeLayer;
    
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.lblDay.center = CGPointMake(self.frame.size.width / 2,
                                     (self.frame.size.height / 2) - 5);
    self.lblDay.bounds = CGRectMake(0, 0, self.frame.size.width, 20);
    
    self.lblPrice.frame = CGRectMake(0, self.lblDay.frame.size.height + 5, self.frame.size.width, 20);
    self.lblTopLeft.frame = CGRectMake(0, 0, 20, 20);
}

- (void)performSelecting {
    
//    
//    _backgroundLayer.hidden = NO;
//    
//#define kAnimationDuration 0.15
//    
//    CAAnimationGroup *group = [CAAnimationGroup animation];
//    CABasicAnimation *zoomOut = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    zoomOut.fromValue = @0.3;
//    zoomOut.toValue = @1.2;
//    zoomOut.duration = kAnimationDuration/4*3;
//    CABasicAnimation *zoomIn = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    zoomIn.fromValue = @1.2;
//    zoomIn.toValue = @1.0;
//    zoomIn.beginTime = kAnimationDuration/4*3;
//    zoomIn.duration = kAnimationDuration/4;
//    group.duration = kAnimationDuration;
//    group.animations = @[zoomOut, zoomIn];
//    [_backgroundLayer addAnimation:group forKey:@"bounce"];
////    [self configureCell];
}

- (void)setCalendarItem:(id<QTCalendarItem>)calendarItem {
    if ([calendarItem isEnabled]) {//可以点击
        if ([calendarItem isSelect]) {//选中状态
            self.contentView.backgroundColor = QT_RGBA(46, 189, 89, 1);
        } else {
            self.contentView.backgroundColor = [UIColor whiteColor];
        }
        self.lblDay.textColor = [UIColor blueColor];
        self.lblPrice.textColor = [UIColor orangeColor];
    } else {
        self.lblDay.textColor = [UIColor grayColor];
        self.lblPrice.textColor = [UIColor grayColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    self.lblDay.text = self.day;
    self.lblTopLeft.text = calendarItem.topLeft;
    self.lblPrice.text = calendarItem.price;
    
    if (self.day.length > 0) {
        self.hidden = NO;
//        self.lblTopLeft.text = calendarItem.topLeft;
//        self.lblPrice.text = calendarItem.price;
    } else {
        self.hidden = YES;
//        self.lblPrice.text = @"";
//        self.lblTopLeft.text = @"";
    }
}

- (void)resetShow {
    
}
@end
