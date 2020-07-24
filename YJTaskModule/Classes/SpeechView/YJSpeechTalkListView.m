//
//  YJSpeechTalkListView.m
//  YJTaskModule_Example
//
//  Created by 刘亚军 on 2020/7/17.
//  Copyright © 2020 lyj. All rights reserved.
//

#import "YJSpeechTalkListView.h"
#import "YJConst.h"
#import <Masonry/Masonry.h>
#import "YJTaskAnswerView.h"
#import "YJSpeechTalkListCell.h"
#import "YJSpeechTalkModel.h"
#import "UIView+YJEmpty.h"
#import <LGAlertHUD/LGAlertHUD.h>

@interface YJSpeechTalkListView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UIButton *inputBtn;
@property (nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UIView *maskView;
@end

@implementation YJSpeechTalkListView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self layoutUI];
    }
    return self;
}
- (void)layoutUI{
    self.backgroundColor = LG_ColorWithHex(0xF5F5F5);
    UIView *titleBgView = [UIView new];
    titleBgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:titleBgView];
    [titleBgView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.right.top.equalTo(self);
       make.height.mas_equalTo(44);
    }];
    
    [titleBgView addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.top.equalTo(titleBgView);
        make.left.equalTo(titleBgView).offset(10);
    }];
    
    [self addSubview:self.inputBtn];
    [self.inputBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-8-[self yj_tabBarSpace]);
        make.left.equalTo(self).offset(15);
        make.height.mas_equalTo(40);
    }];
    [self.inputBtn yj_clipLayerWithRadius:20 width:0 color:nil];
    
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.right.equalTo(self);
        make.top.equalTo(titleBgView.mas_bottom).offset(8);
        make.bottom.equalTo(self.inputBtn.mas_top).offset(-8);
    }];
    
    self.emptyTopSpace = 50;
    self.emptyBottomSpace = [self yj_tabBarSpace] + 20 + 40;
}

+ (YJSpeechTalkListView *)speechTalkListView{
    YJSpeechTalkListView *talkListView = [[YJSpeechTalkListView alloc] initWithFrame:CGRectMake(0, LG_ScreenHeight, LG_ScreenWidth, LG_ScreenHeight*0.75)];
         talkListView.maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
         talkListView.maskView.backgroundColor = [UIColor darkGrayColor];
         talkListView.maskView.alpha = 0.3;
       UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:talkListView action:@selector(hide)];
       [talkListView.maskView addGestureRecognizer:tapGes];
       return talkListView;
}
- (void)setPublishEnable:(BOOL)publishEnable{
    _publishEnable = publishEnable;
    self.inputBtn.hidden = !publishEnable;
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        if (publishEnable) {
            make.bottom.equalTo(self.inputBtn.mas_top).offset(-8);
        }else{
            make.bottom.equalTo(self);
        }
    }];
}
- (void)setTalkDataArr:(NSArray *)talkDataArr{
    _talkDataArr = talkDataArr;
    NSMutableAttributedString *attr;
    if (IsArrEmpty(talkDataArr)) {
        attr = @"共0条评论".yj_toMutableAttributedString;
        [self yj_setViewNoDataShow:YES];
        [self yj_setViewNoDataString:@"暂无评论"];
    }else{
        [self yj_setViewNoDataShow:NO];
        attr = [NSString stringWithFormat:@"共%@条评论",@(talkDataArr.count)].yj_toMutableAttributedString;
    }
    [attr yj_setFont:14];
    [attr yj_setColor:LG_ColorWithHex(0x989898)];
    [attr yj_setNumberForegroundColor:LG_ColorWithHex(0xFF6900) font:16];
    self.titleLab.attributedText = attr;
    [self.tableView reloadData];
}
- (void)show{
    UIView *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    [keyWindow addSubview:self.maskView];
    [keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^(void) {
        self.transform = CGAffineTransformMakeTranslation(0, - self.frame.size.height);
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
- (void)inputBtnAction{
    __weak typeof(self) weakSelf = self;
    [YJTaskAnswerView showWithText:@"" sureTitle:@"发布" answerResultBlock:^(NSString *result) {
        [LGAlert showIndeterminateWithStatus:@"发布中..."];
        NSDictionary *params = @{@"Guid":[NSString yj_UUID],
                                                   @"paperGuid":@"",
                                                   @"isGood":@"0",
                                                   @"topicID":kApiParams(self.topicID),
                                                   @"itemIndex":@(self.smallIndex),
                                                   @"userID":kApiParams([NSUserDefaults yj_stringForKey:YJTaskModule_UserID_UserDefault_Key]),
                                                   @"userName":kApiParams([NSUserDefaults yj_stringForKey:YJTaskModule_UserName_UserDefault_Key]),
                                                   @"evaluation":kApiParams(result)
        };
        [YJSpeechTalkModel publishTalkWithParams:params complete:^(NSError * _Nullable error) {
            if (error) {
                [LGAlert showErrorWithStatus:@"发布失败"];
            }else{
                [LGAlert showSuccessWithStatus:@"发布成功"];
                YJSpeechTalkModel *talkModel = [[YJSpeechTalkModel alloc] initWithDictionary:params];
                NSMutableArray *arr = [NSMutableArray arrayWithArray:weakSelf.talkDataArr];
                [arr insertObject:talkModel atIndex:0];
                weakSelf.talkDataArr = arr;
                if (weakSelf.pulishSuccessBlock) {
                    weakSelf.pulishSuccessBlock();
                }
            }
        }];
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.talkDataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YJSpeechTalkListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(YJSpeechTalkListCell.class) forIndexPath:indexPath];
    cell.isShowSeparator = YES;
    cell.separatorOffsetPoint = CGPointMake(10, 10);
    return cell;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
    }
    return _titleLab;
}

- (UIButton *)inputBtn{
    if (!_inputBtn) {
        _inputBtn = [UIButton buttonWithType:UIButtonTypeCustom];
         _inputBtn.titleLabel.font = LG_SysFont(15);
        _inputBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_inputBtn setTitle:@"    点击输入评论" forState:UIControlStateNormal];
        [_inputBtn setTitleColor:LG_ColorWithHex(0x989898) forState:UIControlStateNormal];
        [_inputBtn addTarget:self action:@selector(inputBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _inputBtn.backgroundColor = [UIColor whiteColor];
    }
    return _inputBtn;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 80;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:YJSpeechTalkListCell.class forCellReuseIdentifier:NSStringFromClass(YJSpeechTalkListCell.class)];
    }
    return _tableView;
}
@end
