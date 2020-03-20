//
//  YJCorrectFlowLayout.h
//
//  Created by 刘亚军 on 16/8/23.
//  Copyright © 2016年 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YJCorrectFlowLayout;

@protocol YJCorrectFlowLayoutDelegate <NSObject>

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(YJCorrectFlowLayout *)collectionViewLayout
 widthForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional

- (CGFloat)collectionView:(UICollectionView *)collectionView
                    layout:(YJCorrectFlowLayout *)collectionViewLayout
heightForHeaderAtIndexPath:(NSIndexPath *)indexPath;

@end
@interface YJCorrectFlowLayout : UICollectionViewLayout
@property (nonatomic,assign) id<YJCorrectFlowLayoutDelegate> delegate;
// 宽度
@property (nonatomic,assign)  CGFloat itemHeight;
// 顶部间距
@property (nonatomic) CGFloat topInset;
// 尾部间距
@property (nonatomic) CGFloat bottomInset;
// 分区头视图是否悬浮
@property (nonatomic) BOOL stickyHeader;
// 左右间距
@property (nonatomic,assign) CGFloat leftMargin;
@end
