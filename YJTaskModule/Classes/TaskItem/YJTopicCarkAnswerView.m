//
//  YJTopicCarkAnswerView.m
//  LGEducationCloud
//
//  Created by 刘亚军 on 2018/5/14.
//  Copyright © 2018年 lange. All rights reserved.
//

#import "YJTopicCarkAnswerView.h"
#import "YJTopicCarkChoiceAnswerCell.h"
#import "YJTopicCardBlankAnswerCell.h"
#import "YJTaskAnswerView.h"
#import "YJTaskWrittingView.h"
#import "YJTaskWrittingCell.h"
#import <Masonry/Masonry.h>
#import "YJConst.h"

@interface YJTopicCarkAnswerView ()<UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) UITableView *tableView;
@end
@implementation YJTopicCarkAnswerView
- (instancetype)initWithFrame:(CGRect)frame bigTopicASPModel:(YJBasePaperBigModel *)bigTopicASPModel taskStageType:(YJTaskStageType)taskStageType{
    if (self = [super initWithFrame:frame bigTopicASPModel:bigTopicASPModel taskStageType:taskStageType]) {
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.bigModel.yj_smallTopicList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YJBasePaperSmallModel *firstSmallModel = (YJBasePaperSmallModel *)self.bigModel.yj_smallTopicList.firstObject;
    YJBasePaperSmallModel *smallModel = (YJBasePaperSmallModel *)self.bigModel.yj_smallTopicList[indexPath.row];
    switch (firstSmallModel.yj_smallTopicType) {
        case YJSmallTopicTypeChoice:
        case YJSmallTopicTypeMoreChoice:
        {
            if (firstSmallModel.yj_smallAnswerType == 32) {
                YJTopicCardBlankAnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YJTopicCardBlankAnswerCell class]) forIndexPath:indexPath];
                cell.answer = smallModel.yj_smallAnswer;
                cell.topicIndex = smallModel.yj_smallPaperIndex;
                if (self.taskStageType == YJTaskStageTypeViewer) {
                    cell.presentEnable = NO;
                }else{
                    cell.presentEnable = YES;
                }
                return cell;
            }else{
                YJTopicCarkChoiceAnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YJTopicCarkChoiceAnswerCell class]) forIndexPath:indexPath];
                cell.topicCount = 4;
                cell.topicIndex = smallModel.yj_smallPaperIndex;
                cell.answer = smallModel.yj_smallAnswer;
                if (self.taskStageType == YJTaskStageTypeViewer ) {
                    cell.userInteractionEnabled = NO;
                }else{
                    cell.userInteractionEnabled = YES;
                }
                cell.answerResultBlock = ^(NSString *result) {
                    smallModel.yj_smallAnswer = result;
                    [NSUserDefaults yj_setObject:@(YES) forKey:UserDefaults_YJAnswerStatusChanged];
                };
                return cell;
            }
        }
            break;
        case YJSmallTopicTypeBlank:
        case YJSmallTopicTypeSimpleAnswer:
        {
            YJTopicCardBlankAnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YJTopicCardBlankAnswerCell class]) forIndexPath:indexPath];
            cell.answer = smallModel.yj_smallAnswer;
            cell.topicIndex = smallModel.yj_smallPaperIndex;
            if (self.taskStageType == YJTaskStageTypeViewer ) {
                cell.presentEnable = NO;
            }else{
                cell.presentEnable = YES;
            }
            __weak typeof(self) weakSelf = self;
            cell.SpeechMarkBlock = ^{
                weakSelf.currentSmallIndex = indexPath.row;
            };
            return cell;
        }
            break;
        case YJSmallTopicTypeWritting:
        {
            YJTaskWrittingCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YJTaskWrittingCell class]) forIndexPath:indexPath];
            cell.topicIndex = smallModel.yj_smallPaperIndex;
            if (self.taskStageType == YJTaskStageTypeViewer) {
                cell.editable = NO;
            }else{
                cell.editable = YES;
            }
            cell.smallModel = smallModel;
            cell.answerStr = smallModel.yj_smallAnswer;
            __weak typeof(self) weakSelf = self;
            cell.SpeechMarkBlock = ^{
                weakSelf.currentSmallIndex = indexPath.row;
            };
            return cell;
        }
            break;
        default:
            return nil;
            break;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YJBasePaperSmallModel *firstSmallModel = (YJBasePaperSmallModel *)self.bigModel.yj_smallTopicList.firstObject;
    YJBasePaperSmallModel *smallModel = (YJBasePaperSmallModel *)self.bigModel.yj_smallTopicList[indexPath.row];
    __weak typeof(self) weakSelf = self;
    if (self.taskStageType != YJTaskStageTypeViewer) {
         [NSUserDefaults yj_setObject:@(YES) forKey:UserDefaults_YJAnswerStatusChanged];
        switch (firstSmallModel.yj_smallTopicType) {
            case YJSmallTopicTypeChoice:
            case YJSmallTopicTypeMoreChoice:
            {
                if (firstSmallModel.yj_smallAnswerType == 32) {
                    [YJTaskAnswerView showWithText:smallModel.yj_smallAnswer answerResultBlock:^(NSString *result) {
//                        YJTopicCardBlankAnswerCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//                        cell.answer = result;
                        smallModel.yj_smallAnswer = result;
                        [weakSelf.tableView reloadData];
                    }];
                }
            }
                break;
            case YJSmallTopicTypeBlank:
            case YJSmallTopicTypeSimpleAnswer:
            case YJSmallTopicTypeWritting:
            {
                [YJTaskAnswerView showWithText:smallModel.yj_smallAnswer answerResultBlock:^(NSString *result) {
//                    YJTopicCardBlankAnswerCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//                    cell.answer = result;
                    smallModel.yj_smallAnswer = result;
                    [weakSelf.tableView reloadData];
                }];
            }
                break;
//            case YJSmallTopicTypeWritting:
//            {
//               YJTaskWrittingView *answerView = [YJTaskWrittingView showWithText:smallModel.yj_smallAnswer answerResultBlock:^(NSString *result) {
////                    YJTopicCardBlankAnswerCell *cell = [tableView cellForRowAtIndexPath:indexPath];
////                    cell.answer = result;
//                    smallModel.yj_smallAnswer = result;
//                    [weakSelf.tableView reloadData];
//                }];
//                answerView.isTopicCard = YES;
//            }
//                break;
            default:
                break;
        }
    }
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[YJTopicCarkChoiceAnswerCell class] forCellReuseIdentifier:NSStringFromClass([YJTopicCarkChoiceAnswerCell class])];
        [_tableView registerClass:[YJTopicCardBlankAnswerCell class] forCellReuseIdentifier:NSStringFromClass([YJTopicCardBlankAnswerCell class])];
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
