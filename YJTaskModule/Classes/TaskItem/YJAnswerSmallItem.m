//
//  YJAnswerSmallItem.m
//  LGMultimediaFramework
//
//  Created by 刘亚军 on 2019/1/19.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "YJAnswerSmallItem.h"

#import <Masonry/Masonry.h>

#import "YJTaskTopicCell.h"
#import "YJTaskChoiceCell.h"
#import "YJTaskBlankCell.h"
#import "YJTaskAnswerView.h"
#import "YJTaskWrittingView.h"
#import "YJBasePaperModel.h"
#import "YJTaskTitleView.h"
#import "YJTaskWrittingCell.h"
#import "YJConst.h"

@interface YJAnswerSmallItem ()<UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) UITableView *tableView;
@property (nonatomic,strong) YJTaskTopicCell *currentTaskTopicCell;
@end
@implementation YJAnswerSmallItem
- (instancetype)initWithFrame:(CGRect)frame smallPModel:(YJBasePaperSmallModel *)smallPModel taskStageType:(YJTaskStageType)taskStageType{
    if (self = [super initWithFrame:frame smallPModel:smallPModel taskStageType:taskStageType]) {
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self);
            make.top.equalTo(self.titleView.mas_bottom);
        }];
    }
    return self;
}
- (void)updateData{
    [self.tableView reloadData];
}
- (void)stopVoicePlay{
    if (self.currentTaskTopicCell) {
        [self.currentTaskTopicCell invalidatePlayer];
    }
}
#pragma mark - UITableViewDelegate&&UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (self.smallModel.yj_smallTopicType) {
        case YJSmallTopicTypeChoice:
        case YJSmallTopicTypeMoreChoice:
            return self.smallModel.yj_smallOptions.count+1;
            break;
        case YJSmallTopicTypeBlank:
        case YJSmallTopicTypeSimpleAnswer:
        case YJSmallTopicTypeWritting:
        {
            if (!IsArrEmpty(self.smallModel.yj_smallQuesAskList)) {
                return self.smallModel.yj_smallQuesAskList.count + 1;
            }
            if (self.smallModel.yj_smallItemCount > 1) {
                return self.smallModel.yj_smallItemCount + 1;
            }
            return 2;
            
        }
            break;
        default:
            return 0;
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        YJTaskTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YJTaskTopicCell class]) forIndexPath:indexPath];
        cell.voiceUrl = self.smallModel.yj_smallTopicArticle;
        cell.textAttr = self.smallModel.yj_smallTopicAttrText;
        self.currentTaskTopicCell = cell;
        __weak typeof(self) weakSelf = self;
        cell.playBlock = ^{
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(YJ_taskTopicCellDidPlayVoice)]) {
                [weakSelf.delegate YJ_taskTopicCellDidPlayVoice];
            }
        };
        return cell;
    }else{
        NSIndexPath *indexP = [NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
        switch (self.smallModel.yj_smallTopicType) {
            case YJSmallTopicTypeChoice:
            case YJSmallTopicTypeMoreChoice:
            {
                YJTaskChoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YJTaskChoiceCell class]) forIndexPath:indexPath];
                cell.textAttr = self.smallModel.yj_smallOptions[indexP.row];
                cell.index = indexP.row;
                if (!IsStrEmpty(self.smallModel.yj_smallAnswer)) {
                    if (self.smallModel.yj_smallTopicType == YJSmallTopicTypeMoreChoice) {
                        NSMutableArray *indexArr = [NSMutableArray array];
                        for (int i = 0; i < self.smallModel.yj_smallAnswer.length; i++) {
                            NSString *answerStr = [self.smallModel.yj_smallAnswer substringWithRange:NSMakeRange(i, 1)];
                            NSInteger index = answerStr.yj_stringToASCIIInt-65;
                            [indexArr addObject:@(index)];
                        }
                        if ([indexArr containsObject:@(indexP.row)]) {
                            cell.isChoiced = YES;
                        }else{
                            cell.isChoiced = NO;
                        }
                    }else{
                        NSInteger index = self.smallModel.yj_smallAnswer.yj_stringToASCIIInt-65;
                        if (index == indexP.row) {
                            cell.isChoiced = YES;
                        }else{
                            cell.isChoiced = NO;
                        }
                    }
                }else{
                    cell.isChoiced = NO;
                }
               
                return cell;
            }
                break;
            case YJSmallTopicTypeBlank:
            case YJSmallTopicTypeSimpleAnswer:
            {
                YJTaskBlankCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YJTaskBlankCell class]) forIndexPath:indexPath];
                cell.index = -1;
                if (self.smallModel.yj_smallItemCount > 1) {
                    cell.index = indexP.row;
                    YJBasePaperSmallModel *smallModel = self.smallModel;
                    if (!IsStrEmpty(smallModel.yj_smallIndex_Ori)) {
                       
                        smallModel = (YJBasePaperSmallModel *)[self.bigModel.yj_smallTopicList yj_objectAtIndex:(indexP.row + smallModel.yj_smallIndex)];
                        
                    }
                    cell.answerStr = smallModel.yj_smallAnswer;
                }else if (!IsArrEmpty(self.smallModel.yj_smallQuesAskList)){
                    cell.index = indexP.row;
                    if (IsStrEmpty(self.smallModel.yj_smallAnswer)) {
                        cell.answerStr = @"";
                    }else{
                        NSArray *answerStrList = [self.smallModel.yj_smallAnswer componentsSeparatedByString:YJTaskModule_u2060];
                        if (indexP.row <= answerStrList.count - 1) {
                            cell.answerStr = answerStrList[indexP.row];
                        }else{
                           cell.answerStr = @"";
                        }
                    }
                }else{
                    cell.answerStr = self.smallModel.yj_smallAnswer;
                }
                if (self.taskStageType == YJTaskStageTypeViewer) {
                    cell.editable = NO;
                }else{
                    cell.editable = YES;
                }
                __weak typeof(self) weakSelf = self;
                cell.SpeechMarkBlock = ^{
                    weakSelf.currentSmallIndex = indexP.row;
                };
                cell.hideSpeechBtn = self.smallModel.yj_hideSpeechBtn;
                return cell;
            }
                break;
            case YJSmallTopicTypeWritting:
            {
                YJTaskWrittingCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YJTaskWrittingCell class]) forIndexPath:indexPath];
                cell.topicIndex = -1;
                if (self.taskStageType == YJTaskStageTypeViewer) {
                    cell.editable = NO;
                }else{
                    cell.editable = YES;
                }
                cell.smallModel = self.smallModel;
                cell.answerStr = self.smallModel.yj_smallAnswer;
                cell.hideSpeechBtn = self.smallModel.yj_hideSpeechBtn;
                return cell;
            }
                break;
            default:
                return nil;
                break;
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row > 0 && self.taskStageType != YJTaskStageTypeViewer) {
        [NSUserDefaults yj_setObject:@(YES) forKey:UserDefaults_YJAnswerStatusChanged];
        switch (self.smallModel.yj_smallTopicType) {
            case YJSmallTopicTypeChoice:
            {
                for (int i = 0; i < self.smallModel.yj_smallOptions.count; i++) {
                    YJTaskChoiceCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i+1 inSection:indexPath.section]];
                    if (i == (indexPath.row - 1)) {
                        cell.isChoiced = YES;
                        if (IsStrEmpty(self.smallModel.yj_smallAnswer)) {
                            if (self.delegate && [self.delegate respondsToSelector:@selector(YJ_choiceTopicDidAnswer)]) {
                                [self.delegate YJ_choiceTopicDidAnswer];
                            }
                        }
                        self.smallModel.yj_smallAnswer = [NSString yj_stringToASCIIStringWithIntCount:i+65];
                    }else{
                        cell.isChoiced = NO;
                    }
                }
                if (self.delegate && [self.delegate respondsToSelector:@selector(YJ_blankAnswerUpdate)]) {
                    [self.delegate YJ_blankAnswerUpdate];
                }
            }
                break;
            case YJSmallTopicTypeMoreChoice:
            {
                YJTaskChoiceCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                cell.isChoiced = !cell.isChoiced;
                NSMutableArray *smallAnswerArr = nil;
                if (IsArrEmpty(self.smallModel.yj_smallAnswerArr)) {
                    smallAnswerArr = [NSMutableArray array];
                    for (int i = 0; i < self.smallModel.yj_smallOptions.count; i++) {
                        [smallAnswerArr addObject:@""];
                    }
                    if (!IsStrEmpty(self.smallModel.yj_smallAnswer)) {
                        for (int i = 0; i < self.smallModel.yj_smallAnswer.length; i++) {
                            NSString *answerStr = [self.smallModel.yj_smallAnswer substringWithRange:NSMakeRange(i, 1)];
                            NSInteger index = answerStr.yj_stringToASCIIInt-65;
                            [smallAnswerArr replaceObjectAtIndex:index withObject:answerStr];
                        }
                    }
                }else{
                    smallAnswerArr = self.smallModel.yj_smallAnswerArr.mutableCopy;
                }
                if (cell.isChoiced) {
                    [smallAnswerArr replaceObjectAtIndex:indexPath.row-1 withObject:[NSString yj_stringToASCIIStringWithIntCount:indexPath.row-1+65]];
                }else{
                    [smallAnswerArr replaceObjectAtIndex:indexPath.row-1 withObject:@""];
                }
                NSString *answerStr = @"";
                for (NSString *str in smallAnswerArr) {
                    if (!IsStrEmpty(str)) {
                        answerStr = [answerStr stringByAppendingString:str];
                    }
                }
                self.smallModel.yj_smallAnswer = answerStr;
                self.smallModel.yj_smallAnswerArr = smallAnswerArr;
                
            }
                break;
            case YJSmallTopicTypeBlank:
            case YJSmallTopicTypeSimpleAnswer:
            {
                if (!IsArrEmpty(self.smallModel.yj_smallQuesAskList)) {
                   __weak typeof(self) weakSelf = self;
                    NSString *answerStr = @"";
                    NSInteger index = indexPath.row - 1;
                    if (!IsStrEmpty(self.smallModel.yj_smallAnswer)) {
                        NSArray *answerStrList = [self.smallModel.yj_smallAnswer componentsSeparatedByString:YJTaskModule_u2060];
                        if (index <= answerStrList.count - 1) {
                            answerStr = answerStrList[index];
                        }
                    }
                   YJTaskWrittingView *answerView = [YJTaskWrittingView showWithText:answerStr answerResultBlock:^(NSString *result) {
                        [weakSelf.smallModel updateSmallAnswerStr:result atIndex:index];
                        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(YJ_blankAnswerUpdate)]) {
                            [weakSelf.delegate YJ_blankAnswerUpdate];
                        }
                        [weakSelf.tableView reloadData];
                    }];
                    NSString *quesAskStr = [self.smallModel.yj_smallQuesAskList yj_objectAtIndex:index];
                    answerView.topicInfoAttr = quesAskStr.yj_toMutableAttributedString;
                    answerView.titleStr = [NSString stringWithFormat:@"%@-%@",self.smallModel.yj_bigTopicTypeName,[NSString yj_stringToSmallTopicIndexStringWithIntCount:index]];
                }else{
                    if (self.smallModel.yj_translateTopic && !IsIPad) {
                        __weak typeof(self) weakSelf = self;
                        YJTaskWrittingView *answerView = [YJTaskWrittingView showWithText:self.smallModel.yj_smallAnswer answerResultBlock:^(NSString *result) {
                            weakSelf.smallModel.yj_smallAnswer = result;
                            [weakSelf.tableView reloadData];
                        }];
                        answerView.topicInfoAttr = self.smallModel.yj_smallTopicAttrText;
                        answerView.titleStr = self.smallModel.yj_bigTopicTypeName;
                    }else{
                        __weak typeof(self) weakSelf = self;
                        if (self.smallModel.yj_smallItemCount > 1) {
                            NSInteger index = indexPath.row - 1;
                            YJBasePaperSmallModel *smallModel = self.smallModel;
                            if (!IsStrEmpty(smallModel.yj_smallIndex_Ori)) {
                                smallModel = (YJBasePaperSmallModel *)[self.bigModel.yj_smallTopicList yj_objectAtIndex:(index + smallModel.yj_smallIndex)];
                            }
                            [YJTaskAnswerView showWithText:smallModel.yj_smallAnswer answerResultBlock:^(NSString *result) {
                                smallModel.yj_smallAnswer = result;
                                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(YJ_blankAnswerUpdate)]) {
                                    [weakSelf.delegate YJ_blankAnswerUpdate];
                                }
                                [weakSelf.tableView reloadData];
                            }];
                            
                        }else{
                            [YJTaskAnswerView showWithText:self.smallModel.yj_smallAnswer answerResultBlock:^(NSString *result) {
                                weakSelf.smallModel.yj_smallAnswer = result;
                                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(YJ_blankAnswerUpdate)]) {
                                    [weakSelf.delegate YJ_blankAnswerUpdate];
                                }
                                [weakSelf.tableView reloadData];
                            }];
                        }
                    }
                    
                }
            }
                break;
            case YJSmallTopicTypeWritting:
            {
                __weak typeof(self) weakSelf = self;
                YJTaskWrittingView *answerView = [YJTaskWrittingView showWithText:self.smallModel.yj_smallAnswer answerResultBlock:^(NSString *result) {
                    weakSelf.smallModel.yj_smallAnswer = result;
                    [weakSelf.tableView reloadData];
                }];
                answerView.topicInfoAttr = self.smallModel.yj_smallTopicAttrText;
                answerView.titleStr = self.smallModel.yj_bigTopicTypeName;
            }
                break;
            default:
                break;
        }
    }
}
#pragma mark - Getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[YJTaskTopicCell class] forCellReuseIdentifier:NSStringFromClass([YJTaskTopicCell class])];
        [_tableView registerClass:[YJTaskChoiceCell class] forCellReuseIdentifier:NSStringFromClass([YJTaskChoiceCell class])];
        [_tableView registerClass:[YJTaskBlankCell class] forCellReuseIdentifier:NSStringFromClass([YJTaskBlankCell class])];
        [_tableView registerClass:[YJTaskWrittingCell class] forCellReuseIdentifier:NSStringFromClass([YJTaskWrittingCell class])];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 100;
    }
    return _tableView;
}
@end
