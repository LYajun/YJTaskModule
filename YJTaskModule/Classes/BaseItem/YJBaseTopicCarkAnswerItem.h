//
//  YJBaseTopicCarkAnswerItem.h
//  LGEducationCloud
//
//  Created by 刘亚军 on 2018/5/14.
//  Copyright © 2018年 lange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJBasePaperModel.h"
#import "YJTaskTitleView.h"
@interface YJBaseTopicCarkAnswerItem : UIView
@property (nonatomic,assign) NSInteger totalTopicCount;
@property (nonatomic,assign) NSInteger currentIndex;
@property (nonatomic,assign) NSInteger currentSmallIndex;
@property (nonatomic,assign) YJTaskStageType taskStageType;
@property (assign,nonatomic) YJBasePaperBigModel *bigModel;
@property (strong,nonatomic) YJTaskTitleView *titleView;
- (instancetype)initWithFrame:(CGRect)frame
           bigTopicASPModel:(YJBasePaperBigModel *)bigTopicASPModel taskStageType:(YJTaskStageType) taskStageType;
- (void)updateData;
@end
