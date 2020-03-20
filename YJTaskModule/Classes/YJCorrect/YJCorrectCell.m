//
//  YJCorrectCell.m
//  LGEducationCloud
//
//  Created by 刘亚军 on 2019/4/22.
//  Copyright © 2019 lange. All rights reserved.
//

#import "YJCorrectCell.h"
#import "YJCorrectLab.h"
#import "YJConst.h"
#import <Masonry/Masonry.h>

@interface YJCorrectDeleteLine : UIView
@property (nonatomic,assign) BOOL isTop;
@end
@implementation YJCorrectDeleteLine

- (void)drawRect:(CGRect)rect{
    
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
     CGFloat lineWidth = 2;
    
    CGFloat y = (height - lineWidth)/2 + 1;
    if (self.isTop) {
        y = 0;
    }
    
    /* 进度 */
    UIBezierPath* aPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, y, width, lineWidth) cornerRadius:lineWidth/2];
    
    // 设置颜色
    [LG_ColorWithHex(0xFF0000) set];
    
    // 填充
    [aPath fill];
}
- (void)setIsTop:(BOOL)isTop{
    _isTop = isTop;
    [self setNeedsDisplay];
}
@end

@interface YJCorrectCell ()<YJCorrectLabDelegate>
@property (nonatomic,strong) YJCorrectDeleteLine *deleteLine;
@property (strong, nonatomic) YJCorrectLab *contentL;
@end
@implementation YJCorrectCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.contentL];
        [self.contentL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        __weak typeof(self) weakSelf = self;
        self.contentL.tapBlock = ^{
            [weakSelf correctLabTap];
        };
        
        [self.contentL yj_clipLayerWithRadius:2 width:0 color:nil];
        
        [self.contentView addSubview:self.deleteLine];
        [self.deleteLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.top.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(3);
        }];
        self.deleteLine.hidden = YES;
    }
    return self;
}

- (void)removeAnswerLab{
    [self.contentL removeAnswerLab];
}
#pragma mark - YJCorrectLabDelegate
- (void)correctLabTap{
    UICollectionView *collectionView = (UICollectionView *)[self superview];
    if([collectionView isKindOfClass:[UICollectionView class]]){
        id<UICollectionViewDelegate> collDelegate = collectionView.delegate;
        if([collDelegate respondsToSelector:@selector(collectionView:performAction:forItemAtIndexPath:withSender:)]){
            NSIndexPath *indexPath = [collectionView indexPathForCell:self];
            [collDelegate collectionView:collectionView performAction:@selector(correctLabTap) forItemAtIndexPath:indexPath withSender:nil];
        }
    }
}
- (void)remove:(YJCorrectLab *)lab{
    UICollectionView *collectionView = (UICollectionView *)[self superview];
    if([collectionView isKindOfClass:[UICollectionView class]]){
        id<UICollectionViewDelegate> collDelegate = collectionView.delegate;
        if([collDelegate respondsToSelector:@selector(collectionView:performAction:forItemAtIndexPath:withSender:)]){
            NSIndexPath *indexPath = [collectionView indexPathForCell:self];
            [collDelegate collectionView:collectionView performAction:@selector(removeItem:) forItemAtIndexPath:indexPath withSender:lab];
        }
    }
}
- (void)removeAnswer:(YJCorrectLab *)lab{
    UICollectionView *collectionView = (UICollectionView *)[self superview];
    if([collectionView isKindOfClass:[UICollectionView class]]){
        id<UICollectionViewDelegate> collDelegate = collectionView.delegate;
        if([collDelegate respondsToSelector:@selector(collectionView:performAction:forItemAtIndexPath:withSender:)]){
            NSIndexPath *indexPath = [collectionView indexPathForCell:self];
            [collDelegate collectionView:collectionView performAction:@selector(removeAnswerItem:) forItemAtIndexPath:indexPath withSender:lab];
        }
    }
}
- (void)correct:(YJCorrectLab *)lab{
    UICollectionView *collectionView = (UICollectionView *)[self superview];
    if([collectionView isKindOfClass:[UICollectionView class]]){
        id<UICollectionViewDelegate> collDelegate = collectionView.delegate;
        if([collDelegate respondsToSelector:@selector(collectionView:performAction:forItemAtIndexPath:withSender:)]){
            NSIndexPath *indexPath = [collectionView indexPathForCell:self];
            [collDelegate collectionView:collectionView performAction:@selector(correctItem:) forItemAtIndexPath:indexPath withSender:lab];
        }
    }
}
- (void)preAdd:(YJCorrectLab *)lab{
    UICollectionView *collectionView = (UICollectionView *)[self superview];
    if([collectionView isKindOfClass:[UICollectionView class]]){
        id<UICollectionViewDelegate> collDelegate = collectionView.delegate;
        if([collDelegate respondsToSelector:@selector(collectionView:performAction:forItemAtIndexPath:withSender:)]){
            NSIndexPath *indexPath = [collectionView indexPathForCell:self];
            [collDelegate collectionView:collectionView performAction:@selector(preAddItem:) forItemAtIndexPath:indexPath withSender:lab];
        }
    }
}

- (void)setText:(NSString *)text{
    _text = text;
    self.contentL.text = text;
}
- (void)setAnswerType:(YJCorrectAnswerType)answerType{
    _answerType = answerType;
    self.deleteLine.hidden = YES;
    self.contentL.isAnswer = NO;
    
    if (answerType == YJCorrectAnswerTypeDelete) {
        self.deleteLine.isTop = NO;
        self.deleteLine.hidden = NO;
    }

    if (answerType == YJCorrectAnswerTypeModify) {
        self.deleteLine.isTop = YES;
        self.deleteLine.hidden = NO;
    }
    
    if (answerType != YJCorrectAnswerTypeNo) {
        self.contentL.isAnswer = YES;
    }
}
- (void)setIsSelect:(BOOL)isSelect{
    _isSelect = isSelect;
    if (isSelect) {
        self.contentL.backgroundColor = LG_ColorWithHex(0xFFEFDB);
    }else{
        self.contentL.backgroundColor = [UIColor whiteColor];
    }
}
- (YJCorrectDeleteLine *)deleteLine{
    if (!_deleteLine) {
        _deleteLine = [[YJCorrectDeleteLine alloc] initWithFrame:CGRectZero];
        _deleteLine.backgroundColor = [UIColor clearColor];
        _deleteLine.userInteractionEnabled = NO;
    }
    return _deleteLine;
}

- (YJCorrectLab *)contentL{
    if (!_contentL) {
        _contentL = [[YJCorrectLab alloc] initWithFrame:CGRectZero];
        _contentL.textAlignment = NSTextAlignmentCenter;
        _contentL.font = [UIFont systemFontOfSize:16];
        _contentL.delegate = self;
    }
    return _contentL;
}
@end
