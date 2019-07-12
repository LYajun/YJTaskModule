//
//  YJStatisticTopicClassLookTopicDetailTopicCarkView.m
//  LGTeachCloud
//
//  Created by 刘亚军 on 2019/5/24.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "YJStatisticTopicClassLookTopicDetailTopicCarkView.h"
#import "YJTopicCarkChoiceAnswerCell.h"
#import "YJTaskTopicCell.h"
#import "YJStatisticTopicClassLookTopicDetailCell.h"
#import <Masonry/Masonry.h>
#import "YJConst.h"
@interface YJStatisticTopicClassLookTopicDetailTopicCarkView ()<UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) UITableView *tableView;

@end
@implementation YJStatisticTopicClassLookTopicDetailTopicCarkView
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
                return self.bigModel.yj_smallTopicList.count*2;
            }else{
                return self.bigModel.yj_smallTopicList.count;
            }
        }
            break;
        case YJSmallTopicTypeBlank:
        case YJSmallTopicTypeSimpleAnswer:
        case YJSmallTopicTypeWritting:
            return self.bigModel.yj_smallTopicList.count*2;
            break;
        default:
            return 0;
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YJBasePaperSmallModel *firstSmallModel = (YJBasePaperSmallModel *)self.bigModel.yj_smallTopicList.firstObject;

    switch (firstSmallModel.yj_smallTopicType) {
        case YJSmallTopicTypeChoice:
        case YJSmallTopicTypeMoreChoice:
        {
            if (firstSmallModel.yj_smallAnswerType == 32) {
                return [self configBlankCellInfoWithTableView:tableView AtIndexPath:indexPath];
            }else{
                YJBasePaperSmallModel *smallModel = (YJBasePaperSmallModel *)self.bigModel.yj_smallTopicList[indexPath.row];
                YJTopicCarkChoiceAnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YJTopicCarkChoiceAnswerCell class]) forIndexPath:indexPath];
                cell.topicCount = 4;
                cell.topicIndex = smallModel.yj_smallPaperIndex;
                cell.answer = smallModel.yj_smallStandardAnswer;
                cell.userInteractionEnabled = NO;
                return cell;
            }
            
        }
            break;
        case YJSmallTopicTypeBlank:
        case YJSmallTopicTypeSimpleAnswer:
        case YJSmallTopicTypeWritting:
            return [self configBlankCellInfoWithTableView:tableView AtIndexPath:indexPath];
            break;
        default:
            return nil;
            break;
    }
}
- (UITableViewCell *)configBlankCellInfoWithTableView:(UITableView *)tableView AtIndexPath:(NSIndexPath *)indexPath{
    YJBasePaperSmallModel *smallModel = (YJBasePaperSmallModel *)self.bigModel.yj_smallTopicList[indexPath.row/2];
    NSInteger index = indexPath.row%2;
    if (index == 0){
        YJTaskTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YJTaskTopicCell class]) forIndexPath:indexPath];
        
        cell.topicText = [NSString stringWithFormat:@"(%li).%@分",smallModel.yj_smallPaperIndex,smallModel.yj_smallScore];
        cell.isShowSeparator = NO;
        return cell;
    }else{
        YJStatisticTopicClassLookTopicDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YJStatisticTopicClassLookTopicDetailCell class]) forIndexPath:indexPath];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"参考答案："];
        [attr yj_setColor:LG_ColorWithHex(0x009E00)];
        NSMutableAttributedString *contentAttr = smallModel.yj_smallStandardAnswer.yj_toMutableAttributedString;
        [contentAttr yj_setFont:17];
        [contentAttr yj_setColor:LG_ColorWithHex(0x333333)];
        [attr appendAttributedString:contentAttr];
        [attr yj_addParagraphLineSpacing:5];
        cell.userInteractionEnabled = NO;
        cell.textAttr = attr;
        return cell;
    }
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[YJTopicCarkChoiceAnswerCell class] forCellReuseIdentifier:NSStringFromClass([YJTopicCarkChoiceAnswerCell class])];
        [_tableView registerClass:[YJTaskTopicCell class] forCellReuseIdentifier:NSStringFromClass([YJTaskTopicCell class])];
        [_tableView registerClass:[YJStatisticTopicClassLookTopicDetailCell class] forCellReuseIdentifier:NSStringFromClass([YJStatisticTopicClassLookTopicDetailCell class])];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 100;
    }
    return _tableView;
}
@end
