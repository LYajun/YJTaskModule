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
- (void)updateData{
    [self.tableView reloadData];
}
#pragma mark  UITableView dataSource & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
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
            if (!IsStrEmpty(self.smallModel.yj_smallAnswerAnalysis)) {
                return 5;
            }
            return 4;
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
        cell.textAttr = self.smallModel.yj_smallTopicAttrText;
        return cell;
    }else{
        NSIndexPath *indexP = [NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
        switch (self.smallModel.yj_smallTopicType) {
            case YJSmallTopicTypeChoice:
            case YJSmallTopicTypeMoreChoice:
            {
                if (indexP.row == self.smallModel.yj_smallOptions.count) {
                    YJAnaDetailChoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YJAnaDetailChoiceCell class]) forIndexPath:indexPath];
                    if (self.taskStageType == YJTaskStageTypeAnalysis) {
                        cell.isSubmit = YES;
                    }else{
                        cell.isSubmit = NO;
                    }
                    cell.smallModel = self.smallModel;
                    return cell;
                    
                }else{
                    YJTaskChoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YJTaskChoiceCell class]) forIndexPath:indexPath];
                    cell.textAttr = self.smallModel.yj_smallOptions[indexP.row];
                    cell.index = indexP.row;
                    if (!IsStrEmpty(self.smallModel.yj_smallAnswer)) {
                        NSInteger index = self.smallModel.yj_smallAnswer.yj_stringToASCIIInt-65;
                        if (index == indexP.row) {
                            cell.isRight = (self.smallModel.yj_smallAnswerScore.floatValue >= self.smallModel.yj_smallScore.floatValue*0.6);
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
                    if (!IsStrEmpty(self.smallModel.yj_smallAnswer)) {
                        cell.text = self.smallModel.yj_smallAnswer;
                    }else{
                        cell.text = @"未作答";
                    }
                }else if (indexP.row == 1){
                    cell.titleStr = @"参考答案";
                    cell.titleColor = LG_ColorWithHex(0x009E00);
                    NSString *standardAnswer = self.smallModel.yj_smallStandardAnswer;
                    if (!IsStrEmpty(standardAnswer)) {
                        standardAnswer = [standardAnswer stringByReplacingOccurrencesOfString:@"$/" withString:@"/"];
                    }
                    cell.text = standardAnswer;
                }else if (indexP.row == 2){
                    cell.titleStr = @"本题得分";
                    cell.titleColor = LG_ColorWithHex(0xFC0000);
                    if (!IsStrEmpty(self.smallModel.yj_smallAnswerScore) && self.smallModel.yj_smallAnswerScore.floatValue >= 0) {
                        cell.text = [self.smallModel.yj_smallAnswerScore stringByAppendingString:@"分"];
                    }else{
                        cell.text = @"暂无评阅结果";
                    }
                }else{
                    cell.titleStr = @"本题解析";
                    cell.titleColor = LG_ColorWithHex(0x333333);
                    cell.text = self.smallModel.yj_smallAnswerAnalysis;
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
                    cell.imgUrlArr = self.smallModel.yj_imgUrlArr;
                    cell.isAddBgColor = YES;
                    if (UserType == 1) {
                        cell.titleStr = @"学生答案";
                    }else{
                        cell.titleStr = @"我的答案";
                    }
                    cell.titleColor = LG_ColorThemeBlue;
                    if (!IsStrEmpty(self.smallModel.yj_smallAnswer)) {
                        cell.text = self.smallModel.yj_smallAnswer;
                    }else{
                        if (IsArrEmpty(self.smallModel.yj_imgUrlArr)) {
                            cell.text = @"未作答";
                        }else{
                            cell.isAddBgColor = NO;
                            cell.text = @"";
                        }
                    }
                }else if (indexP.row == 1){
                    cell.imgUrlArr = nil;
                    cell.titleStr = @"参考答案";
                    cell.titleColor = LG_ColorWithHex(0x009E00);
                    NSString *standardAnswer = self.smallModel.yj_smallStandardAnswer;
                    if (!IsStrEmpty(standardAnswer)) {
                        standardAnswer = [standardAnswer stringByReplacingOccurrencesOfString:@"$/" withString:@"/"];
                    }
                    cell.text = standardAnswer;
                }else if (indexP.row == 2){
                    cell.imgUrlArr = nil;
                    cell.titleStr = @"本题得分";
                    cell.titleColor = LG_ColorWithHex(0xFC0000);
                    if (!IsStrEmpty(self.smallModel.yj_smallAnswerScore) && self.smallModel.yj_smallAnswerScore.floatValue >= 0) {
                        cell.text = [self.smallModel.yj_smallAnswerScore stringByAppendingString:@"分"];
                    }else{
                        cell.text = @"暂无评阅结果";
                    }
                }else{
                    cell.imgUrlArr = nil;
                    cell.titleStr = @"本题解析";
                    cell.titleColor = LG_ColorWithHex(0x333333);
                    cell.text = self.smallModel.yj_smallAnswerAnalysis;
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
