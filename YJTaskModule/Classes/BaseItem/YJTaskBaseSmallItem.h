//
//  YJTaskBaseSmallItem.h
//  YJTaskKit
//
//  Created by 刘亚军 on 2018/7/31.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJPaperProtocol.h"

@class YJBasePaperBigModel,YJBasePaperSmallModel,YJTaskTitleView;

@protocol YJTaskBaseSmallItemDelegate <NSObject>

@optional
- (void)YJ_blankAnswerUpdate;
- (void)YJ_choiceTopicDidAnswer;
- (void)YJ_taskTopicCellDidPlayVoice;
@end

@interface YJTaskBaseSmallItem : UIView
@property (nonatomic,assign) id<YJTaskBaseSmallItemDelegate> delegate;
@property (nonatomic,assign) NSInteger totalTopicCount;
@property (nonatomic,assign) BOOL lastSmallItem;
@property (nonatomic,assign) NSInteger currentIndex;
@property (nonatomic,assign) NSInteger currentSmallIndex;
@property (nonatomic,assign) YJTaskStageType taskStageType;
@property (assign,nonatomic) YJBasePaperSmallModel *smallModel;
@property (assign,nonatomic) YJBasePaperBigModel *bigModel;
@property (strong,nonatomic) YJTaskTitleView *titleView;

- (instancetype)initWithFrame:(CGRect)frame
                  smallPModel:(YJBasePaperSmallModel *)smallPModel
                taskStageType:(YJTaskStageType)taskStageType;
- (void)updateData;
- (void)stopVoicePlay;
@end
