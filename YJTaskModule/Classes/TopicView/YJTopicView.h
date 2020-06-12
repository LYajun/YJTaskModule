//
//  YJTopicView.h
//  YJTaskKit
//
//  Created by 刘亚军 on 2018/7/30.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJBasePaperModel.h"

@class YJBasePaperBigModel,YJTopicView;
@protocol YJTopicViewViewDelegate <NSObject>

@optional
- (void)yj_topicView:(YJTopicView *) topicView didClickBlankTextAtIndex:(NSInteger) index;
@end

@interface YJTopicView : UIView
/** 高亮当前小题作答区域 */
@property (nonatomic,assign) NSInteger highlightSmallIndex;

@property (nonatomic,assign) YJTaskStageType taskStageType;
@property (nonatomic,assign) id<YJTopicViewViewDelegate> delegate;
@property (nonatomic,copy) void (^updateBlock) (NSError *error);
- (instancetype)initWithFrame:(CGRect)frame bigPModel:(YJBasePaperBigModel *)bigPModel;
- (void)updateBlankAnswers;
- (void)startListen;
- (void)stopListen;
- (void)pauseListen;
@end
