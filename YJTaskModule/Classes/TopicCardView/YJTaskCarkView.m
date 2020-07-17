//
//  YJTaskCarkView.m
//  YJTaskKit
//
//  Created by 刘亚军 on 2018/8/1.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "YJTaskCarkView.h"
#import "YJTaskCarkModel.h"
#import "YJTaskCarkCell.h"

#import <Masonry/Masonry.h>
#import "YJConst.h"

#define kTaskCarkViewWidth  (IsIPad ? 480 : LG_ScreenWidth*0.9)
#define kTaskCarkViewHeight  (IsIPad ? 640 : LG_ScreenHeight*0.7)

@interface YJTaskCarkView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIButton *closeBtn;
@property(nonatomic,strong) UIView *maskView;
@property (nonatomic,strong) UIImageView *headImageV;
@property (nonatomic,strong) UILabel *titleL;
@end
@implementation YJTaskCarkView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}
- (void)initUI{
    UIView *contentView = [UIView new];
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    CGFloat headImageH = 130;
    CGFloat headImageSpace = headImageH/2;
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.left.bottom.equalTo(self);
        make.top.equalTo(self).offset(headImageH - headImageSpace);
    }];
    [contentView yj_clipLayerWithRadius:5 width:0 color:nil];
    [self addSubview:self.headImageV];
    [self.headImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.centerX.equalTo(self);
        make.height.mas_equalTo(headImageH);
        make.width.equalTo(self.headImageV.mas_height).multipliedBy(1.04);
    }];
   
    
    [contentView addSubview:self.titleL];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.top.equalTo(contentView.mas_top).offset(headImageSpace-20);
        make.left.equalTo(contentView.mas_left).offset(20);
        make.height.mas_equalTo(40);
    }];
    [contentView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(contentView);
        make.top.equalTo(self.titleL.mas_bottom);
    }];
}
+ (YJTaskCarkView *)taskCarkView{
    YJTaskCarkView *cardView = [[YJTaskCarkView alloc] initWithFrame:CGRectMake(0, 0, kTaskCarkViewWidth, kTaskCarkViewHeight)];
     cardView.maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    cardView.maskView.backgroundColor = LG_ColorWithHexA(0x000000, 0.6);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:cardView action:@selector(manualHide)];
    [cardView.maskView addGestureRecognizer:tap];
//    [cardView.maskView addSubview:cardView.closeBtn];
//    [cardView.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(cardView.maskView);
//        make.centerY.equalTo(cardView.maskView).offset(kTaskCarkViewHeight/2 + 10);
//        make.width.height.mas_equalTo(28);
//    }];
    return cardView;
}
- (void)setDataArr:(NSArray<YJTaskCarkModel *> *)dataArr{
    _dataArr = dataArr;
    [self.tableView reloadData];
}
- (void)setIsManualMarkMode:(BOOL)isManualMarkMode{
    _isManualMarkMode = isManualMarkMode;
    if (isManualMarkMode) {
        if (self.isCheckState) {
            self.titleL.text = @"审核卡";
        }else{
            self.titleL.text = @"评阅卡";
        }
    }else{
        self.titleL.text = @"答题卡";
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    YJTaskCarkModel *cardModel = self.dataArr[indexPath.row];
    NSInteger rowCount = 0;
    
    if (IsIPad) {
        if (cardModel.answerResults.count % 8 == 0) {
            rowCount = cardModel.answerResults.count / 8 > 0 ? cardModel.answerResults.count / 8 : 1;
        }else{
            rowCount = cardModel.answerResults.count / 8 > 0 ? cardModel.answerResults.count / 8 + 1: 1;
        }
        return rowCount * ((kTaskCarkViewWidth-20*2-3*7-3*2)/8 + 3) + 3 + 3 + 30;
    }else{
        if (cardModel.answerResults.count % 5 == 0) {
            rowCount = cardModel.answerResults.count / 5 > 0 ? cardModel.answerResults.count / 5 : 1;
        }else{
            rowCount = cardModel.answerResults.count / 5 > 0 ? cardModel.answerResults.count / 5 + 1: 1;
        }
        return rowCount * ((kTaskCarkViewWidth-20*2-3*4-3*2)/5 + 3) + 3 + 3 + 30;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YJTaskCarkCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YJTaskCarkCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.curentImage.hidden = YES;
    cell.isTopicCardMode = self.isTopicCardMode;
    cell.bigTopicTypeNameHideBig = self.bigTopicTypeNameHideBig;
    if (self.isTopicCardMode) {
        cell.currentSmallIndexStr = @"";
        if (self.currentSmallIndex == indexPath.row) {
            cell.curentImage.hidden = NO;
        }
    }else{
        if (indexPath == self.indexPath && self.currentSmallIndex >= 0) {
            cell.currentSmallIndexStr = [NSString stringWithFormat:@"%li",self.currentSmallIndex];
        }else{
            cell.currentSmallIndexStr = @"";
        }
    }
    cell.isManualMarkMode = self.isManualMarkMode;
    cell.cardModel = self.dataArr[indexPath.row];
    __weak typeof(self) weakSelf = self;;
    cell.SelectItemBlock = ^(NSInteger index) {
        [weakSelf hide];
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(yj_taskCarkView:didSelectedItemAtIndexPath:)]) {
            [weakSelf.delegate yj_taskCarkView:weakSelf didSelectedItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:indexPath.row]];
        }
    };
    
    return cell;
}
- (void)show{
   
    
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self.maskView];
    [rootWindow addSubview:self];
    self.center = CGPointMake(rootWindow.center.x, rootWindow.center.y-25);
    self.transform = CGAffineTransformConcat(CGAffineTransformIdentity,
                                             CGAffineTransformMakeScale(0.1f, 0.1f));
    self.alpha = 0.0f;
    self.maskView.alpha = 0.0f;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3f animations:^{
        weakSelf.maskView.alpha = 0.6f;
        weakSelf.transform = CGAffineTransformConcat(CGAffineTransformIdentity,
                                                     CGAffineTransformMakeScale(1.0f, 1.0f));
        weakSelf.alpha = 1.0f;
    }];
    
    [self.tableView layoutIfNeeded];
    [self.tableView scrollToRowAtIndexPath:self.indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
}
- (void)manualHide{
    if (self.delegate && [self.delegate respondsToSelector:@selector(yj_taskCarkViewDidHide)]) {
        [self.delegate yj_taskCarkViewDidHide];
    }
    [self hide];
}
- (void)hide{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^(void) {
        weakSelf.maskView.alpha = 0.0f;
        weakSelf.alpha = 0.0f;
    } completion:^(BOOL isFinished) {
        [weakSelf.maskView removeFromSuperview];
        [weakSelf removeFromSuperview];
    }];
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [UILabel new];
        _titleL.textAlignment = NSTextAlignmentCenter;
        _titleL.font = [UIFont systemFontOfSize:17];
        _titleL.textColor = LG_ColorWithHex(0x333333);
        _titleL.text = @"答题卡";
    }
    return _titleL;
}
- (UIImageView *)headImageV{
    if (!_headImageV) {
        _headImageV = [[UIImageView alloc] initWithImage:[UIImage yj_imageNamed:@"hud_top_lancoo" atDir:YJTaskBundle_Cell atBundle:YJTaskBundle()]];
    }
    return _headImageV;
}
- (UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage yj_imageNamed:@"bk_delete" atDir:YJTaskBundle_Cell atBundle:YJTaskBundle()] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(manualHide) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn.userInteractionEnabled = NO;
    }
    return _closeBtn;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[YJTaskCarkCell class] forCellReuseIdentifier:NSStringFromClass([YJTaskCarkCell class])];
    }
    return _tableView;
}
@end
