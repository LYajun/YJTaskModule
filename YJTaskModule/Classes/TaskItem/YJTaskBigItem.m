//
//  YJTaskBigItem.m
//  YJTaskKit
//
//  Created by 刘亚军 on 2018/7/31.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "YJTaskBigItem.h"
#import "YJBasePaperModel.h"
#import <YJResizableSplitView/YJResizableSplitView.h>
#import "YJTopicView.h"
#import "YJTaskBaseSmallItem.h"
#import <Masonry/Masonry.h>
#import "YJBaseTopicCarkAnswerItem.h"
#import <SwipeView/SwipeView.h>
#import "YJConst.h"

@interface YJTaskBigItem ()<YJResizableSplitViewDelegate,YJTopicViewViewDelegate,UIScrollViewDelegate,YJTaskBaseSmallItemDelegate>
@property(nonatomic,strong) YJBasePaperBigModel *bigModel;
@property(nonatomic,strong) YJBasePaperModel *taskModel;
@property (nonatomic,strong) UIScrollView *smallScrollView;
@property (nonatomic,strong) UIView *smallScrollContentView;
@property (nonatomic,strong) YJResizableSplitView *splitView;
@property (nonatomic,strong) YJTopicView *bigTopicView;
@end
@implementation YJTaskBigItem
- (instancetype)initWithFrame:(CGRect)frame bigPModel:(YJBasePaperBigModel *)bigPModel taskStageType:(YJTaskStageType)taskStageType{
    if (self = [super initWithFrame:frame]) {
        self.bigModel = bigPModel;
        [self layoutUIWithTaskStageType:taskStageType];
        [self configure];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame bigPModel:(YJBasePaperBigModel *)bigPModel taskStageType:(YJTaskStageType)taskStageType taskPModel:(YJBasePaperModel *)taskPModel{
    if (self = [super initWithFrame:frame]) {
        self.bigModel = bigPModel;
        self.taskModel = taskPModel;
         [self layoutUIWithTaskStageType:taskStageType];
        [self configure];
    }
    return self;
}
- (void)layoutUIWithTaskStageType:(YJTaskStageType)taskStageType{
    self.backgroundColor = [UIColor whiteColor];
    self.bigTopicView.taskStageType = taskStageType;
    [self addSubview:self.bigTopicView];
    [self.bigTopicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(self.bigTopicViewHeight);
    }];
    [self addSubview:self.splitView];
    [self.splitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self.bigTopicView.mas_bottom);
    }];
    
    [self.splitView.contentView addSubview:self.smallScrollView];
    [self.smallScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.splitView.contentView);
    }];
    UIView *contentView = [UIView new];
    [self.smallScrollView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.smallScrollView);
        make.height.equalTo(self.smallScrollView);
    }];
    self.smallScrollContentView = contentView;
    if (self.bigModel.yj_topicCarkMode) {
        for (int i = 0; i < self.taskModel.yj_bigTopicList.count; i++) {
            YJBasePaperBigModel *bigModel = (YJBasePaperBigModel *)self.taskModel.yj_bigTopicList[i];
            YJBaseTopicCarkAnswerItem *bigItem = [[[bigModel topicCardClassByTaskStageType:taskStageType] alloc] initWithFrame:CGRectZero bigTopicASPModel:bigModel taskStageType:taskStageType];
            bigItem.totalTopicCount = self.taskModel.yj_bigTopicList.count;
            bigItem.currentIndex = i;
            [contentView addSubview:bigItem];
            if (i == 0) {
                [bigItem mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.top.bottom.height.equalTo(contentView);
                    make.width.mas_equalTo(LG_ScreenWidth);
                }];
            }else{
                YJBaseTopicCarkAnswerItem *lastItem = contentView.subviews[i-1];
                [bigItem mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.height.equalTo(contentView);
                    make.left.equalTo(lastItem.mas_right);
                    make.width.mas_equalTo(LG_ScreenWidth);
                }];
            }
            if (i == self.taskModel.yj_bigTopicList.count-1) {
                [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(bigItem.mas_right);
                }];
            }
        }
    }else{
        NSInteger smallCount = 0;
        YJBasePaperSmallModel *lastSmallModel = (YJBasePaperSmallModel *)self.bigModel.yj_smallTopicList.lastObject;
        if (!IsStrEmpty(lastSmallModel.yj_smallIndex_Ori)) {
            smallCount = [[lastSmallModel.yj_smallIndex_Ori componentsSeparatedByString:@"|"].firstObject integerValue]+1;
        }else{
            smallCount = lastSmallModel.yj_smallIndex+1;
        }
        for (int i = 0; i < smallCount; i++) {
            YJBasePaperSmallModel *smallModel = (YJBasePaperSmallModel *)self.bigModel.yj_smallTopicList[i];
            if (!IsStrEmpty(smallModel.yj_smallIndex_Ori) ) {
                smallModel = (YJBasePaperSmallModel *)[self.bigModel.yj_smallTopicList yj_objectAtIndex:smallModel.yj_smallMutiBlankIndex];
                
            }
            YJTaskBaseSmallItem *smallItem = [[[self.bigModel taskClassByTaskStageType:taskStageType] alloc] initWithFrame:CGRectZero smallPModel:smallModel taskStageType:taskStageType];
            if (i == smallCount-1) {
                smallItem.lastSmallItem = YES;
            }
            smallItem.bigModel = self.bigModel;
            smallItem.delegate = self;
            smallItem.totalTopicCount = smallCount;
            smallItem.currentIndex = i;
            [contentView addSubview:smallItem];
            if (i == 0) {
                [smallItem mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.top.bottom.height.equalTo(contentView);
                    make.width.mas_equalTo(LG_ScreenWidth);
                }];
            }else{
                YJTaskBaseSmallItem *lastItem = contentView.subviews[i-1];
                [smallItem mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.height.equalTo(contentView);
                    make.left.equalTo(lastItem.mas_right);
                    make.width.mas_equalTo(LG_ScreenWidth);
                }];
            }
            if (i == smallCount-1) {
                [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(smallItem.mas_right);
                }];
            }
        }
    }
}
- (void)configure{
    if (self.bigModel.yj_bigTopicType == YJBigTopicTypeChioceBlank) {
        if (self.bigTopicView.taskStageType == YJTaskStageTypeAnalysis ||
            self.bigTopicView.taskStageType == YJTaskStageTypeAnalysisNoSubmit ||
            self.bigTopicView.taskStageType == YJTaskStageTypeCheck ||
            self.bigTopicView.taskStageType == YJTaskStageTypeCheckViewer ||
            self.bigTopicView.taskStageType == YJTaskStageTypeViewer ||
            self.bigTopicView.taskStageType == YJTaskStageTypeAnaLysisTopicViewer ||
            self.bigTopicView.taskStageType == YJTaskStageTypeManualMark ||
            self.bigTopicView.taskStageType == YJTaskStageTypeManualMarkViewer) {
            self.splitView.dragEnable = YES;
        }else{
            self.splitView.dragEnable = NO;
        }
    }else if (self.bigModel.yj_topicCarkMode){
        self.splitView.dragEnable = YES;
    }else{
        if (self.bigModel.yj_isCorrectTopic && (self.bigTopicView.taskStageType == YJTaskStageTypeAnswer || self.bigTopicView.taskStageType == YJTaskStageTypeViewer)) {
            self.splitView.dragEnable = NO;
        }else{
            if (IsStrEmpty(self.bigModel.yj_topicContent) && IsStrEmpty(self.bigModel.yj_topicDirectionTxt)) {
                self.splitView.dragEnable = NO;
            }else{
                self.splitView.dragEnable = YES;
            }
        }
    }
}

#pragma mark Public

- (void)stopListen{
    [self stopTaskBaseSmallItemVoicePlay];
    [self.bigTopicView stopListen];
}
- (void)pauseListen{
    [self.bigTopicView pauseListen];
}
- (void)updateCurrentSmallItemWithAnswer:(NSString *)answer{
    YJTaskBaseSmallItem *smallItem = [self.smallScrollContentView.subviews yj_objectAtIndex:self.currentSmallIndex];
    YJBasePaperSmallModel *smallModel = (YJBasePaperSmallModel *)self.bigModel.yj_smallTopicList[self.currentSmallIndex];
    if (!IsArrEmpty(smallModel.yj_smallQuesAskList)) {
        NSString *answerStr = @"";
        if (!IsStrEmpty(smallModel.yj_smallAnswer)) {
            NSArray *answerStrList = [smallModel.yj_smallAnswer componentsSeparatedByString:YJTaskModule_u2060];
            NSInteger index = smallItem.currentSmallIndex;
            if (index <= answerStrList.count - 1) {
                answerStr = answerStrList[index];
            }
        }
      answerStr = [NSString stringWithFormat:@"%@ %@",answerStr,answer];
      [smallModel updateSmallAnswerStr:answerStr atIndex:smallItem.currentSmallIndex];
    }else{
        if (!IsStrEmpty(smallModel.yj_smallIndex_Ori)) {
            smallModel = (YJBasePaperSmallModel *)[self.bigModel.yj_smallTopicList yj_objectAtIndex:smallModel.yj_smallMutiBlankIndex];
            smallModel = (YJBasePaperSmallModel *)[self.bigModel.yj_smallTopicList yj_objectAtIndex:(smallItem.currentSmallIndex + smallModel.yj_smallIndex)];
            
        }
        smallModel.yj_smallAnswer = [NSString stringWithFormat:@"%@ %@",kApiParams(smallModel.yj_smallAnswer),answer];
    }
    
    [smallItem updateData];
    
    if (!self.bigModel.yj_topicCarkMode && (smallModel.yj_smallTopicType == YJSmallTopicTypeBlank)) {
        [self YJ_blankAnswerUpdate];
    }
}
- (void)updateTopicCardCurrentSmallItemWithAnswer:(NSString *)answer{
    YJBaseTopicCarkAnswerItem *smallItem = [self.smallScrollContentView.subviews yj_objectAtIndex:self.currentSmallIndex];
    YJBasePaperSmallModel *smallModel = (YJBasePaperSmallModel *)smallItem.bigModel.yj_smallTopicList[smallItem.currentSmallIndex];
    smallModel.yj_smallAnswer = [NSString stringWithFormat:@"%@ %@",kApiParams(smallModel.yj_smallAnswer),answer];
    [smallItem updateData];
} 
#pragma mark YJResizableSplitViewDelegate
- (void)YJResizableSplitViewBeginEditing:(YJResizableSplitView *)resizableSplitView{
    self.ownSwipeView.scrollEnabled = NO;
}
- (void)YJResizableSplitViewDidBeginEditing:(YJResizableSplitView *)resizableSplitView{
    CGFloat height = self.frame.size.height - CGRectGetHeight(resizableSplitView.frame);
    [self.bigTopicView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
}
- (void)YJResizableSplitViewDidEndEditing:(YJResizableSplitView *)resizableSplitView{
    self.ownSwipeView.scrollEnabled = YES;
}
#pragma mark YJTopicViewViewDelegate
- (void)yj_topicView:(YJTopicView *)topicView didClickBlankTextAtIndex:(NSInteger)index{
    self.currentSmallIndex = index;
}
#pragma mark UIScrollViewDelegate
/** 滚动完毕就会调用（如果是人为拖拽scrollView导致滚动完毕，才会调用这个方法） */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = round(scrollView.contentOffset.x / LG_ScreenWidth);
    if (index != self.currentSmallIndex) {
        self.currentSmallIndex = index;
    }
}
/** 滚动完毕就会调用（如果不是人为拖拽scrollView导致滚动完毕，才会调用这个方法） */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    NSInteger index = round(scrollView.contentOffset.x / LG_ScreenWidth);
    if (index != self.currentSmallIndex) {
        self.currentSmallIndex = index;
    }
}
#pragma mark YJTaskBaseSmallItemDelegate
- (void)YJ_blankAnswerUpdate{
    [self.bigTopicView updateBlankAnswers];
}
- (void)YJ_choiceTopicDidAnswer{
    if (self.currentSmallIndex < self.bigModel.yj_smallTopicList.count-1) {
        [self stopTaskBaseSmallItemVoicePlay];
        _currentSmallIndex++;
        self.bigTopicView.highlightSmallIndex = _currentSmallIndex;
        [self.smallScrollView setContentOffset:CGPointMake(LG_ScreenWidth*_currentSmallIndex, 0) animated:YES];
    }else{
        if (self.currentBigIndex < self.totalBigCount-1) {
            [self.ownSwipeView scrollToItemAtIndex:self.currentBigIndex+1 duration:0.2];
        }
    }
}
- (void)YJ_taskTopicCellDidPlayVoice{
   [self.bigTopicView stopListen];
}
#pragma mark Setter
- (void)setBottomDistance:(CGFloat)bottomDistance{
    _bottomDistance = bottomDistance;
    self.splitView.bottomDistance = bottomDistance;
}
- (void)setTopDistance:(CGFloat)topDistance{
    _topDistance = topDistance;
    self.splitView.topDistance = topDistance;
}
- (void)setTaskStageType:(YJTaskStageType)taskStageType{
    _taskStageType = taskStageType;
    for (UIView *view in self.smallScrollContentView.subviews) {
        if ([view isKindOfClass:[YJTaskBaseSmallItem class]]) {
            [(YJTaskBaseSmallItem *)view setTaskStageType:taskStageType];
            [(YJTaskBaseSmallItem *)view updateData];
        }else if ([view isKindOfClass:[YJBaseTopicCarkAnswerItem class]]){
            [(YJBaseTopicCarkAnswerItem *)view setTaskStageType:taskStageType];
            [(YJBaseTopicCarkAnswerItem *)view updateData];
        }
    }
}
- (void)stopTaskBaseSmallItemVoicePlay{
    UIView *smallItem = [self.smallScrollContentView.subviews yj_objectAtIndex:self.currentSmallIndex];
    if ([smallItem isKindOfClass:[YJTaskBaseSmallItem class]]) {
        [(YJTaskBaseSmallItem *)smallItem stopVoicePlay];
    }
    
}
- (void)setCurrentSmallIndex:(NSInteger)currentSmallIndex{
    [self stopTaskBaseSmallItemVoicePlay];
    _currentSmallIndex = currentSmallIndex;
    self.bigTopicView.highlightSmallIndex = currentSmallIndex;

    [self.smallScrollView layoutIfNeeded];
    self.smallScrollView.contentOffset = CGPointMake(LG_ScreenWidth*self.currentSmallIndex, 0);
    if (self.bigModel.yj_topicCarkMode) {
        self.taskModel.yj_currentBigIndex = currentSmallIndex;
    }
}
#pragma mark Getter
- (CGFloat)bigTopicViewHeight{
    CGFloat pintroH = 30 * (IsIPad ? 2 : 3);
    if (IsStrEmpty(self.bigModel.yj_topicDirectionTxt)) {
        pintroH = 0;
    }
    CGFloat listenH = 44;
    CGFloat titleH = 36;
    switch (self.bigModel.yj_bigTopicType) {
        case YJBigTopicTypeDefault:
            return titleH+pintroH;
            break;
        case YJBigTopicTypeChioceBlank:
            if (self.bigTopicView.taskStageType == YJTaskStageTypeAnalysis ||
                self.bigTopicView.taskStageType == YJTaskStageTypeAnalysisNoSubmit ||
                self.bigTopicView.taskStageType == YJTaskStageTypeCheck ||
                self.bigTopicView.taskStageType == YJTaskStageTypeCheckViewer ||
                self.bigTopicView.taskStageType == YJTaskStageTypeViewer ||
                 self.bigTopicView.taskStageType == YJTaskStageTypeAnaLysisTopicViewer ||
                self.bigTopicView.taskStageType == YJTaskStageTypeManualMark ||
                self.bigTopicView.taskStageType == YJTaskStageTypeManualMarkViewer) {
                if (IsStrEmpty(self.bigModel.yj_topicContent) && IsStrEmpty(self.bigModel.yj_topicListenText)) {
                    return titleH+pintroH;
                }else{
                    return self.height*0.3;
                }
            }else{
                return self.height;
            }
            break;
        case YJBigTopicTypeBigText:
        case YJBigTopicTypeBigTextAndBlank:
        {
            if (self.bigModel.yj_topicCarkMode) {
                return self.height*0.4;
            }else{
                if (self.bigModel.yj_isCorrectTopic && (self.bigTopicView.taskStageType == YJTaskStageTypeAnswer || self.bigTopicView.taskStageType == YJTaskStageTypeViewer)) {
                    return self.height;
                }else{
                    if (IsStrEmpty(self.bigModel.yj_topicContent) && IsStrEmpty(self.bigModel.yj_topicListenText)) {
                        return titleH+pintroH;
                    }else{
                        return self.height*0.3;
                    }
                }
            }
        }
        case YJBigTopicTypeListen:
            if (IsStrEmpty(self.bigModel.yj_topicListenText)) {
                return titleH+pintroH+listenH;
            }else{
                return titleH+listenH+self.height*0.3;
            }
            break;
        case YJBigTopicTypeBigTextAndListen:
            if (self.bigModel.yj_topicCarkMode) {
                return titleH+listenH+self.height*0.4+10;
            }else{
                if (IsStrEmpty(self.bigModel.yj_topicContent) && IsStrEmpty(self.bigModel.yj_topicListenText)) {
                    return titleH+pintroH+listenH+14;
                }else{
                    return titleH+listenH+self.height*0.3+14;
                }
            }
            break;
        default:
            return 0;
            break;
    }
}
- (YJTopicView *)bigTopicView{
    if (!_bigTopicView) {
        _bigTopicView = [[YJTopicView alloc] initWithFrame:CGRectZero bigPModel:self.bigModel];
        _bigTopicView.delegate = self;
        _bigTopicView.updateBlock = self.updateBlock;
    }
    return _bigTopicView;
}
- (YJResizableSplitView *)splitView{
    if (!_splitView) {
        _splitView = [[YJResizableSplitView alloc] initWithFrame:CGRectZero];
        _splitView.delegate = self;
        _splitView.topDistance = 44 + 50;
        _splitView.bottomDistance = 200;
    }
    return _splitView;
}
- (UIScrollView *)smallScrollView{
    if (!_smallScrollView) {
        _smallScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _smallScrollView.pagingEnabled = YES;
        _smallScrollView.delegate = self;
        _smallScrollView.bounces = NO;
        _smallScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _smallScrollView;
}
@end
