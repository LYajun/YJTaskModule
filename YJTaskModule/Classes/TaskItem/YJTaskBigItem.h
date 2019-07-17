//
//  YJTaskBigItem.h
//  YJTaskKit
//
//  Created by 刘亚军 on 2018/7/31.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJPaperProtocol.h"

@class YJBasePaperModel,YJBasePaperBigModel,SwipeView;
@interface YJTaskBigItem : UIView
/** 当前小题号 */
@property (nonatomic,assign) NSInteger currentSmallIndex;
/** 当前大题号 */
@property (nonatomic,assign) NSInteger currentBigIndex;
/** 总的大题数 */
@property (nonatomic,assign) NSInteger totalBigCount;
/** 作业阶段类型 */
@property (nonatomic,assign) YJTaskStageType taskStageType;
// 距离顶部的间距
@property (nonatomic, assign) CGFloat topDistance;
// 距离底部的间距
@property (nonatomic, assign) CGFloat bottomDistance;
@property (nonatomic,weak) SwipeView *ownSwipeView;
@property (nonatomic,copy) void (^updateBlock) (NSError *error);
- (instancetype)initWithFrame:(CGRect)frame
                    bigPModel:(YJBasePaperBigModel *) bigPModel
                taskStageType:(YJTaskStageType) taskStageType;
- (instancetype)initWithFrame:(CGRect)frame
                    bigPModel:(YJBasePaperBigModel *) bigPModel
                taskStageType:(YJTaskStageType) taskStageType
                   taskPModel:(YJBasePaperModel *) taskPModel;

- (void)stopListen;
- (void)pauseListen;

- (void)updateCurrentSmallItem;
- (void)updateTopicCardCurrentSmallItemWithAnswer:(NSString *)answer;

@end
