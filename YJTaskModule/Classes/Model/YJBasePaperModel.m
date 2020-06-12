//
//  YJBasePaperModel.m
//  LGTeachCloud
//
//  Created by 刘亚军 on 2019/3/25.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "YJBasePaperModel.h"
#import "YjConst.h"
#import "YJTaskCarkModel.h"
@implementation YJBasePaperSmallModel
- (void)updateSmallAnswerStr:(NSString *)answer atIndex:(NSInteger)index{};
- (NSString *)yj_smallAnswer{
    if (self.yj_smallTopicType == YJSmallTopicTypeChoice && [NSString yj_isNum:_yj_smallAnswer]) {
        return [NSString yj_stringToASCIIStringWithIntCount:_yj_smallAnswer.integerValue+64];
    }
    return _yj_smallAnswer;
}
@end

@implementation YJBasePaperBigModel
- (NSDictionary<NSString *,NSString *> *)choiceTopicInfo{
    return @{@"R":@"翻译选择",
             @"A":@"单选题",
             @"C":@"完型选择",
             @"D":@"阅读选择",
             @"E":@"听力选择",
             @"J":@"判断题",
             @"K":@"阅读判断",
             @"L":@"听力判断"
             };
}
// 改错题 U
- (NSDictionary<NSString *,NSString *> *)blankTopicInfo{
    return @{@"O":@"句子填空",
             @"T":@"翻译填空",
             @"b":@"补全对话",
             @"P":@"短文填空",
             @"M":@"填空题",
             @"Q":@"阅读填空",
             @"S":@"听力填空",
             @"N":@"选词填空",
             @"S2-Physics":  @"物理",
             @"S2-Politics": @"政治",
             
             @"C":@"完型选择"
             };
}
- (NSDictionary<NSString *,NSString *> *)matchTopicInfo{
    return @{@"H":@"短文匹配",
             @"x":@"听力匹配",
             @"F":@"词汇匹配",
             @"G":@"对话匹配",
             @"m":@"匹配题"
             };
}
- (NSDictionary<NSString *,NSString *> *)listenTopicInfo{
    return @{@"x":@"听力匹配",
             @"S":@"听力填空",
             @"E":@"听力选择",
             @"L":@"听力判断",
             @"Z":@"听力简答",
             @"W":@"听写"
             };
}
- (void)configCorrectAnswerInfo:(NSDictionary *)answerInfo{}

+ (Class)taskListenViewClass{
    Class ListenView = NSClassFromString(@"YJListenView");
    NSString *listenClassName = [NSUserDefaults yj_stringForKey:YJTaskModule_ListenClassName_UserDefault_Key];
    if (!IsStrEmpty(listenClassName)){
        ListenView = NSClassFromString(listenClassName);
    }
    return ListenView;
}
- (Class)taskClassByTaskStageType:(YJTaskStageType)taskStageType{
    Class SmallItem = NSClassFromString(@"YJAnswerSmallItem");
    switch (taskStageType) {
        case YJTaskStageTypeAnswer:
        case YJTaskStageTypeViewer:
            SmallItem = NSClassFromString(@"YJAnswerSmallItem");
            break;
        case YJTaskStageTypeHp:
        case YJTaskStageTypeHpViewer:
            SmallItem = NSClassFromString(@"YJHpSmallItem");
            break;
        case YJTaskStageTypeAnaLysisTopicViewer:
            SmallItem = NSClassFromString(@"YJStatisticTopicClassLookTopicDetailSmallItem");
            break;
        case YJTaskStageTypeAnalysis:
        {
            if (self.yj_teachAnalysisStage) {
                SmallItem = NSClassFromString(@"YJAnaTeachSmallItem");
            }else{
                SmallItem = NSClassFromString(@"YJAnaSmallItem");
            }
        }
            break;
        case YJTaskStageTypeAnalysisNoSubmit:
            SmallItem = NSClassFromString(@"YJAnaSmallItem");
            break;
        case YJTaskStageTypeCheck:
        case YJTaskStageTypeCheckViewer:
            SmallItem = NSClassFromString(@"YJCheckSmallItem");
            break;
        case YJTaskStageTypeManualMark:
        case YJTaskStageTypeManualMarkViewer:
            SmallItem = NSClassFromString(@"YJManualMarkSmallItem");
            break;
        default:
            break;
    }
    return SmallItem;
}
- (Class)topicCardClassByTaskStageType:(YJTaskStageType)taskStageType{
    Class SmallItem = NSClassFromString(@"YJTopicCarkAnswerView");
    switch (taskStageType) {
        case YJTaskStageTypeAnswer:
        case YJTaskStageTypeViewer:
            SmallItem = NSClassFromString(@"YJTopicCarkAnswerView");
            break;
        case YJTaskStageTypeHp:
        case YJTaskStageTypeHpViewer:
            SmallItem = NSClassFromString(@"YJTopicCardHpView");
            break;
        case YJTaskStageTypeAnaLysisTopicViewer:
            SmallItem = NSClassFromString(@"YJStatisticTopicClassLookTopicDetailTopicCarkView");
            break;
        case YJTaskStageTypeAnalysis:
        case YJTaskStageTypeAnalysisNoSubmit:
            SmallItem = NSClassFromString(@"YJTopicCarkAnalysisView");
            break;
        case YJTaskStageTypeCheck:
        case YJTaskStageTypeCheckViewer:
            SmallItem = NSClassFromString(@"YJTopicCardCheckView");
            break;
        default:
            break;
    }
    return SmallItem;
}
- (Class)speechBigClassBySpeechBigTopicType:(YJSpeechBigTopicType)speechBigTopicType{
    Class SmallItem = NSClassFromString(@"YJTalkChoiceSmallItem");
    switch (speechBigTopicType) {
        case YJSpeechBigTopicTypeTalkChoice:
            SmallItem = NSClassFromString(@"YJTalkChoiceSmallItem");
            break;
        case YJSpeechBigTopicTypeShortChoice:
            SmallItem = NSClassFromString(@"YJTalkChoiceSmallItem");
            break;
        case YJSpeechBigTopicTypeRead:
            SmallItem = NSClassFromString(@"YJSpeechReadSmallItem");
            break;
        case YJSpeechBigTopicTypeFollowRead:
            SmallItem = NSClassFromString(@"YJSpeechFollowReadSmallItem");
            break;
        case YJSpeechBigTopicTypeScene:
            SmallItem = NSClassFromString(@"YJSpeechSceneSmallItem");
            break;
        case YJSpeechBigTopicTypeTheme:
            SmallItem = NSClassFromString(@"YJSpeechThemeSmallItem");
            break;
        case YJSpeechBigTopicTypeRepeat:
            SmallItem = NSClassFromString(@"YJSpeechRepeatSmallItem");
            break;
        default:
            break;
    }
    return SmallItem;
}

- (Class)speechViewerBigClassBySpeechBigTopicType:(YJSpeechBigTopicType)speechBigTopicType{
    Class SmallItem = NSClassFromString(@"YJSpeechViewerTalkChoiceSmallItem");
    switch (speechBigTopicType) {
        case YJSpeechBigTopicTypeTalkChoice:
        case YJSpeechBigTopicTypeShortChoice:
            SmallItem = NSClassFromString(@"YJSpeechViewerTalkChoiceSmallItem");
            break;
        case YJSpeechBigTopicTypeRead:
        case YJSpeechBigTopicTypeFollowRead:
            SmallItem = NSClassFromString(@"YJSpeechViewerReadSmallItem");
            break;
        case YJSpeechBigTopicTypeScene:
            SmallItem = NSClassFromString(@"YJSpeechViewerSceneSmallItem");
            break;
        case YJSpeechBigTopicTypeTheme:
        case YJSpeechBigTopicTypeRepeat:
            SmallItem = NSClassFromString(@"YJSpeechViewerRepeatSmallItem");
            break;
        default:
            break;
    }
    return SmallItem;
}
@end

@implementation YJBasePaperModel
- (BOOL)yj_isSubmit{
    return NO;
}
- (NSInteger)quesItemSum{
    NSInteger count = 0;
    for (YJBasePaperBigModel *bigModel in self.yj_bigTopicList) {
        if (IsStrEmpty(bigModel.yj_smallTopicList.firstObject.yj_smallIndex_Ori)) {
            count += bigModel.yj_smallTopicList.count;
        }else{
            NSInteger c = [[bigModel.yj_smallTopicList.lastObject.yj_smallIndex_Ori componentsSeparatedByString:@"|"].firstObject integerValue]+1;
            count += c ;
        }
    }
    return count;
}
- (NSInteger)quesMarkItemSum{
    NSInteger itemFinishSum = 0;
    for (YJBasePaperBigModel *bigModel in self.yj_bigTopicList) {
        for (YJBasePaperSmallModel *smallModel in bigModel.yj_smallTopicList) {
            BOOL isAnswer = NO;
             if (smallModel.yj_smallAnswerType != 4 && !IsStrEmpty(smallModel.yj_smallAnswer)) {
                 isAnswer = YES;
             }else if (smallModel.yj_smallAnswerType == 4 && (!IsStrEmpty(smallModel.yj_smallAnswer) || !IsArrEmpty(smallModel.yj_imgUrlArr))){
                 isAnswer = YES;
             }
            if (isAnswer) {
                if (smallModel.yj_smallMarkAnswerScore.floatValue >= 0) {
                    itemFinishSum++;
                }
            }else{
                itemFinishSum++;
            }
           
        }
    }
    return itemFinishSum;
}
- (NSInteger)quesHpItemSum{
    NSInteger itemFinishSum = 0;
    for (YJBasePaperBigModel *bigModel in self.yj_bigTopicList) {
        for (YJBasePaperSmallModel *smallModel in bigModel.yj_smallTopicList) {
            if (smallModel.yj_smallAnswerType == 4) {
                if (IsStrEmpty(smallModel.yj_smallAnswer)) {
                    itemFinishSum++;
                }else if (!IsStrEmpty(smallModel.yj_smallStuScore) && smallModel.yj_smallStuScore.floatValue >= 0){
                    itemFinishSum++;
                }
            }
        }
    }
    return itemFinishSum;
}
- (NSIndexPath *)quesUnAnswerItemIndexPath{
    NSInteger bigIndex = 0;
    NSInteger smallIndex = 0;
    
    int i = 0;
    for (YJBasePaperBigModel *bigModel in self.yj_bigTopicList) {
        int j = 0;
        for (YJBasePaperSmallModel *smallModel in bigModel.yj_smallTopicList) {
            if (smallModel.yj_smallItemCount > 1 && !IsStrEmpty(smallModel.yj_smallIndex_Ori)) {
                NSInteger startIndex = [[smallModel.yj_smallIndex_Ori componentsSeparatedByString:@"|"].firstObject integerValue];
                if (IsStrEmpty(smallModel.yj_smallAnswer)) {
                  bigIndex = i;
                  smallIndex = startIndex;
                  return [NSIndexPath indexPathForRow:smallIndex inSection:bigIndex];
                }
            }else{
                if (IsStrEmpty(smallModel.yj_smallAnswer) && IsArrEmpty(smallModel.yj_imgUrlArr)) {
                    bigIndex = i;
                    smallIndex = j;
                    if (!IsStrEmpty(smallModel.yj_smallIndex_Ori)) {
                        smallIndex = [[smallModel.yj_smallIndex_Ori componentsSeparatedByString:@"|"].firstObject integerValue];
                    }
                    return [NSIndexPath indexPathForRow:smallIndex inSection:bigIndex];
                }
            }
            j++;
        }
        i++;
    }
    return [NSIndexPath indexPathForRow:smallIndex inSection:bigIndex];
}
- (NSIndexPath *)quesUnMarkItemIndexPath{
    NSInteger bigIndex = 0;
    NSInteger smallIndex = 0;
    
    int i = 0;
    for (YJBasePaperBigModel *bigModel in self.yj_bigTopicList) {
        int j = 0;
        for (YJBasePaperSmallModel *smallModel in bigModel.yj_smallTopicList) {
            BOOL isAnswer = NO;
             if (smallModel.yj_smallAnswerType != 4 && !IsStrEmpty(smallModel.yj_smallAnswer)) {
                 isAnswer = YES;
             }else if (smallModel.yj_smallAnswerType == 4 && (!IsStrEmpty(smallModel.yj_smallAnswer) || !IsArrEmpty(smallModel.yj_imgUrlArr))){
                 isAnswer = YES;
             }
            if (isAnswer && smallModel.yj_smallMarkAnswerScore.floatValue < 0) {
                bigIndex = i;
                smallIndex = j;
                if (!IsStrEmpty(smallModel.yj_smallIndex_Ori)) {
                    smallIndex = [[smallModel.yj_smallIndex_Ori componentsSeparatedByString:@"|"].firstObject integerValue];
                }
                return [NSIndexPath indexPathForRow:smallIndex inSection:bigIndex];
            }
            j++;
        }
        i++;
    }
    return [NSIndexPath indexPathForRow:smallIndex inSection:bigIndex];
}
- (NSInteger)quesAnswerItemSum{
    NSInteger itemFinishSum = 0;
    for (YJBasePaperBigModel *bigModel in self.yj_bigTopicList) {
        NSInteger answerCount = 0;
        for (YJBasePaperSmallModel *smallModel in bigModel.yj_smallTopicList) {
            if (smallModel.yj_smallItemCount > 1 && !IsStrEmpty(smallModel.yj_smallIndex_Ori)) {
                NSInteger endIndex = [[smallModel.yj_smallIndex_Ori componentsSeparatedByString:@"|"].lastObject integerValue];
                if (endIndex == 0) {
                    answerCount = 0;
                }
                if (!IsStrEmpty(smallModel.yj_smallAnswer)) {
                    if (endIndex <= smallModel.yj_smallItemCount - 1) {
                        answerCount++;
                        if (endIndex == smallModel.yj_smallItemCount - 1 && answerCount == smallModel.yj_smallItemCount) {
                            itemFinishSum++;
                        }
                    }
                }
            }else{
                if (!IsStrEmpty(smallModel.yj_smallAnswer) || (smallModel.yj_smallAnswerType == 4 && !IsArrEmpty(smallModel.yj_imgUrlArr))) {
                    itemFinishSum++;
                }
            }
        }
    }
    return itemFinishSum;
}

- (NSArray<YJTaskCarkModel *> *)taskCarkModelArray{
    NSMutableArray *dataArr = [NSMutableArray array];
    for (int i = 0; i < self.yj_bigTopicList.count; i++) {
        YJBasePaperBigModel *bigModel = (YJBasePaperBigModel *)self.yj_bigTopicList[i];
        NSMutableArray *answers = [NSMutableArray array];
        NSMutableArray *indexs = [NSMutableArray array];
        NSInteger answerCount = 0;
        NSInteger unAnswerCount = 0;
        for (YJBasePaperSmallModel *smallModel in bigModel.yj_smallTopicList) {
            if (smallModel.yj_smallItemCount > 1 && !IsStrEmpty(smallModel.yj_smallIndex_Ori)) {
                NSInteger endIndex = [[smallModel.yj_smallIndex_Ori componentsSeparatedByString:@"|"].lastObject integerValue];
                if (endIndex == 0) {
                    answerCount = 0;
                    unAnswerCount = 0;
                }
                if (!IsStrEmpty(smallModel.yj_smallAnswer)) {
                    if (endIndex <= smallModel.yj_smallItemCount - 1) {
                        answerCount++;
                        if (endIndex == smallModel.yj_smallItemCount - 1) {
                            if (answerCount == smallModel.yj_smallItemCount) {
                                [answers addObject:@(1)];
                                [indexs addObject:@(smallModel.yj_smallPaperIndex)];
                            }else{
                                [answers addObject:@(0)];
                                [indexs addObject:@(smallModel.yj_smallPaperIndex)];
                            }
                        }
                    }
                }else{
                   if (endIndex == smallModel.yj_smallItemCount - 1) {
                       [answers addObject:@(0)];
                       [indexs addObject:@(smallModel.yj_smallPaperIndex)];
                   }
                }
            }else{
                if (!IsStrEmpty(smallModel.yj_smallAnswer) ||(smallModel.yj_smallAnswerType == 4 && !IsArrEmpty(smallModel.yj_imgUrlArr))) {
                    [answers addObject:@(1)];
                    [indexs addObject:@(smallModel.yj_smallPaperIndex)];
                }else{
                    [answers addObject:@(0)];
                    [indexs addObject:@(smallModel.yj_smallPaperIndex)];
                }
            }
        }
        YJTaskCarkModel *model = [[YJTaskCarkModel alloc] init];
        model.topcTypeName = bigModel.yj_bigTopicTypeName;
        model.answerResults = answers;
        model.indexs = indexs;
        model.topicIndex = bigModel.yj_bigIndex;
        [dataArr addObject:model];
    }
    return dataArr;
    
}
- (NSArray<YJTaskCarkModel *> *)taskMarkCarkModelArray{
    NSMutableArray *dataArr = [NSMutableArray array];
    for (int i = 0; i < self.yj_bigTopicList.count; i++) {
        YJBasePaperBigModel *bigModel = (YJBasePaperBigModel *)self.yj_bigTopicList[i];
        NSMutableArray *answers = [NSMutableArray array];
        NSMutableArray *indexs = [NSMutableArray array];
        NSInteger answerCount = 0;
        NSInteger unAnswerCount = 0;
        for (YJBasePaperSmallModel *smallModel in bigModel.yj_smallTopicList) {
            if (smallModel.yj_smallItemCount > 1 && !IsStrEmpty(smallModel.yj_smallIndex_Ori)) {
                NSInteger endIndex = [[smallModel.yj_smallIndex_Ori componentsSeparatedByString:@"|"].lastObject integerValue];
                if (endIndex == 0) {
                    answerCount = 0;
                    unAnswerCount = 0;
                }
                if (smallModel.yj_smallMarkAnswerScore.floatValue >= 0) {
                    if (endIndex <= smallModel.yj_smallItemCount - 1) {
                        answerCount++;
                        if (endIndex == smallModel.yj_smallItemCount - 1) {
                            if (answerCount == smallModel.yj_smallItemCount) {
                                [answers addObject:@(1)];
                                [indexs addObject:@(smallModel.yj_smallPaperIndex)];
                            }else{
                                [answers addObject:@(0)];
                                [indexs addObject:@(smallModel.yj_smallPaperIndex)];
                            }
                        }
                    }
                }else{
                   if (endIndex == smallModel.yj_smallItemCount - 1) {
                       if (IsStrEmpty(smallModel.yj_smallAnswer)) {
                           [answers addObject:@(1)];
                       }else{
                           [answers addObject:@(0)];
                       }
                       [indexs addObject:@(smallModel.yj_smallPaperIndex)];
                   }
                }
            }else{
                if (smallModel.yj_smallMarkAnswerScore.floatValue >= 0) {
                    [answers addObject:@(1)];
                    [indexs addObject:@(smallModel.yj_smallPaperIndex)];
                }else{
                    BOOL isUnAnswer = NO;
                    if (smallModel.yj_smallAnswerType != 4 && IsStrEmpty(smallModel.yj_smallAnswer)) {
                        isUnAnswer = YES;
                    }else if (smallModel.yj_smallAnswerType == 4 && IsStrEmpty(smallModel.yj_smallAnswer) && IsArrEmpty(smallModel.yj_imgUrlArr)){
                        isUnAnswer = YES;
                    }
                    if (isUnAnswer) {
                        [answers addObject:@(1)];
                    }else{
                        [answers addObject:@(0)];
                    }
                    [indexs addObject:@(smallModel.yj_smallPaperIndex)];
                }
            }
        }
        YJTaskCarkModel *model = [[YJTaskCarkModel alloc] init];
        model.topcTypeName = bigModel.yj_bigTopicTypeName;
        model.answerResults = answers;
        model.indexs = indexs;
        model.topicIndex = bigModel.yj_bigIndex;
        [dataArr addObject:model];
    }
    return dataArr;
    
}
- (void)updateMutiBlankScoreInfo{};
@end
