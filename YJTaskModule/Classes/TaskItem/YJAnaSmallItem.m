//
//  YJAnaSmallItem.m
//  LGEducationCloud
//
//  Created by 刘亚军 on 2017/9/22.
//  Copyright © 2017年 lange. All rights reserved.
//

#import "YJAnaSmallItem.h"
#import "YJAnaDetailChoiceCell.h"
#import "YJTaskTopicCell.h"
#import "YJMarkObjCell.h"
#import "YJMarkSubCell.h"
#import "YJTaskChoiceCell.h"
#import "YJTaskTitleView.h"
#import "YJBasePaperModel.h"
#import <Masonry/Masonry.h>
#import "YJConst.h"

#pragma mark - YJAnaTeachSmallItem
@interface YJAnaTeachSmallItem ()

@end

@implementation YJAnaTeachSmallItem
- (void)configAnalysisInfo{
    [self.analysisArr removeAllObjects];
    self.analysisMutiBlankRowCount = 0;
    if (!IsStrEmpty(self.smallModel.yj_smallAnswerAnalysis)) {
        self.analysisMutiBlankRowCount++;
        [self.analysisArr addObject:@{@"title":@"本题解析",@"color":LG_ColorWithHex(0x333333),@"text":self.smallModel.yj_smallAnswerAnalysis}];
    }
    if (self.isShowKlgInfo) {
        if (!IsStrEmpty(self.bigModel.yj_topicImpKlgInfo)) {
            [self.analysisArr addObject:@{@"title":@"重要考点",@"color":LG_ColorWithHex(0xff6600),@"text":self.bigModel.yj_topicImpKlgInfo}];
        }
        if (!IsStrEmpty(self.bigModel.yj_topicMainKlgInfo)) {
            [self.analysisArr addObject:@{@"title":@"次重要考点",@"color":LG_ColorWithHex(0x333333),@"text":self.bigModel.yj_topicMainKlgInfo}];
        }
    }
    
}
#pragma mark  UITableView dataSource & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.smallModel.yj_smallItemCount > 1) {
        return self.smallModel.yj_smallItemCount;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (self.smallModel.yj_smallTopicType) {
        case YJSmallTopicTypeChoice:
        case YJSmallTopicTypeMoreChoice:
            return self.smallModel.yj_smallOptions.count + 2 + self.analysisArr.count;
            break;
        case YJSmallTopicTypeBlank:
        case YJSmallTopicTypeSimpleAnswer:
        case YJSmallTopicTypeWritting:
        {
            if (self.smallModel.yj_smallItemCount > 1 && section == 0) {
                return 2 + self.analysisMutiBlankRowCount;
            }else{
                return 2 + self.analysisArr.count;
            }
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
        if (self.smallModel.yj_smallItemCount > 1) {
            if (indexPath.section == 0) {
                NSMutableAttributedString *attr = self.smallModel.yj_smallTopicAttrText.mutableCopy;
                NSMutableAttributedString *indexAttr = [NSString stringWithFormat:@"\n\n%@:\n",[NSString yj_stringToSmallTopicIndexStringWithIntCount:indexPath.section]].yj_toMutableAttributedString;
                [attr appendAttributedString:indexAttr];
                cell.textAttr = attr;
            }else{
                cell.textAttr = [NSString stringWithFormat:@"%@:",[NSString yj_stringToSmallTopicIndexStringWithIntCount:indexPath.section]].yj_toMutableAttributedString;
            }
        }else{
            cell.textAttr = self.smallModel.yj_smallTopicAttrText;
        }
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
        YJBasePaperSmallModel *smallModel = self.smallModel;
        if (indexPath.section > 0) {
            if (!IsStrEmpty(smallModel.yj_smallIndex_Ori)) {
                smallModel = (YJBasePaperSmallModel *)[self.bigModel.yj_smallTopicList yj_objectAtIndex:(indexP.section + smallModel.yj_smallIndex)];
                
            }
        }
        switch (smallModel.yj_smallTopicType) {
            case YJSmallTopicTypeChoice:
            case YJSmallTopicTypeMoreChoice:
            {
                if (indexP.row >= smallModel.yj_smallOptions.count) {
                    NSInteger choiceAnaIndex = indexP.row - smallModel.yj_smallOptions.count;
                    YJMarkObjCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YJMarkObjCell class]) forIndexPath:indexPath];
                    cell.isAddBgColor = NO;
                    if (choiceAnaIndex == 0){
                        cell.titleStr = @"参考答案";
                        cell.titleColor = LG_ColorWithHex(0x009900);
                        cell.text = [smallModel.yj_smallStandardAnswer stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    }else{
                        NSInteger analysisIndex = choiceAnaIndex - 1;
                        NSDictionary *analysisDic = [self.analysisArr yj_objectAtIndex:analysisIndex];
                        cell.titleStr = [analysisDic objectForKey:@"title"];
                        cell.titleColor = [analysisDic objectForKey:@"color"];
                        cell.text = [analysisDic objectForKey:@"text"];
                    }
                    return cell;
                    
                }else{
                    YJTaskChoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YJTaskChoiceCell class]) forIndexPath:indexPath];
                    cell.textAttr = smallModel.yj_smallOptions[indexP.row];
                    cell.index = indexP.row;
                    cell.isChoiced = NO;
                    cell.userInteractionEnabled = NO;
                    return cell;
                }
            }
                break;
            case YJSmallTopicTypeBlank:
            {
                YJMarkObjCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YJMarkObjCell class]) forIndexPath:indexPath];
                cell.isAddBgColor = NO;
                if (indexP.row == 0){
                    cell.titleStr = @"参考答案";
                    cell.titleColor = LG_ColorWithHex(0x009900);
                    NSString *standardAnswer = smallModel.yj_smallStandardAnswer;
                    if (!IsStrEmpty(standardAnswer)) {
                        standardAnswer = [standardAnswer stringByReplacingOccurrencesOfString:@"$/" withString:@"/"];
                    }
                    cell.text = standardAnswer;
                }else{
                    NSInteger analysisIndex = indexP.row - 1;
                    NSDictionary *analysisDic = [self.analysisArr yj_objectAtIndex:analysisIndex];
                    cell.titleStr = [analysisDic objectForKey:@"title"];
                    cell.titleColor = [analysisDic objectForKey:@"color"];
                    cell.text = [analysisDic objectForKey:@"text"];
                }
                return cell;
            }
                break;
            case YJSmallTopicTypeSimpleAnswer:
            case YJSmallTopicTypeWritting:
            {
                YJMarkSubCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YJMarkSubCell class]) forIndexPath:indexPath];
                cell.isAddBgColor = NO;
                if (indexP.row == 0){
                    cell.imgUrlArr = nil;
                    cell.titleStr = @"参考答案";
                    cell.titleColor = LG_ColorWithHex(0x009900);
                    NSString *standardAnswer = smallModel.yj_smallStandardAnswer;
                    if (!IsStrEmpty(standardAnswer)) {
                        standardAnswer = [standardAnswer stringByReplacingOccurrencesOfString:@"$/" withString:@"/"];
                    }
                    cell.text = standardAnswer;
                }else{
                    cell.imgUrlArr = nil;
                    NSInteger analysisIndex = indexP.row - 1;
                    NSDictionary *analysisDic = [self.analysisArr yj_objectAtIndex:analysisIndex];
                    cell.titleStr = [analysisDic objectForKey:@"title"];
                    cell.titleColor = [analysisDic objectForKey:@"color"];
                    cell.text = [analysisDic objectForKey:@"text"];
                }
                return cell;
            }
                break;
            default:
                return nil;
                break;
        }
    }
}

@end

#pragma mark - YJAnaSmallItem

@interface YJAnaSmallItem ()<UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) UITableView *tableView;

@end
@implementation YJAnaSmallItem
- (instancetype)initWithFrame:(CGRect)frame smallPModel:(YJBasePaperSmallModel *)smallPModel taskStageType:(YJTaskStageType)taskStageType{
    if (self = [super initWithFrame:frame smallPModel:smallPModel taskStageType:taskStageType]) {
        self.taskStageType = taskStageType;
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self);
            make.top.equalTo(self.titleView.mas_bottom);
        }];
    }
    return self;
}
- (NSMutableArray *)analysisArr{
    if (!_analysisArr) {
        _analysisArr = [NSMutableArray array];
    }
    return _analysisArr;
}
- (void)configAnalysisInfo{
    [self.analysisArr removeAllObjects];
    self.analysisMutiBlankRowCount = 0;
    if (self.smallModel.yj_smallAnswerType == 2 || self.smallModel.yj_smallAnswerType == 4) {
        if (!IsStrEmpty(self.smallModel.yj_smallComment)) {
            self.analysisMutiBlankRowCount++;
            [self.analysisArr addObject:@{@"title":@"本题评语",@"color":LG_ColorWithHex(0x333333),@"text":self.smallModel.yj_smallComment}];
        }
        if (!IsStrEmpty(self.smallModel.yj_smallAnswerAnalysis)) {
            self.analysisMutiBlankRowCount++;
            [self.analysisArr addObject:@{@"title":@"本题解析",@"color":LG_ColorWithHex(0x333333),@"text":self.smallModel.yj_smallAnswerAnalysis}];
        }
        if (self.isShowKlgInfo) {
            if (!IsStrEmpty(self.bigModel.yj_topicImpKlgInfo)) {
                [self.analysisArr addObject:@{@"title":@"重要考点",@"color":LG_ColorWithHex(0xff6600),@"text":self.bigModel.yj_topicImpKlgInfo}];
            }
            if (!IsStrEmpty(self.bigModel.yj_topicMainKlgInfo)) {
                [self.analysisArr addObject:@{@"title":@"次重要考点",@"color":LG_ColorWithHex(0x333333),@"text":self.bigModel.yj_topicMainKlgInfo}];
            }
        }
    }
    
}
- (void)setBigModel:(YJBasePaperBigModel *)bigModel{
    [super setBigModel:bigModel];
    [self configAnalysisInfo];
}
- (void)updateData{
    [self.tableView reloadData];
}
- (void)stopVoicePlay{
    if (self.currentTaskTopicCell) {
        [self.currentTaskTopicCell invalidatePlayer];
    }
}
- (BOOL)isShowKlgInfo{
    BOOL isShow = NO;
    if (self.bigModel.yj_showTopicKlgInfo && self.lastSmallItem) {
        isShow = YES;
    }
    return isShow;
}
#pragma mark  UITableView dataSource & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.smallModel.yj_smallItemCount > 1) {
        return self.smallModel.yj_smallItemCount;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (self.smallModel.yj_smallTopicType) {
        case YJSmallTopicTypeChoice:
        case YJSmallTopicTypeMoreChoice:
            return self.smallModel.yj_smallOptions.count+2;
            break;
        case YJSmallTopicTypeBlank:
        case YJSmallTopicTypeSimpleAnswer:
        case YJSmallTopicTypeWritting:
        {
            if (self.smallModel.yj_smallItemCount > 1 && section == 0) {
                return 4 + self.analysisMutiBlankRowCount;
            }else{
                return 4 + self.analysisArr.count;
            }
        }
            break;
        default:
            return 0;
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger UserType = [NSUserDefaults yj_integerForKey:YJTaskModule_UserType_UserDefault_Key];
    if (indexPath.row == 0) {
        YJTaskTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YJTaskTopicCell class]) forIndexPath:indexPath];
        cell.voiceUrl = self.smallModel.yj_smallTopicArticle;
        if (self.smallModel.yj_smallItemCount > 1) {
            if (indexPath.section == 0) {
                NSMutableAttributedString *attr = self.smallModel.yj_smallTopicAttrText.mutableCopy;
                NSMutableAttributedString *indexAttr = [NSString stringWithFormat:@"\n\n%@:\n",[NSString yj_stringToSmallTopicIndexStringWithIntCount:indexPath.section]].yj_toMutableAttributedString;
                [attr appendAttributedString:indexAttr];
                cell.textAttr = attr;
            }else{
                cell.textAttr = [NSString stringWithFormat:@"%@:",[NSString yj_stringToSmallTopicIndexStringWithIntCount:indexPath.section]].yj_toMutableAttributedString;
            }
        }else{
            cell.textAttr = self.smallModel.yj_smallTopicAttrText;
        }
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
        YJBasePaperSmallModel *smallModel = self.smallModel;
        if (indexPath.section > 0) {
            if (!IsStrEmpty(smallModel.yj_smallIndex_Ori)) {
                smallModel = (YJBasePaperSmallModel *)[self.bigModel.yj_smallTopicList yj_objectAtIndex:(indexP.section + smallModel.yj_smallIndex)];
            }
        }
        switch (smallModel.yj_smallTopicType) {
            case YJSmallTopicTypeChoice:
            case YJSmallTopicTypeMoreChoice:
            {
                if (indexP.row == smallModel.yj_smallOptions.count) {
                    YJAnaDetailChoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YJAnaDetailChoiceCell class]) forIndexPath:indexPath];
                    if (self.taskStageType == YJTaskStageTypeAnalysis) {
                        cell.isSubmit = YES;
                    }else{
                        cell.isSubmit = NO;
                    }
                    cell.smallModel = smallModel;
                    if (self.isShowKlgInfo) {
                        cell.impKnText = self.bigModel.yj_topicImpKlgInfo;
                        cell.mainKnText = self.bigModel.yj_topicMainKlgInfo;
                    }
                    return cell;
                    
                }else{
                    YJTaskChoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YJTaskChoiceCell class]) forIndexPath:indexPath];
                    cell.textAttr = smallModel.yj_smallOptions[indexP.row];
                    cell.index = indexP.row;
                    if (!IsStrEmpty(smallModel.yj_smallAnswer)) {
                        NSInteger index = smallModel.yj_smallAnswer.yj_stringToASCIIInt-65;
                        if (index == indexP.row) {
                            cell.isRight = (smallModel.yj_smallAnswerScore.floatValue >= smallModel.yj_smallScore.floatValue*0.6);
                        }else{
                            cell.isChoiced = NO;
                        }
                    }else{
                        cell.isChoiced = NO;
                    }
                    
                    cell.userInteractionEnabled = NO;
                    return cell;
                }
            }
                break;
            case YJSmallTopicTypeBlank:
            {
                YJMarkObjCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YJMarkObjCell class]) forIndexPath:indexPath];
                cell.isAddBgColor = NO;
                if (indexP.row == 0) {
                    cell.isAddBgColor = YES;
                    
                    if (UserType == 1) {
                        cell.titleStr = @"学生答案";
                    }else{
                        cell.titleStr = @"我的答案";
                    }
                    cell.titleColor = LG_ColorThemeBlue;
                    if (!IsStrEmpty(smallModel.yj_smallAnswer)) {
                        cell.text = smallModel.yj_smallAnswer;
                    }else{
                        cell.text = @"未作答";
                    }
                }else if (indexP.row == 1){
                    cell.titleStr = @"参考答案";
                    cell.titleColor = LG_ColorWithHex(0x009900);
                    NSString *standardAnswer = smallModel.yj_smallStandardAnswer;
                    if (!IsStrEmpty(standardAnswer)) {
                        standardAnswer = [standardAnswer stringByReplacingOccurrencesOfString:@"$/" withString:@"/"];
                    }
                    cell.text = standardAnswer;
                }else if (indexP.row == 2){
                    cell.titleStr = @"本题得分";
                    cell.titleColor = LG_ColorWithHex(0xFF0000);
                    if (!IsStrEmpty(smallModel.yj_smallAnswerScore) && smallModel.yj_smallAnswerScore.floatValue >= 0) {
                        cell.text = [smallModel.yj_smallAnswerScore stringByAppendingString:@"分"];
                    }else{
                        cell.text = @"暂无评阅结果";
                    }
                }else{
                    NSInteger analysisIndex = indexP.row - 3;
                    NSDictionary *analysisDic = [self.analysisArr yj_objectAtIndex:analysisIndex];
                    cell.titleStr = [analysisDic objectForKey:@"title"];
                    cell.titleColor = [analysisDic objectForKey:@"color"];
                    cell.text = [analysisDic objectForKey:@"text"];
                }
                return cell;
            }
                break;
            case YJSmallTopicTypeSimpleAnswer:
            case YJSmallTopicTypeWritting:
            {
                YJMarkSubCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YJMarkSubCell class]) forIndexPath:indexPath];
                cell.isAddBgColor = NO;
                if (indexP.row == 0) {
                    cell.imgUrlArr = smallModel.yj_imgUrlArr;
                    cell.isAddBgColor = YES;
                    if (UserType == 1) {
                        cell.titleStr = @"学生答案";
                    }else{
                        cell.titleStr = @"我的答案";
                    }
                    cell.titleColor = LG_ColorThemeBlue;
                    if (!IsStrEmpty(smallModel.yj_smallAnswer)) {
                        cell.text = smallModel.yj_smallAnswer;
                    }else{
                        if (IsArrEmpty(smallModel.yj_imgUrlArr)) {
                            cell.text = @"未作答";
                        }else{
                            cell.isAddBgColor = NO;
                            cell.text = @"";
                        }
                    }
                }else if (indexP.row == 1){
                    cell.imgUrlArr = nil;
                    cell.titleStr = @"参考答案";
                    cell.titleColor = LG_ColorWithHex(0x009900);
                    NSString *standardAnswer = smallModel.yj_smallStandardAnswer;
                    if (!IsStrEmpty(standardAnswer)) {
                        standardAnswer = [standardAnswer stringByReplacingOccurrencesOfString:@"$/" withString:@"/"];
                    }
                    cell.text = standardAnswer;
                }else if (indexP.row == 2){
                    cell.imgUrlArr = nil;
                    cell.titleStr = @"本题得分";
                    cell.titleColor = LG_ColorWithHex(0xFF0000);
                    if (!IsStrEmpty(smallModel.yj_smallAnswerScore) && self.smallModel.yj_smallAnswerScore.floatValue >= 0) {
                        cell.text = [smallModel.yj_smallAnswerScore stringByAppendingString:@"分"];
                    }else{
                        cell.text = @"暂无评阅结果";
                    }
                }else{
                    cell.imgUrlArr = nil;
                    NSInteger analysisIndex = indexP.row - 3;
                    NSDictionary *analysisDic = [self.analysisArr yj_objectAtIndex:analysisIndex];
                    cell.titleStr = [analysisDic objectForKey:@"title"];
                    cell.titleColor = [analysisDic objectForKey:@"color"];
                    cell.text = [analysisDic objectForKey:@"text"];
                }
                return cell;
            }
                break;
            default:
                return nil;
                break;
        }
    }
}
#pragma mark Property init

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[YJTaskTopicCell class] forCellReuseIdentifier:NSStringFromClass([YJTaskTopicCell class])];
        [_tableView registerClass:[YJTaskChoiceCell class] forCellReuseIdentifier:NSStringFromClass([YJTaskChoiceCell class])];
        [_tableView registerClass:[YJMarkObjCell class] forCellReuseIdentifier:NSStringFromClass([YJMarkObjCell class])];
        [_tableView registerClass:[YJMarkSubCell class] forCellReuseIdentifier:NSStringFromClass([YJMarkSubCell class])];
        [_tableView registerClass:[YJAnaDetailChoiceCell class] forCellReuseIdentifier:NSStringFromClass([YJAnaDetailChoiceCell class])];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 100;
    }
    return _tableView;
}

@end
