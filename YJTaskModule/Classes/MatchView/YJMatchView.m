//
//  YJMatchView.m
//  YJTaskKit
//
//  Created by 刘亚军 on 2018/7/30.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "YJMatchView.h"
#import "YJTaskChoiceLabel.h"
#import "LGBaseTextView.h"
#import "LGBaseTableViewCell.h"
#import <Masonry/Masonry.h>
#import "YJConst.h"


@interface YJMatchViewCell : LGBaseTableViewCell
@property (nonatomic,strong) YJTaskChoiceLabel *choiceLab;
@property (nonatomic,assign) BOOL isChoice;
@property (nonatomic,assign) NSInteger topicIndex;
@property (strong,nonatomic) LGBaseTextView *textView;
@property (strong,nonatomic) NSMutableAttributedString *textAttr;
@end
@implementation YJMatchViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self layoutViews];
    }
    return self;
}
- (void)layoutViews{
    [self.contentView addSubview:self.choiceLab];
    [self.choiceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(10);
        make.width.height.mas_equalTo(LabHeight);
    }];
    [self.contentView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.top.equalTo(self.contentView.mas_top).offset(5);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.left.equalTo(self.choiceLab.mas_right).offset(5);
        make.height.mas_greaterThanOrEqualTo(44);
    }];
}
- (void)setIsChoice:(BOOL)isChoice{
    _isChoice = isChoice;
    self.choiceLab.isChoiced = isChoice;
}
- (void)setTopicIndex:(NSInteger)topicIndex{
    _topicIndex = topicIndex;
    self.choiceLab.index = topicIndex;
}
- (void)setTextAttr:(NSMutableAttributedString *)textAttr{
    _textAttr = textAttr;
    [textAttr yj_setFont:18];
    self.textView.attributedText = textAttr;
}
- (YJTaskChoiceLabel *)choiceLab{
    if (!_choiceLab) {
        _choiceLab = [[YJTaskChoiceLabel alloc] initWithFrame:CGRectZero];
        _choiceLab.fontSize = 18;
    }
    return _choiceLab;
}
- (LGBaseTextView *)textView{
    if (!_textView) {
        _textView = [[LGBaseTextView alloc] initWithFrame:CGRectZero];
        _textView.font = [UIFont systemFontOfSize:18];
        _textView.editable = NO;
        _textView.scrollEnabled = NO;
        _textView.selectable = NO;
        _textView.userInteractionEnabled = NO;
    }
    return _textView;
}
@end


@interface YJMatchView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *maskView;
@end
@implementation YJMatchView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self layoutViews];
    }
    return self;
}

- (void)layoutViews{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.top.equalTo(self);
    }];
}
- (void)sureAction{
    if (self.editable) {
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(yj_matchView:didSelectedItemAtIndex:)]) {
            [self.delegate yj_matchView:self didSelectedItemAtIndex:self.currentIndex];
        }
    }
    [self hide];
}
+ (YJMatchView *)matchViewOnView:(UIView *)view frame:(CGRect)frame{
    YJMatchView *matchView = [[YJMatchView alloc] initWithFrame:frame];
    matchView.maskView = [[UIView alloc] initWithFrame:view.bounds];
    matchView.maskView.backgroundColor = [UIColor darkGrayColor];
    matchView.maskView.alpha = 0.3;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:matchView action:@selector(hide)];
    [matchView.maskView addGestureRecognizer:tap];
    [view addSubview:matchView.maskView];
    [view addSubview:matchView];
    [matchView yj_shadowWithWidth:0.5 borderColor:LG_ColorWithHex(0xF0F0F0) opacity:0.2 radius:4.0 offset:CGSizeMake(0, -1)];
    return matchView;
}
- (void)setTopicContentArr:(NSArray<NSMutableAttributedString *> *)topicContentArr{
    _topicContentArr = topicContentArr;
    [self.tableView reloadData];
}
- (void)show{
    [UIView animateWithDuration:0.3 animations:^(void) {
        self.transform = CGAffineTransformMakeTranslation(0, - self.frame.size.height);
    }];
}
- (void)hide{
    [UIView animateWithDuration:0.2 animations:^(void) {
        self.transform = CGAffineTransformIdentity;
        self.maskView.alpha = 0;
    } completion:^(BOOL isFinished) {
        [self.maskView removeFromSuperview];
        [self removeFromSuperview];
    }];
}
#pragma mark UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.topicContentArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YJMatchViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YJMatchViewCell class]) forIndexPath:indexPath];
    if (self.editable && indexPath.row == self.currentIndex) {
        cell.isChoice = YES;
    }else{
        cell.isChoice = NO;
    }
    cell.topicIndex = indexPath.row;
    cell.isShowSeparator = YES;
    cell.textAttr = self.topicContentArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.editable = YES;
    self.currentIndex = indexPath.row;
    [self sureAction];
}
#pragma mark Property init
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 100;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerClass:[YJMatchViewCell class] forCellReuseIdentifier:NSStringFromClass([YJMatchViewCell class])];
    }
    return _tableView;
}
@end
