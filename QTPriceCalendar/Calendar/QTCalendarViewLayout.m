//
//  QTCalendarViewLayout.m
//  QTPriceCalendar
//
//  Created by lq09984 on 16/5/25.
//  Copyright © 2016年 L.Q. All rights reserved.
//

#import "QTCalendarViewLayout.h"

@interface QTCalendarViewLayout ()
{
    CGSize _contentSize;
    NSMutableArray *_attArr;
}
@end

@implementation QTCalendarViewLayout

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _attArr = [NSMutableArray array];
    
    NSInteger section = [self.collectionView numberOfSections];
    [_attArr removeAllObjects];
    for (int i = 0; i < section; i++) {
        NSInteger row = [self.collectionView numberOfItemsInSection:i];
        for (int j = 0; j < row; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            UICollectionViewLayoutAttributes * atts = [self layoutAttributesForItemAtIndexPath:indexPath];
            [_attArr addObject:atts];
        }
        _contentSize = CGSizeMake(section * self.collectionView.frame.size.width, 300);
    }
}

- (CGSize)collectionViewContentSize {
    return _contentSize;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *atts = [super layoutAttributesForElementsInRect:rect];
    
    NSInteger section = [self.collectionView numberOfSections];
    CGFloat lastY = [atts.lastObject frame].origin.y;
    CGFloat h = lastY + self.itemSize.height + self.sectionInset.bottom;
    _contentSize = CGSizeMake(section * self.collectionView.frame.size.width, h);

    return _attArr;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *atts = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGFloat columns =  indexPath.item % 7;
    CGFloat rows =  indexPath.item / 7;
//    CGFloat firstX = columns == 0 ? self.sectionInset.left : 0;
    CGFloat x = columns * self.itemSize.width + (indexPath.section * self.collectionView.frame.size.width) + self.minimumInteritemSpacing * columns + self.sectionInset.left;
    CGFloat y = rows * self.itemSize.height + self.sectionInset.top + self.minimumInteritemSpacing * rows;
    atts.frame = CGRectMake(x, y, self.itemSize.width, self.itemSize.height);
//    atts.alpha = 0.5;
    return atts;
}

@end
