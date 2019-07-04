//
//  YJCorrectFlowLayout.m
//  YJWritting
//
//  Created by 刘亚军 on 16/8/23.
//  Copyright © 2016年 刘亚军. All rights reserved.
//

#import "YJCorrectFlowLayout.h"
#import "YJconst.h"

@interface YJCorrectFlowLayout ()
@property (nonatomic) NSArray *sectionRows; // 分区行数
@property (nonatomic) CGFloat itemInnerXMargin; // 内部间距
@property (nonatomic) CGFloat itemInnerYMargin; // 内部间距
@property (nonatomic) NSDictionary *layoutInfo; // 布局信息
@property (nonatomic) NSArray *sectionsHeights; // 分区高度集合
@property (nonatomic) NSArray *itemsInSectionsWidths; // 分区每个item的宽度
// 用来保存最终计算出来的每个item的X坐标
@property (strong,nonatomic) NSArray *itemX;
// 用来保存最终计算出来的每个item的X坐标
@property (strong,nonatomic) NSArray *itemY;
@end
NSString* const YJCorrectLayoutCellKind = @"WaterfallCell";
@implementation YJCorrectFlowLayout
#pragma mark - Lifecycle
- (id)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}
// 设置默认值
- (void)setup {
    self.itemHeight = 20.0f;
    self.topInset = 10.0f;
    self.bottomInset = 10.0f;
    self.stickyHeader = NO;
    self.leftMargin = 0;
}
// 准备布局
- (void)prepareLayout{
    [super prepareLayout];
    [self calculateItemsInnerMargin];
    [self calculateItemsWidths];
    [self calculateSectionsHeights];
    [self calculateItemsAttributes];
}
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity:self.layoutInfo.count];
    [self.layoutInfo enumerateKeysAndObjectsUsingBlock:^(NSString *elementIdentifier,
                                                         NSDictionary *elementsInfo,
                                                         BOOL *stop) {
        [elementsInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath,
                                                          UICollectionViewLayoutAttributes *attributes,
                                                          BOOL *innerStop) {
            if (CGRectIntersectsRect(rect, attributes.frame) || [elementIdentifier isEqualToString:UICollectionElementKindSectionHeader]) {
                [allAttributes addObject:attributes];
            }
        }];
    }];
    if(!self.stickyHeader) {
        return allAttributes;
    }
    for (UICollectionViewLayoutAttributes *layoutAttributes in allAttributes) {
        if ([layoutAttributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            NSInteger section = layoutAttributes.indexPath.section;
            NSIndexPath *firstCellIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
            UICollectionViewLayoutAttributes *firstCellAttrs = [self layoutAttributesForItemAtIndexPath:firstCellIndexPath];
            CGFloat headerHeight = CGRectGetHeight(layoutAttributes.frame) + self.itemInnerYMargin;
            CGFloat currentHeaderHeight = [self headerHeightForIndexPath:firstCellIndexPath];
            CGPoint origin = layoutAttributes.frame.origin;
            origin.y = MIN(
                           MAX(self.collectionView.contentOffset.y, (CGRectGetMinY(firstCellAttrs.frame) - headerHeight) - self.topInset),
                           CGRectGetMinY(firstCellAttrs.frame) - headerHeight + [[self.sectionsHeights objectAtIndex:section] floatValue] - currentHeaderHeight - self.topInset
                           ) + self.topInset;
            
            CGFloat width = layoutAttributes.frame.size.width;
            if(self.collectionView.contentOffset.y >= origin.y) {
                width = self.collectionView.bounds.size.width;
                origin.x = 0;
            } else {
                width = self.collectionView.bounds.size.width -
                MIN((2 * self.itemInnerXMargin),
                    (origin.y - self.collectionView.contentOffset.y));
                origin.x = (self.collectionView.bounds.size.width - width) / 2;
            }
            layoutAttributes.zIndex = 1024;
            layoutAttributes.frame = (CGRect){
                .origin = origin,
                .size = CGSizeMake(width, layoutAttributes.frame.size.height)
            };
        }
    }
    return allAttributes;
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.layoutInfo[YJCorrectLayoutCellKind][indexPath];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind
                                                                     atIndexPath:(NSIndexPath *)indexPath {
    return self.layoutInfo[UICollectionElementKindSectionHeader][indexPath];
}
- (CGSize)collectionViewContentSize {
    CGFloat height = self.topInset;
    for (NSNumber *h in self.sectionsHeights) {
        height += [h integerValue];
    }
    height += self.bottomInset;
    
    return CGSizeMake(self.collectionView.bounds.size.width, height);
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBound {
    return self.stickyHeader;
}
#pragma mark - Prepare layout calculation
// 计算内部间距
- (void)calculateItemsInnerMargin {
    self.itemInnerXMargin = 2;
    self.itemInnerYMargin = 30;
}
// 计算分区每个item的宽度
- (void) calculateItemsWidths{
    CGFloat screenW = LG_ScreenWidth - self.leftMargin*2;
    CGFloat itemMaxW = screenW - self.itemInnerXMargin*2;
    NSMutableArray *itemsInSectionsWidths = [NSMutableArray arrayWithCapacity:self.collectionView.numberOfSections];
    NSIndexPath *itemIndex;
    for (NSInteger section = 0; section < self.collectionView.numberOfSections; section++) {
        NSMutableArray *itemsWidths = [NSMutableArray arrayWithCapacity:[self.collectionView numberOfItemsInSection:section]];
         for (NSInteger item = 0; item < [self.collectionView numberOfItemsInSection:section]; item++) {
             itemIndex = [NSIndexPath indexPathForItem:item inSection:section];
             CGFloat itemWidth = [self.delegate collectionView:self.collectionView layout:self widthForItemAtIndexPath:itemIndex];
             if (itemWidth > itemMaxW) {
                 itemWidth = itemMaxW;
             }
             [itemsWidths addObject:[NSNumber numberWithFloat:itemWidth]];
         }
        [itemsInSectionsWidths addObject:itemsWidths];
    }
    self.itemsInSectionsWidths = itemsInSectionsWidths;
}
// 计算每个分区的高度
- (void) calculateSectionsHeights {
    CGFloat screenW = LG_ScreenWidth - self.leftMargin*2;
//    CGFloat itemMaxW = screenW - self.itemInnerMargin*2;
    NSMutableArray *newSectionsHeights = [NSMutableArray array];
    NSInteger sectionCount = [self.collectionView numberOfSections];
    NSMutableArray *itemXCopy = [NSMutableArray array];
    NSMutableArray *itemYCopy = [NSMutableArray array];
    NSMutableArray *rowArr = [NSMutableArray array];
     NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    for (NSInteger section = 0; section < sectionCount; section++) {
        NSInteger rowCount = 0;
        NSMutableArray *itemXCopyTmp = [NSMutableArray array];
        NSMutableArray *itemYCopyTmp = [NSMutableArray array];
         NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        if (itemCount > 0) {
            rowCount = 1;
        }
        NSArray *widthArr = self.itemsInSectionsWidths[section];
        for (NSInteger item = 0; item < itemCount; item++) {
            CGFloat itemWidth = [widthArr[item] floatValue];
            indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            //计算x,y坐标公式
            CGFloat itemX = 0;
            if (item == 0) {
                itemX = self.itemInnerXMargin;
            }else{
                itemX = [itemXCopyTmp[item - 1] floatValue]+ [widthArr[item - 1] floatValue] + self.itemInnerXMargin;
                if ((itemX + itemWidth + self.itemInnerXMargin) > screenW) {
                    rowCount++;
                    itemX = self.itemInnerXMargin;
                }
            }
            [itemXCopyTmp addObject:[NSNumber numberWithFloat:itemX]];
            CGFloat itemY = 0;
            if (section == 0) {
                itemY = self.topInset + [self headerHeightForIndexPath:indexPath];
            }else{
                CGFloat orightY = 0;
                for (int i = 0; i < section; i++) {
                    orightY += [newSectionsHeights[i] floatValue];
                }
                itemY = self.topInset + [self headerHeightForIndexPath:indexPath] + orightY;
            }
            //计算y坐标公式
            itemY += (self.itemHeight + self.itemInnerYMargin) * (rowCount-1) + self.itemInnerYMargin;
            [itemYCopyTmp addObject:[NSNumber numberWithFloat:itemY]];
        }
        [rowArr addObject:[NSNumber numberWithInteger:rowCount]];
        [itemXCopy addObject:itemXCopyTmp];
        [itemYCopy addObject:itemYCopyTmp];
        CGFloat sectionHeight = [self headerHeightForIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]] + (self.itemHeight + self.itemInnerYMargin)*rowCount + (rowCount > 0?self.itemInnerYMargin:0);
        [newSectionsHeights addObject:[NSNumber numberWithFloat:sectionHeight]];
    }
    self.sectionRows = [NSArray arrayWithArray:rowArr];
    self.itemX = [NSArray arrayWithArray:itemXCopy];
    self.itemY = [NSArray arrayWithArray:itemYCopy];
    self.sectionsHeights = [NSArray arrayWithArray:newSectionsHeights];
}
// 计算每个分区头的高度
- (CGFloat) headerHeightForIndexPath:(NSIndexPath*)indexPath {
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:heightForHeaderAtIndexPath:)]) {
        return [self.delegate collectionView:self.collectionView
                                      layout:self
                  heightForHeaderAtIndexPath:indexPath];
    }
    return 0;
}
// 计算每个item属性
- (void) calculateItemsAttributes {
    CGFloat screenW = LG_ScreenWidth - self.leftMargin*2;
    NSMutableDictionary *newLayoutInfo = [NSMutableDictionary dictionary];
    NSMutableDictionary *cellLayoutInfo = [NSMutableDictionary dictionary];
    NSMutableDictionary *titleLayoutInfo = [NSMutableDictionary dictionary];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
   for (NSInteger section = 0; section < [self.collectionView numberOfSections]; section++) {
       for (NSInteger item = 0; item < [self.collectionView numberOfItemsInSection:section]; item++) {
           indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
           itemAttributes.frame = CGRectMake([self.itemX[section][item] floatValue], [self.itemY[section][item] floatValue], [self.itemsInSectionsWidths[section][item] floatValue], self.itemHeight);
           cellLayoutInfo[indexPath] = itemAttributes;
           if (indexPath.item == 0) {
               UICollectionViewLayoutAttributes *titleAttributes = [UICollectionViewLayoutAttributes
                                                                    layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                    withIndexPath:indexPath];
               CGFloat height = [self headerHeightForIndexPath:indexPath];
               CGFloat originY = self.topInset;
               if (indexPath.section > 0) {
                   for (int i = 0; i < section; i++) {
                       originY += [self.sectionsHeights[i] floatValue];
                   }
               }
               titleAttributes.frame = CGRectMake(0, originY, screenW, height);
               titleLayoutInfo[indexPath] = titleAttributes;
           }
       }
       if ([self.collectionView numberOfItemsInSection:section] == 0) {
            indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
           UICollectionViewLayoutAttributes *titleAttributes = [UICollectionViewLayoutAttributes
                                                                layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                withIndexPath:indexPath];
           CGFloat height = [self headerHeightForIndexPath:indexPath];
           CGFloat originY = self.topInset;
           if (indexPath.section > 0) {
               for (int i = 0; i < section; i++) {
                   originY += [self.sectionsHeights[i] floatValue];
               }
           }
           titleAttributes.frame = CGRectMake(0, originY, screenW, height);
           titleLayoutInfo[indexPath] = titleAttributes;
       }
   }
    newLayoutInfo[YJCorrectLayoutCellKind] = cellLayoutInfo;
    newLayoutInfo[UICollectionElementKindSectionHeader] = titleLayoutInfo;
    self.layoutInfo = [NSDictionary dictionaryWithDictionary:newLayoutInfo];
}
@end
