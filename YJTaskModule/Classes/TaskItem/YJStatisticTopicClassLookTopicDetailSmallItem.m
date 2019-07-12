//
//  YJStatisticTopicClassLookTopicDetailSmallItem.m
//  LGTeachCloud
//
//  Created by 刘亚军 on 2019/5/24.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "YJStatisticTopicClassLookTopicDetailSmallItem.h"
#import "YJTaskTitleView.h"
#import "YJBasePaperModel.h"
#import "YJTaskTopicCell.h"
#import "YJTaskChoiceCell.h"
#import "YJStatisticTopicClassLookTopicDetailCell.h"
#import <Masonry/Masonry.h>
#import "yjConst.h"

@interface YJStatisticTopicClassLookTopicDetailSmallItem ()<UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) UITableView *tableView;

@end
@implementation YJStatisticTopicClassLookTopicDetailSmallItem
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

#pragma mark  UITableView dataSource & delegate
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
            NSInteger UserType = [NSUserDefaults yj_integerForKey:YJTaskModule_UserType_UserDefault_Key];
            if (UserType == 2) {
                return 1;
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
        cell.textAttr = self.smallModel.yj_smallTopicAttrText;
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
                NSInteger UserType = [NSUserDefaults yj_integerForKey:YJTaskModule_UserType_UserDefault_Key];
                if (!IsStrEmpty(self.smallModel.yj_smallStandardAnswer) && UserType != 2) {
                    NSInteger index = self.smallModel.yj_smallStandardAnswer.yj_stringToASCIIInt-65;
                    if (index == indexP.row) {
                        cell.isChoiced = YES;
                    }else{
                        cell.isChoiced = NO;
                    }
                }else{
                    cell.isChoiced = NO;
                }
                
                cell.userInteractionEnabled = NO;
                return cell;
            }
                break;
            case YJSmallTopicTypeBlank:
            case YJSmallTopicTypeSimpleAnswer:
            case YJSmallTopicTypeWritting:
            {
                YJStatisticTopicClassLookTopicDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YJStatisticTopicClassLookTopicDetailCell class]) forIndexPath:indexPath];
                NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"参考答案："];
                [attr yj_setColor:LG_ColorWithHex(0x009E00)];
                NSMutableAttributedString *contentAttr = self.smallModel.yj_smallStandardAnswer.yj_toMutableAttributedString;
                [contentAttr yj_setFont:17];
                [contentAttr yj_setColor:LG_ColorWithHex(0x333333)];
                [attr appendAttributedString:contentAttr];
                [attr yj_addParagraphLineSpacing:5];
                cell.userInteractionEnabled = NO;
                cell.textAttr = attr;
                return cell;
            }
                break;
            default:
                return nil;
                break;
        }
    }
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[YJTaskTopicCell class] forCellReuseIdentifier:NSStringFromClass([YJTaskTopicCell class])];
        [_tableView registerClass:[YJTaskChoiceCell class] forCellReuseIdentifier:NSStringFromClass([YJTaskChoiceCell class])];
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
