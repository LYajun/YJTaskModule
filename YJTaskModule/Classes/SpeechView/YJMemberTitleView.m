//
//  YJMemberTitleView.m
//  YJTaskModule_Example
//
//  Created by 刘亚军 on 2020/7/24.
//  Copyright © 2020 lyj. All rights reserved.
//

#import "YJMemberTitleView.h"
#import "YJConst.h"
#import <Masonry/Masonry.h>
#import <LGAlertHUD/YJTaskMarLabel.h>
#import "YJMemberListView.h"

@interface YJMemberTitleView ()
@property (nonatomic,strong) UIImageView *titleImgV;
@property (nonatomic,strong) YJTaskMarLabel *memberLab;
@property (nonatomic,strong) UIButton *addBtn;
@end
@implementation YJMemberTitleView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self layoutUI];
    }
    return self;
}
- (void)layoutUI{
    self.backgroundColor = LG_ColorWithHex(0xF7F7F7);
    [self addSubview:self.addBtn];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-10);
        make.width.height.mas_equalTo(28);
    }];
    
    [self addSubview:self.titleImgV];
    [self.titleImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(10);
        make.width.height.mas_equalTo(14);
    }];
    
    [self addSubview:self.memberLab];
    [self.memberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.titleImgV.mas_right).offset(3);
        make.right.equalTo(self.addBtn.mas_left).offset(-10);
    }];
    
    
    self.memberLab.text = @"小组成员:张三、李四、王二五";
}
- (void)dealloc{
    [self.memberLab invalidateTimer];
}
- (void)addBtnAction{
    YJMemberListView *memberListView = [YJMemberListView memberListView];
    memberListView.memberArr = @[@"张三",@"立即",@"好梦",@"黄菲菲",@"李小萌",@"网乌尔",@"猪猪",@"留刘海",@"hello"];
    [memberListView show];
}
- (void)setAddable:(BOOL)addable{
    _addable = addable;
    self.addBtn.hidden = !addable;
    [self.memberLab mas_updateConstraints:^(MASConstraintMaker *make) {
        if (addable) {
            make.right.equalTo(self.addBtn.mas_left).offset(-10);
        }else{
            make.right.equalTo(self).offset(-10);
        }
    }];
}
- (UIButton *)addBtn{
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBtn setImage:[UIImage yj_imageNamed:@"add_member" atDir:YJTaskBundle_SpeechAnswer atBundle:YJTaskBundle()] forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(addBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}
- (UIImageView *)titleImgV{
    if (!_titleImgV) {
        _titleImgV = [[UIImageView alloc] initWithImage:[UIImage yj_imageNamed:@"menber" atDir:YJTaskBundle_SpeechAnswer atBundle:YJTaskBundle()]];
    }
    return _titleImgV;
}
- (YJTaskMarLabel *)memberLab{
    if (!_memberLab) {
        _memberLab = [YJTaskMarLabel new];
        _memberLab.font = [UIFont systemFontOfSize:14];
        _memberLab.textColor = LG_ColorWithHex(0x252525);
    }
    return _memberLab;
}
@end
