//
//  YJExcellentAnswerListView.m
//  YJTaskModule_Example
//
//  Created by 刘亚军 on 2020/7/17.
//  Copyright © 2020 lyj. All rights reserved.
//

#import "YJExcellentAnswerListView.h"
#import "YJConst.h"
#import <Masonry/Masonry.h>
#import "YJExcellentAnswerListCell.h"

@interface YJExcellentAnswerListView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIButton *backBtn;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *topicIndexLab;
@property (nonatomic,strong) UILabel *countLab;
@property (nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UIView *botLine;
@end
@implementation YJExcellentAnswerListView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self layouyUI];
    }
    return self;
}
- (void)layouyUI{
    UIView *navBar = [UIView new];
    [self addSubview:navBar];
    [navBar mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.top.right.equalTo(self);
       make.height.mas_equalTo([self yj_customNavBarHeight]);
    }];
    [navBar yj_setGradientBackgroundWithColors:@[LG_ColorWithHex(0x04caf4),LG_ColorWithHex(0x23a1fa)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    
    [navBar addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(navBar.mas_top).offset(26 + [self yj_stateBarSpace]);
       make.left.equalTo(navBar.mas_left).offset(5);
       make.height.mas_equalTo(28);
       make.width.mas_equalTo(40);
    }];
    [navBar addSubview:self.titleLab];
   [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
       make.centerX.equalTo(navBar);
       make.centerY.equalTo(self.backBtn);
       make.left.equalTo(self.backBtn.mas_right).offset(10);
   }];
    
    UIView *headerView = [UIView new];
    [self addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(navBar.mas_bottom);
        make.height.mas_equalTo(40);
    }];
    [headerView addSubview:self.countLab];
    [self.countLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView);
        make.right.equalTo(headerView).offset(-10);
        make.width.mas_equalTo(140);
    }];
    [headerView addSubview:self.topicIndexLab];
    [self.topicIndexLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView);
        make.left.equalTo(headerView).offset(10);
        make.right.equalTo(self.countLab.mas_left).offset(-10);
    }];
    [headerView addSubview:self.botLine];
    [self.botLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.left.bottom.equalTo(headerView);
        make.height.mas_equalTo(0.6);
    }];
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.right.bottom.equalTo(self);
        make.top.equalTo(headerView.mas_bottom);
    }];
}


+ (YJExcellentAnswerListView *)excellentAnswerListView{
    YJExcellentAnswerListView *listView = [[YJExcellentAnswerListView alloc] initWithFrame:CGRectMake(LG_ScreenWidth, 0, LG_ScreenWidth, LG_ScreenHeight)];
    return listView;
    
}
- (void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    NSMutableAttributedString *attr = [NSString stringWithFormat:@"共%@个优秀作答",@(dataArr.count)].yj_toMutableAttributedString;
    [attr yj_setFont:14];
    [attr yj_setColor:LG_ColorWithHex(0x989898)];
    [attr yj_setNumberForegroundColor:LG_ColorWithHex(0xFF6900) font:16];
    [attr yj_setAlignment:NSTextAlignmentRight];
    self.countLab.attributedText = attr;
    
    
    self.topicIndexLab.text = @"情景问答第1小题";
    
    [self.tableView reloadData];
}
- (void)show{
    UIView *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    [keyWindow addSubview:self.maskView];
    [keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^(void) {
        self.transform = CGAffineTransformMakeTranslation(-self.frame.size.width, 0);
    } completion:^(BOOL finished) {
       
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
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YJExcellentAnswerListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(YJExcellentAnswerListCell.class) forIndexPath:indexPath];
    cell.isShowSeparator = YES;
    cell.separatorOffsetPoint = CGPointMake(10, 10);
    return cell;
}


#pragma mark - Getter

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font = [UIFont systemFontOfSize:17];
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.text = @"优秀作答";
    }
    return _titleLab;
}
- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage yj_imageNamed:@"navbar_back" atDir:YJTaskBundle_SpeechAnswer atBundle:YJTaskBundle()] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}
- (UILabel *)topicIndexLab{
    if (!_topicIndexLab) {
        _topicIndexLab = [UILabel new];
        _topicIndexLab.textColor = LG_ColorWithHex(0x989898);
        _topicIndexLab.font = LG_SysFont(15);
    }
    return _topicIndexLab;
}
- (UILabel *)countLab{
    if (!_countLab) {
        _countLab = [UILabel new];
    }
    return _countLab;
}
- (UIView *)botLine{
    if (!_botLine) {
        _botLine = [UIView new];
        _botLine.backgroundColor = LG_ColorWithHex(0xE5E5E5);
    }
    return _botLine;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 80;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:YJExcellentAnswerListCell.class forCellReuseIdentifier:NSStringFromClass(YJExcellentAnswerListCell.class)];
    }
    return _tableView;
}
@end
