//
//  YJTaskTitleView.m
//  YJTaskKit
//
//  Created by 刘亚军 on 2018/7/27.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "YJTaskTitleView.h"
#import <Masonry/Masonry.h>
#import "YJConst.h"

@interface YJTaskTitleView ()
@property(nonatomic,strong) UILabel *taskNameL;
@property(nonatomic,strong) UILabel *topicIndexL;

@property(nonatomic,strong) UIView *topicCardBgView;
@property(nonatomic,strong) UIView *botLine;
@end
@implementation YJTaskTitleView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self layoutUI];
    }
    return self;
}
- (void)layoutUI{
    [self addSubview:self.topicCardBgView];
    [self.topicCardBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.top.equalTo(self);
        make.right.equalTo(self.mas_right).offset(-8);
        make.width.mas_equalTo(35);
    }];
    [self.topicCardBgView addSubview:self.topicCarkBtn];
    [self.topicCarkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerY.equalTo(self.topicCardBgView);
         make.right.equalTo(self.topicCardBgView);
        make.width.height.mas_equalTo(25);
    }];
    UIView *lineImage = [UIView new];
    lineImage.backgroundColor = LG_ColorWithHex(0xE0E0E0);
    [self.topicCardBgView addSubview:lineImage];
    [lineImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topicCardBgView);
        make.left.equalTo(self.topicCardBgView);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(1);
    }];
    
    [self addSubview:self.topicIndexL];
    [self.topicIndexL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.top.equalTo(self);
        make.right.equalTo(self.topicCardBgView.mas_left).offset(-8);
        make.width.mas_equalTo(60);
    }];
    [self addSubview:self.taskNameL];
    [self.taskNameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.top.equalTo(self);
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.topicIndexL.mas_left).offset(-10);
    }];
    
    [self addSubview:self.botLine];
    [self.botLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.left.bottom.equalTo(self);
        make.height.mas_equalTo(0.6);
    }];
}
- (void)setBotLineable:(BOOL)botLineable{
    _botLineable = botLineable;
    self.botLine.hidden = !botLineable;
}
- (void)setIndexable:(BOOL)indexable{
    _indexable = indexable;
    self.topicIndexL.hidden = !indexable;
    [self.topicIndexL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(indexable ? 60:0);
        make.right.equalTo(self.topicCardBgView.mas_left).offset(indexable ? -8 : -2);
    }];
}
- (void)setCarkable:(BOOL)carkable{
    _carkable = carkable;
    [self.topicCardBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(carkable ? 35:0);
    }];
    self.topicCardBgView.hidden = !carkable;
    if (carkable) {
        self.taskNameL.textColor = LG_ColorWithHex(0x989898);
    }else{
        self.taskNameL.textColor = LG_ColorWithHex(0x989898);
    }
}
- (void)setTaskName:(NSString *)taskName{
    _taskName = taskName;
    self.taskNameL.text = taskName;
}
- (void)setTopicIndexAttr:(NSAttributedString *)topicIndexAttr{
    _topicIndexAttr = topicIndexAttr;
    self.topicIndexL.attributedText = topicIndexAttr;
}
- (void)topicCarkClickAction{
    if (self.topicCardClickBlock) {
        self.topicCardClickBlock();
    }
}
- (UIView *)botLine{
    if (!_botLine) {
        _botLine = [UIView new];
        _botLine.backgroundColor = LG_ColorWithHex(0xE5E5E5);
    }
    return _botLine;
}
- (UILabel *)taskNameL {
    if (!_taskNameL) {
        _taskNameL = [[UILabel alloc] initWithFrame:CGRectZero];
        _taskNameL.font = [UIFont systemFontOfSize:14];
        _taskNameL.textColor = LG_ColorWithHex(0x989898);
        _taskNameL.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
    return _taskNameL;
}
- (UILabel *)topicIndexL{
    if (!_topicIndexL) {
        _topicIndexL = [UILabel new];
        _topicIndexL.textAlignment = NSTextAlignmentRight;
    }
    return _topicIndexL;
}
- (UIView *)topicCardBgView{
    if (!_topicCardBgView) {
        _topicCardBgView = [UIView new];
    }
    return _topicCardBgView;
}
- (UIButton *)topicCarkBtn{
    if (!_topicCarkBtn) {
        _topicCarkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_topicCarkBtn setImage:[UIImage yj_imageNamed:@"lg_topiccark" atDir:YJTaskBundle_Cell atBundle:YJTaskBundle()] forState:UIControlStateNormal];
        [_topicCarkBtn addTarget:self action:@selector(topicCarkClickAction) forControlEvents:UIControlEventTouchDown];
    }
    return _topicCarkBtn;
}
@end
