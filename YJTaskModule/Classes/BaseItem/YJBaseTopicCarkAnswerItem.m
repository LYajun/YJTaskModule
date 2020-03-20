//
//  YJBaseTopicCarkAnswerItem.m
//  LGEducationCloud
//
//  Created by 刘亚军 on 2018/5/14.
//  Copyright © 2018年 lange. All rights reserved.
//

#import "YJBaseTopicCarkAnswerItem.h"
#import <Masonry/Masonry.h>
#import "YJConst.h"

@interface YJBaseTopicCarkAnswerItem ()

@end
@implementation YJBaseTopicCarkAnswerItem
- (instancetype)initWithFrame:(CGRect)frame bigTopicASPModel:(YJBasePaperBigModel *)bigTopicASPModel taskStageType:(YJTaskStageType)taskStageType{
    if (self = [super initWithFrame:frame]) {
        self.bigModel = bigTopicASPModel;
        self.taskStageType = taskStageType;
        [self initUI];
    }
    return self;
}
- (void)initUI{
    [self addSubview:self.titleView];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
        make.left.equalTo(self.mas_left);
        make.height.mas_equalTo(40);
    }];
    [self.titleView layoutIfNeeded];
}
- (void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    if (self.totalTopicCount > 1) {
        self.titleView.topicIndexAttr = [NSMutableAttributedString yj_AttributedStringByHtmls:@[[NSString stringWithFormat:@"%li",currentIndex+1],[NSString stringWithFormat:@"/%li",self.totalTopicCount]] colors:@[LG_ColorThemeBlue,[UIColor darkGrayColor]] fonts:@[@(16),@(13)]];
    }else{
        self.titleView.topicIndexAttr = [[NSAttributedString alloc] initWithString:@""];
    }
    YJBasePaperSmallModel *smallModel = (YJBasePaperSmallModel *)self.bigModel.yj_smallTopicList.firstObject;
    self.titleView.taskName = [NSString stringWithFormat:@"%li.%@(共%li道小题,每题%@分)",self.bigModel.yj_bigBaseIndex+1,self.bigModel.yj_bigTopicTypeName,self.bigModel.yj_smallTopicList.count,smallModel.yj_smallScore];
}
- (void)updateData{
    
}
- (YJTaskTitleView *)titleView{
    if (!_titleView) {
        _titleView = [[YJTaskTitleView alloc] initWithFrame:CGRectZero];
        _titleView.carkable = NO;
        _titleView.botLineable = NO;
    }
    return _titleView;
}
@end
