//
//  YJMemberListView.m
//  YJTaskModule_Example
//
//  Created by 刘亚军 on 2020/7/17.
//  Copyright © 2020 lyj. All rights reserved.
//

#import "YJMemberListView.h"
#import "YJConst.h"
#import <Masonry/Masonry.h>
#import "YJMemberListCell.h"
#import <LGAlertHUD/LGAlertHUD.h>
#import <YJSearchController/YJPinYinForObjc.h>
#import <YJSearchController/YJChineseInclude.h>

@interface YJMemberListView ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIImageView *titleImgV;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UIButton *searchBtn;
@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) UIButton *sureBtn;
@property (nonatomic,strong) YJTaskSearchBar *searchBar;
@property (nonatomic,strong) UIView *searchBgView;
@property (nonatomic,strong) UITableView *tableView;
@property (strong,nonatomic) NSArray *resultArr;
@property(nonatomic,strong) UIView *maskView;
@end
@implementation YJMemberListView
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
    [titleBgView addSubview:self.searchBtn];
    [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleBgView);
        make.right.equalTo(titleBgView).offset(-10);
        make.width.height.mas_equalTo(28);
    }];
    
    [titleBgView addSubview:self.titleImgV];
    [self.titleImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleBgView);
        make.left.equalTo(titleBgView).offset(10);
        make.width.height.mas_equalTo(14);
    }];
    
    [titleBgView addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleBgView);
        make.left.equalTo(self.titleImgV.mas_right).offset(3);
        make.right.equalTo(self.searchBtn.mas_left).offset(-10);
    }];
    
    [titleBgView addSubview:self.searchBgView];
    [self.searchBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.top.right.equalTo(titleBgView);
        make.width.mas_equalTo(0);
    }];
    
    [self.searchBgView addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.searchBgView);
        make.right.equalTo(self.searchBgView).offset(-10);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(28);
    }];
    
    [self.searchBgView addSubview:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerY.equalTo(self.searchBgView);
        make.left.equalTo(self.searchBgView).offset(20);
        make.right.equalTo(self.cancelBtn.mas_left).offset(-20);
        make.height.mas_equalTo(30);
    }];
    [self.searchBar yj_clipLayerWithRadius:15 width:0 color:nil];
    
    [self addSubview:self.sureBtn];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.mas_equalTo(50);
    }];
    
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.right.equalTo(self);
        make.top.equalTo(titleBgView.mas_bottom).offset(8);
        make.bottom.equalTo(self.sureBtn.mas_top).offset(-8);
    }];
}
+ (YJMemberListView *)memberListView{
    YJMemberListView *memberView = [[YJMemberListView alloc] initWithFrame:CGRectMake(0, LG_ScreenHeight, LG_ScreenWidth, LG_ScreenHeight*0.75)];
      memberView.maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
      memberView.maskView.backgroundColor = [UIColor darkGrayColor];
      memberView.maskView.alpha = 0.3;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:memberView action:@selector(hide)];
    [memberView.maskView addGestureRecognizer:tapGes];
    return memberView;
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
- (void)searchBtnAction{
    [UIView animateWithDuration:0.5 animations:^{
        [self.searchBgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(LG_ScreenWidth);
        }];
    } completion:^(BOOL finished) {
        [self.searchBar becomeFirstResponder];
    }];
}
- (void)cancelBtnAction{
    self.searchBar.text = @"";
    [self setSearchStr:@""];
     [self.searchBar resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        [self.searchBgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
    }];
}
- (void)sureBtnAction{
    [self hide];
}
- (void)keyboardSearchAction{
    [self.searchBar resignFirstResponder];
}
- (void)setMemberArr:(NSArray *)memberArr{
    _memberArr = memberArr;
    _resultArr = memberArr;
    [self.tableView reloadData];
}
- (void)setSearchStr:(NSString *)searchStr{
    NSMutableArray *searchDataArr = [NSMutableArray array];
    if (searchStr && searchStr.length > 0  &&
        self.memberArr && self.memberArr.count > 0) {
        if (![YJChineseInclude isIncludeChineseInString:searchStr]) {
            for (int i=0; i<self.memberArr.count; i++) {
                if ([YJChineseInclude isIncludeChineseInString:self.memberArr[i]]) {
                    NSString *tempPinYinStr = [YJPinYinForObjc chineseConvertToPinYin:self.memberArr[i]];
                    NSRange titleResult=[tempPinYinStr rangeOfString:searchStr options:NSCaseInsensitiveSearch];
                    if (titleResult.length>0) {
                        if (![searchDataArr containsObject:self.memberArr[i]]) {
                            [searchDataArr addObject:self.memberArr[i]];
                        }
                    }else{
                        NSString *tempPinYinHeadStr = [YJPinYinForObjc chineseConvertToPinYinHead:self.memberArr[i]];
                        NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:searchStr options:NSCaseInsensitiveSearch];
                        if (titleHeadResult.length>0) {
                            if (![searchDataArr containsObject:self.memberArr[i]]) {
                                [searchDataArr addObject:self.memberArr[i]];
                            }
                        }
                    }
                }else {
                    NSRange titleResult=[self.memberArr[i] rangeOfString:searchStr options:NSCaseInsensitiveSearch];
                    if (titleResult.length>0) {
                        if (![searchDataArr containsObject:self.memberArr[i]]) {
                            [searchDataArr addObject:self.memberArr[i]];
                        }
                    }
                }
            }
        }else{
            for (NSString *tempStr in self.memberArr) {
                NSRange titleResult=[tempStr rangeOfString:searchStr options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    if (![searchDataArr containsObject:tempStr]) {
                        [searchDataArr addObject:tempStr];
                    }
                }
            }
            
        }
    }else{
        [searchDataArr addObjectsFromArray:self.memberArr];
    }
    
    self.resultArr = searchDataArr;
    [self.tableView reloadData];
}
#pragma mark UITextField Delegate
- (void)textFieldDidChange:(UITextField *)textField{
    UITextRange *selectedRange = [textField markedTextRange];
    NSString *newText = [textField textInRange:selectedRange];
    if (newText.length <= 0) {
        [self setSearchStr:textField.text];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
}


#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.resultArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YJMemberListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(YJMemberListCell.class) forIndexPath:indexPath];
    cell.isShowSeparator = YES;
    cell.separatorOffsetPoint = CGPointMake(10, 10);
    cell.name = self.resultArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YJMemberListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.choice = !cell.choice;
}
- (UIImageView *)titleImgV{
    if (!_titleImgV) {
        _titleImgV = [[UIImageView alloc] initWithImage:[UIImage yj_imageNamed:@"add_member_title" atDir:YJTaskBundle_SpeechAnswer atBundle:YJTaskBundle()]];
    }
    return _titleImgV;
}
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.textColor = LG_ColorWithHex(0x989898);
        _titleLab.font = LG_SysFont(14);
        _titleLab.text = @"添加小组成员";
    }
    return _titleLab;
}
- (UIButton *)searchBtn{
    if (!_searchBtn) {
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchBtn setImage:[UIImage yj_imageNamed:@"search_2" atDir:YJTaskBundle_SpeechAnswer atBundle:YJTaskBundle()] forState:UIControlStateNormal];
        [_searchBtn addTarget:self action:@selector(searchBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;
}
- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = LG_SysFont(16);
        [_cancelBtn setTitleColor:LG_ColorWithHex(0x989898) forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
- (UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
         _sureBtn.titleLabel.font = LG_SysFont(18);
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:LG_ColorWithHex(0x00AFFB) forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _sureBtn.backgroundColor = [UIColor whiteColor];
    }
    return _sureBtn;
}
- (YJTaskSearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[YJTaskSearchBar alloc] initWithFrame:CGRectZero];
        _searchBar.delegate = self;
        [_searchBar addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        __weak typeof(self) weakSelf = self;
        _searchBar.removeBlock = ^{
            [weakSelf setSearchStr:@""];
        };
    }
    return _searchBar;
}
- (UIView *)searchBgView{
    if (!_searchBgView) {
        _searchBgView = [UIView new];
        _searchBgView.backgroundColor = [UIColor whiteColor];
    }
    return _searchBgView;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 50;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:YJMemberListCell.class forCellReuseIdentifier:NSStringFromClass(YJMemberListCell.class)];
    }
    return _tableView;
}
@end
