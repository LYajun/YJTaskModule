//
//  YJTopicCarkAnalysisView.m
//  LGEducationCloud
//
//  Created by 刘亚军 on 2018/5/25.
//  Copyright © 2018年 lange. All rights reserved.
//

#import "YJTopicCarkAnalysisView.h"
#import "YJMarkSubCell.h"
#import "YJMarkObjCell.h"
#import "YJAnaDetailChoiceCell.h"
#import "YJTaskTopicCell.h"
#import <Masonry/Masonry.h>
#import "YJConst.h"

@interface YJTopicCarkAnalysisView ()<UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) UITableView *tableView;
@end
@implementation YJTopicCarkAnalysisView
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
    YJBasePaperSmallModel *firstSmallModel = (YJBasePaperSmallModel *)self.bigModel.yj_smallTopicList.firstObject;
    switch (firstSmallModel.yj_smallTopicType) {
        case YJSmallTopicTypeChoice:
        case YJSmallTopicTypeMoreChoice:
        {
            if (firstSmallModel.yj_smallAnswerType == 32) {
                return self.bigModel.yj_smallTopicList.count*4;
            }else{
                return self.bigModel.yj_smallTopicList.count*2;
            }
        }
            break;
        case YJSmallTopicTypeBlank:
        case YJSmallTopicTypeSimpleAnswer:
        case YJSmallTopicTypeWritting:
            return self.bigModel.yj_smallTopicList.count*4;
            break;
        default:
            return 0;
            break;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger UserType = [NSUserDefaults yj_integerForKey:YJTaskModule_UserType_UserDefault_Key];
    YJBasePaperSmallModel *firstSmallModel = (YJBasePaperSmallModel *)self.bigModel.yj_smallTopicList.firstObject;
    
    switch (firstSmallModel.yj_smallTopicType) {
        case YJSmallTopicTypeChoice:
        case YJSmallTopicTypeMoreChoice:
        {
           NSInteger rate = 2;
            if (firstSmallModel.yj_smallAnswerType == 32) {
                rate = 4;
            }
            YJBasePaperSmallModel *smallModel = (YJBasePaperSmallModel *)self.bigModel.yj_smallTopicList[indexPath.row/rate];
            NSInteger index = indexPath.row%rate;
            if (index == 0) {
                YJTaskTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YJTaskTopicCell class]) forIndexPath:indexPath];
                cell.topicText = [NSString stringWithFormat:@"(%li).%@分",smallModel.yj_smallPaperIndex,smallModel.yj_smallScore];
                cell.isShowSeparator = NO;
                return cell;
            }else{
                if (firstSmallModel.yj_smallAnswerType == 32) {
                    YJMarkObjCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YJMarkObjCell class]) forIndexPath:indexPath];
                    cell.isAddBgColor = NO;
                    cell.isShowSeparator = NO;
                    if (index == 1) {
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
                    }else if (index == 2){
                        cell.titleStr = @"参考答案";
                        cell.titleColor = LG_ColorWithHex(0x009E00);
                        cell.text = smallModel.yj_smallStandardAnswer;
                    }else{
                        cell.isShowSeparator = YES;
                        cell.titleStr = @"本题得分";
                        cell.titleColor = LG_ColorWithHex(0xFC0000);
                        if (!IsStrEmpty(smallModel.yj_smallAnswerScore) && smallModel.yj_smallAnswerScore.floatValue >= 0) {
                            cell.text = [smallModel.yj_smallAnswerScore stringByAppendingString:@"分"];
                        }else{
                            cell.text = @"--";
                        }
                    }
                    return cell;
                }else{
                    YJAnaDetailChoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YJAnaDetailChoiceCell class]) forIndexPath:indexPath];
                    if (self.taskStageType == YJTaskStageTypeAnalysis) {
                        cell.isSubmit = YES;
                    }else{
                        cell.isSubmit = NO;
                    }
                    cell.smallModel = smallModel;
                    cell.isShowSeparator = YES;
                    return cell;
                }
            }
        }
            break;
        case YJSmallTopicTypeBlank:
        {
             YJBasePaperSmallModel *smallModel = (YJBasePaperSmallModel *)self.bigModel.yj_smallTopicList[indexPath.row/4];
            NSInteger index = indexPath.row%4;
            if (index == 0) {
                YJTaskTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YJTaskTopicCell class]) forIndexPath:indexPath];
                cell.topicText = [NSString stringWithFormat:@"(%li).%@分",smallModel.yj_smallPaperIndex,smallModel.yj_smallScore];
                cell.isShowSeparator = NO;
                return cell;
            }else{
                YJMarkObjCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YJMarkObjCell class]) forIndexPath:indexPath];
                cell.isAddBgColor = NO;
                cell.isShowSeparator = NO;
                if (index == 1) {
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
                }else if (index == 2){
                    cell.titleStr = @"参考答案";
                    cell.titleColor = LG_ColorWithHex(0x009E00);
                    cell.text = smallModel.yj_smallStandardAnswer;
                }else{
                    cell.isShowSeparator = YES;
                    cell.titleStr = @"本题得分";
                    cell.titleColor = LG_ColorWithHex(0xFC0000);
                    if (!IsStrEmpty(smallModel.yj_smallAnswerScore) && smallModel.yj_smallAnswerScore.floatValue >= 0) {
                         cell.text = [smallModel.yj_smallAnswerScore stringByAppendingString:@"分"];
                    }else{
                        cell.text = @"--";
                    }
                }
                return cell;
            }
        }
            break;
        case YJSmallTopicTypeSimpleAnswer:
        case YJSmallTopicTypeWritting:
        {
             YJBasePaperSmallModel *smallModel = (YJBasePaperSmallModel *)self.bigModel.yj_smallTopicList[indexPath.row/4];
            NSInteger index = indexPath.row%4;
            if (index == 0) {
                YJTaskTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YJTaskTopicCell class]) forIndexPath:indexPath];
                cell.topicText = [NSString stringWithFormat:@"(%li).%@分",smallModel.yj_smallPaperIndex,smallModel.yj_smallScore];
                cell.isShowSeparator = NO;
                return cell;
            }else{
                YJMarkSubCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YJMarkSubCell class]) forIndexPath:indexPath];
                cell.isAddBgColor = NO;
                cell.isShowSeparator = NO;
                if (index == 1) {
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
                }else if (index == 2){
                     cell.imgUrlArr = nil;
                    cell.titleStr = @"参考答案";
                    cell.titleColor = LG_ColorWithHex(0x009E00);
                    cell.text = smallModel.yj_smallStandardAnswer;
                }else{
                     cell.imgUrlArr = nil;
                    cell.isShowSeparator = YES;
                    cell.titleStr = @"本题得分";
                    cell.titleColor = LG_ColorWithHex(0xFC0000);
                    if (!IsStrEmpty(smallModel.yj_smallAnswerScore) && smallModel.yj_smallAnswerScore.floatValue >= 0) {
                        cell.text = [smallModel.yj_smallAnswerScore stringByAppendingString:@"分"];
                    }else{
                        cell.text = @"--";
                    }
                }
                return cell;
            }
            
        }
            break;
        default:
            return nil;
            break;
    }
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[YJTaskTopicCell class] forCellReuseIdentifier:NSStringFromClass([YJTaskTopicCell class])];
           [_tableView registerClass:[YJAnaDetailChoiceCell class] forCellReuseIdentifier:NSStringFromClass([YJAnaDetailChoiceCell class])];
        [_tableView registerClass:[YJMarkObjCell class] forCellReuseIdentifier:NSStringFromClass([YJMarkObjCell class])];
        [_tableView registerClass:[YJMarkSubCell class] forCellReuseIdentifier:NSStringFromClass([YJMarkSubCell class])];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 100;
    }
    return _tableView;
}
@end
