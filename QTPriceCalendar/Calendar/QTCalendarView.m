//
//  QTCalendarView.m
//  QTPriceCalendar
//
//  Created by lq09984 on 16/5/23.
//  Copyright © 2016年 L.Q. All rights reserved.
//

#import "QTCalendarView.h"
#import "QTCalendarCell.h"
#import "LQCalendarHeadView.h"
#import "QTCalendarHeaderView.h"
#import "QTCalendarViewLayout.h"

const NSInteger kCalendarUnit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday;
static const NSInteger kDaysPerWeek = 7;

#define TCTSiftViewTabBackgroundColor TCT_RGBA(11,60,57,0.95)
#define TCT_RGBA(r,g,b,a)	[UIColor colorWithRed:(float)(r/255.0f) green:(float)(g/255.0f) blue:(float)(b/255.0f) alpha:a]

@interface QTCalendarView ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>
{
    struct {
        unsigned beginDateInCalendarView : 1;
        unsigned endDateInCalendarView : 1;
        unsigned itemForCalendarInRow : 1;
    }_dataSourceHas;
    
    struct {
        unsigned calendarViewDidScroll : 1;
        unsigned calendarViewDidEndScroll : 1;
        unsigned didSelectDate : 1;
    }_delegateHas;
}

@property (nonatomic, assign) QTCalendarViewDirection directionCalendar;
@property (nonatomic, weak) UICollectionView *calendarContainer;
@property (nonatomic, weak) UICollectionView *calendarElementsView;
@property (nonatomic, weak) QTCalendarHeaderView *headerView;///水平滚动时的headerView
//______________ date___________
@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) NSDateFormatter *fmtDay;
@property (nonatomic, strong) NSDateFormatter *fmtYMD;

@property (nonatomic, strong) NSDate *selectDate;
@property (nonatomic, strong) NSDate *beginDate;
@property (nonatomic, strong) NSDate *endDate;

@property (nonatomic, assign) NSIndexPath *lastIndexPath; //上一次点击的indexPath
@property (nonatomic, strong) NSMapTable *allItemMap;

@property (nonatomic, strong) NSMutableDictionary *allItems;

@end

@implementation QTCalendarView

- (instancetype)initWithFrame:(CGRect)frame direction:(QTCalendarViewDirection)direction {
    if (self = [super initWithFrame:frame]) {
//        _direction = direction;
        _directionCalendar = _direction = direction;
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [self initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    NSLog(@"%@",self.calendarContainer);
    [self qt_invalidateLayout];
}

#pragma mark - DateFunction
///根据date 返回一个新的天数为Date第一天的新date 如2016-06-01
- (NSDate *)dateFirstDayFromDate:(NSDate *)date {
    NSDateComponents *currentComponet = [self.calendar components:kCalendarUnit fromDate:date];
    currentComponet.day = 1;
    NSDate *firstDayDate = [self.calendar dateFromComponents:currentComponet];
    return firstDayDate;
}

///根据section 返回一个每个月第一天的date
- (NSDate *)dateFirstDayWithSection:(NSInteger)section {
    NSDateComponents *cmps = [NSDateComponents new];
    cmps.month = section;
    NSDate *newDate = [self.calendar dateByAddingComponents:cmps
                                                     toDate:self.beginDate
                                                    options:0];
    return [self dateFirstDayFromDate:newDate];
}

///根据section 返回当前section对应的date的天数
- (NSUInteger)numOfDaysInSection:(NSInteger)section {
    NSDate *date = [self dateFirstDayWithSection:section];
    return [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
}

//获得这个月的第一天为星期几
- (NSUInteger)firstWeekDayInSection:(NSInteger)section {
    [self.calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDate *firstDayOfMonthDate = [self dateFirstDayWithSection:section];
    
    NSUInteger firstWeekday = [self.calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;
}

- (NSDate *)dateByAddingDays:(NSInteger)days toDate:(NSDate *)date {
    NSDateComponents *components = [NSDateComponents new];
    components.day = days;
    NSDate *d = [self.calendar dateByAddingComponents:components toDate:date options:0];
    components.day = NSIntegerMax;
    return d;
}

- (NSDate *)dateNextDayFromIndexPath:(NSIndexPath *)indexPath dateFirstDay:(NSDate *)nextFirstDayDate {
    //每个月第一天 2016/5/01
    NSUInteger weekDay1 = [self.calendar component:NSCalendarUnitWeekday
                                          fromDate:nextFirstDayDate];
    NSInteger startOffset = weekDay1 - self.calendar.firstWeekday;
    startOffset += startOffset >= 0 ? 0 : kDaysPerWeek;
    
    NSDateComponents *dateComponents = [NSDateComponents new];
    dateComponents.day = indexPath.item - startOffset;
    NSDate *nextDate = [self.calendar dateByAddingComponents:dateComponents toDate:nextFirstDayDate options:0];
    return nextDate;
}

- (NSCalendarUnit)weekCalendarUnitDependingOniOSVersion {
    //isDateInToday is a new (awesome) method available on iOS8 only.
    if ([self.calendar respondsToSelector:@selector(isDateInToday:)]) {
        return NSCalendarUnitWeekOfMonth;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        return NSWeekCalendarUnit;
#pragma clang diagnostic pop
    }
}

- (NSString *)dayStatusFromDate:(NSDate *)date {
    
    NSDateComponents *cmps_offset = [NSDateComponents new];
    cmps_offset.day = 1;
    NSDateComponents *cmps_today = [self.calendar components:kCalendarUnit
                                                    fromDate:[NSDate date]];
    NSDate *today = [self.calendar dateFromComponents:cmps_today];
    NSDate *tomorrow = [self.calendar dateByAddingComponents:cmps_offset
                                                      toDate:today
                                                     options:0];
    NSDate *dayAfterTomorrow = [self.calendar dateByAddingComponents:cmps_offset
                                                      toDate:tomorrow
                                                     options:0];
    
    if ([date isEqualToDate:today]) {
        return @"今天";
    } else if ([date isEqualToDate:tomorrow]) {
        return @"明天";
    } else if ([date isEqualToDate:dayAfterTomorrow]) {
        return @"后天";
    } else {
        return nil;
    }
}

- (NSString *)dayFromeDate:(NSDate *)date {
    
    if (![self.fmtDay.calendar isEqual:self.calendar]) {
        self.fmtDay.calendar = self.calendar;
    }
    return [self.fmtDay stringFromDate:date];
}

- (NSString *)textDayWithIndexPath:(NSIndexPath *)indexPath {
    
    NSCalendarUnit weekCalendarUnit = [self weekCalendarUnitDependingOniOSVersion];
    NSRange rangeOfWeeks = [self.calendar rangeOfUnit:weekCalendarUnit
                                               inUnit:NSCalendarUnitMonth
                                              forDate:self.beginDate];
    NSInteger weeks = rangeOfWeeks.length;
    //每个月第一天 2016/5/01
    NSDate *nextFirstDayDate = [self dateFirstDayWithSection:indexPath.section];
    NSDate *nextDayDate = [self dateNextDayFromIndexPath:indexPath
                                            dateFirstDay:nextFirstDayDate];
    NSDateComponents *cmpsBegin = [self.calendar components:kCalendarUnit
                                                   fromDate:nextFirstDayDate];
    NSDateComponents *cmpsNext = [self.calendar components:kCalendarUnit
                                                  fromDate:nextDayDate];
    NSString *day = @"";
    if (cmpsBegin.month == cmpsNext.month) {
        day = [self dayFromeDate:nextDayDate];
        if ([self dayStatusFromDate:nextDayDate].length > 0) {
            day = [self dayStatusFromDate:nextDayDate];
        }
    }
    return day;
}

#pragma makr - Private methods
- (void)qt_invalidateLayout {
    
    if (self.direction == QTCalendarViewDirectionHorizontal) {
        if (!_headerView) {
            QTCalendarHeaderView *headerView = [[QTCalendarHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 55)];
            headerView.textHeader = @"2016-05-25";
            [self addSubview:_headerView = headerView];
        }
    }
}

#pragma mark - Public
- (CGFloat)calendarViewHeight {
    return self.calendarContainer.contentSize.height;
}

- (void)reloadCalendarViewData {
    [_calendarContainer reloadData];
}

#pragma mark - Private CollectionView
- (NSInteger)sectionsInCalednarView {
    NSInteger section = 0;
    if (_dataSourceHas.beginDateInCalendarView && _dataSourceHas.endDateInCalendarView) {
        self.beginDate = [self dateFirstDayFromDate:[self.dataSource beginDateInCalendarView:self]];
        self.endDate = [self dateFirstDayFromDate:[self.dataSource endDateInCalendarView:self]];
        section = [self.calendar components:NSCalendarUnitMonth
                                   fromDate:self.beginDate
                                     toDate:self.endDate
                                    options:0].month + 1;
        return section;
    }
    return section;
}
- (void)updateConstraints {
    
}

static NSString * const calendarCellIdentifier = @"QTCalendarCell";
- (UICollectionViewCell *)cellForCalendarAtIndexPath:(NSIndexPath *)indexPath {
    
    QTCalendarCell *cell = [self.calendarContainer dequeueReusableCellWithReuseIdentifier:calendarCellIdentifier
                                                                             forIndexPath:indexPath];
//    cell.layer.shouldRasterize = YES;
//    cell.layer.contentsScale = [UIScreen mainScreen].scale;
    
    NSDate *nextFirstDayDate = [self dateFirstDayWithSection:indexPath.section];
    NSDate *nextDayDate = [self dateNextDayFromIndexPath:indexPath
                                            dateFirstDay:nextFirstDayDate];
    NSString *sDate = [self.fmtYMD stringFromDate:nextDayDate];
    id <QTCalendarItem> item = nil;
    if (_dataSourceHas.itemForCalendarInRow) {
        item = [self.dataSource calendarView:self itemForCalendarInDate:sDate];
        [self.allItems removeAllObjects];
        [self.allItems setObject:item forKey:sDate];
        
        [self.allItemMap removeAllObjects];
        [self.allItemMap setObject:item forKey:sDate];
    }
    cell.day = [self textDayWithIndexPath:indexPath];
    cell.calendarItem = item;
    return cell;
}
#pragma mark - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

//滚动结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (!_delegateHas.calendarViewDidEndScroll) return;
    [self.delegate calendarViewDidEndDecelerating:self];
}

#pragma mark - UICollectionViewDatasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self sectionsInCalednarView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_direction == QTCalendarViewDirectionVertical) {
        return 42;
    } else {
        //当前月的总天数 + 当前月的第一天所在的周几
        return [self numOfDaysInSection:section] + [self firstWeekDayInSection:section];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return [self cellForCalendarAtIndexPath:indexPath];
}

static NSString *kCalendarHeadViewIdentifier = @"LQCalendarHeadView";
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        LQCalendarHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCalendarHeadViewIdentifier forIndexPath:indexPath];
        headerView.backgroundColor = [UIColor grayColor];
        return headerView;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate
static inline NSIndexPath *LQ_indexPathFromIndex(NSInteger index){
    return [NSIndexPath indexPathForRow:index inSection:0];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.lastIndexPath) self.lastIndexPath = indexPath;
    
    if (!_delegateHas.didSelectDate) return;
    
    NSDate *preFirstDayDate = [self dateFirstDayWithSection:self.lastIndexPath.section];
    NSDate *preDayDate = [self dateNextDayFromIndexPath:self.lastIndexPath
                                           dateFirstDay:preFirstDayDate];
    
    NSDate *nextFirstDayDate = [self dateFirstDayWithSection:indexPath.section];
    NSDate *nextDayDate = [self dateNextDayFromIndexPath:indexPath
                                            dateFirstDay:nextFirstDayDate];
    
    self.selectDate = nextDayDate;
    [self.delegate calendarView:self previousSelectDate:preDayDate currentSelectDate:nextDayDate];
    self.lastIndexPath = indexPath;
    [collectionView reloadData];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - UICollectionViewDelegateFlowLayout
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
//    CGFloat width = screenWidth / 7;
//    return CGSizeMake(width, 55);
//}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (self.direction == QTCalendarViewDirectionHorizontal) {
        return CGSizeZero;
    }
    return CGSizeMake(55, 55);
}

#pragma mark - Accessor
- (UICollectionView *)calendarContainer {
    if (!_calendarContainer) {
        
        UICollectionView *calendarContainer = nil;
        CGRect rect = CGRectMake(0, 55, self.frame.size.width, self.frame.size.height);
        if (_directionCalendar == QTCalendarViewDirectionHorizontal) { //水平方向
            
            QTCalendarViewLayout *flowLayout = [[QTCalendarViewLayout alloc] init];
            flowLayout.minimumInteritemSpacing = 0;
            flowLayout.minimumInteritemSpacing = 0;
            flowLayout.sectionInset = UIEdgeInsetsMake(5, 3, 5, 3);
            flowLayout.itemSize = CGSizeMake((rect.size.width - flowLayout.minimumInteritemSpacing * (7-1) - 6) / 7, 50);
            flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            calendarContainer = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:flowLayout];
            calendarContainer.pagingEnabled = YES;
        } else {
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            layout.scrollDirection = UICollectionViewScrollDirectionVertical;
            calendarContainer = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
            calendarContainer.pagingEnabled = NO;
        }
//        calendarContainer.allowsMultipleSelection = NO;
//        calendarContainer.allowsSelection = NO;
        
        calendarContainer.backgroundColor = calendarContainer.superview.backgroundColor;
        [calendarContainer registerClass:[QTCalendarCell class] forCellWithReuseIdentifier:calendarCellIdentifier];
        [calendarContainer registerClass:[LQCalendarHeadView class]
               forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCalendarHeadViewIdentifier];
        calendarContainer.delegate = self;
        calendarContainer.dataSource = self;
        [self addSubview:_calendarContainer=calendarContainer];
    }
    return _calendarContainer;
}

- (UICollectionView *)calendarElementsView {
    if (!_calendarElementsView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0.0;
        layout.minimumLineSpacing = 0.0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        UICollectionView *cvTemp = [[UICollectionView alloc] initWithFrame:self.calendarContainer.bounds
                                             collectionViewLayout:layout];
        cvTemp.backgroundColor = [UIColor whiteColor];
        cvTemp.dataSource = self;
        cvTemp.delegate = self;
        
        [self addSubview:_calendarElementsView = cvTemp];
    }
    return _calendarElementsView;
}

- (NSCalendar *)calendar {
    if (!_calendar) {
        _calendar = [NSCalendar currentCalendar];
    }
    return _calendar;
}

- (NSDateFormatter *)fmtYMD {
    if (!_fmtYMD) {
        _fmtYMD = [[NSDateFormatter alloc] init];
        _fmtYMD.dateFormat = @"yyyy-MM-dd";
    }
    return _fmtYMD;
}

- (NSDateFormatter *)fmtDay {
    if (!_fmtDay) {
        _fmtDay = [[NSDateFormatter alloc] init];
        _fmtDay.dateFormat = @"d";
    }
    return _fmtDay;
}
- (NSMapTable *)allItemMap {
    if (!_allItemMap) {
        _allItemMap = [NSMapTable weakToWeakObjectsMapTable];
    }
    return _allItemMap;
}

- (void)setDirection:(QTCalendarViewDirection)direction {
    _direction = direction;
    _directionCalendar = direction;
    [self.calendarContainer reloadData];
}

- (void)setDataSource:(id<QTCalendarViewDataSource>)dataSource {
    _dataSource = dataSource;
    _dataSourceHas.beginDateInCalendarView = [_dataSource respondsToSelector:@selector(beginDateInCalendarView:)];
    _dataSourceHas.endDateInCalendarView = [_dataSource respondsToSelector:@selector(endDateInCalendarView:)];
    _dataSourceHas.itemForCalendarInRow = [_dataSource respondsToSelector:@selector(calendarView:itemForCalendarInDate:)];
}

- (void)setDelegate:(id<QTCalendarViewDelegate>)delegate {
    _delegate = delegate;
    _delegateHas.didSelectDate = [_delegate respondsToSelector:@selector(calendarView:previousSelectDate:currentSelectDate:)];
    _delegateHas.calendarViewDidScroll = [_delegate respondsToSelector:@selector(calendarViewDidScroll:)];
    _delegateHas.calendarViewDidEndScroll = [_delegate respondsToSelector:@selector(calendarViewDidEndDecelerating:)];
}
@end
