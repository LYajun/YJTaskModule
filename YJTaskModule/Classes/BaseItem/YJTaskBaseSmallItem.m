//
//  YJTaskBaseSmallItem.m
//  YJTaskKit
//
//  Created by 刘亚军 on 2018/7/31.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "YJTaskBaseSmallItem.h"
#import <Masonry/Masonry.h>
#import "YJTaskTitleView.h"
#import "YJConst.h"

@interface YJTaskBaseSmallItem ()

@end
@implementation YJTaskBaseSmallItem
- (instancetype)initWithFrame:(CGRect)frame smallPModel:(YJBasePaperSmallModel *)smallPModel taskStageType:(YJTaskStageType)taskStageType{
    if (self = [super init]) {
        self.smallModel = smallPModel;
        self.taskStageType = taskStageType;
        [self layoutUI];
    }
    return self;
}
- (void)layoutUI{
    [self addSubview:self.titleView];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
        make.left.equalTo(self.mas_left);
        make.height.mas_equalTo(30);
    }];
}
//- (void)setTotalTopicCount:(NSInteger)totalTopicCount{
//    _totalTopicCount = totalTopicCount;
//    self.titleView.taskName = [NSString stringWithFormat:@"(本题共%li道小题)",totalTopicCount];
//}
- (YJTaskTitleView *)titleView{
    if (!_titleView) {
        _titleView = [[YJTaskTitleView alloc] initWithFrame:CGRectZero];
        _titleView.carkable = NO;
        _titleView.botLineable = NO;
    }
    return _titleView;
}
- (void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
//    if (self.totalTopicCount > 1) {
//        self.titleView.topicIndexAttr = [NSMutableAttributedString yj_AttributedStringByHtmls:@[[NSString stringWithFormat:@"(%li)",currentIndex+1],[NSString stringWithFormat:@"/%li",self.totalTopicCount]] colors:@[[UIColor darkGrayColor],LG_ColorWithHex(0x989898)] fonts:@[@(15),@(12)]];
//    }else{
//        self.titleView.topicIndexAttr = [[NSAttributedString alloc] initWithString:@""];
//    }
    if (self.totalTopicCount > 1) {
        self.titleView.taskName = [NSString stringWithFormat:@"(本题共%li道小题,当前第%li小题)",self.totalTopicCount,currentIndex+1];
    }else{
        self.titleView.taskName = @"(本题共1道小题)";
    }
}
- (void)updateData{
    
}
- (void)stopVoicePlay{}
@end
