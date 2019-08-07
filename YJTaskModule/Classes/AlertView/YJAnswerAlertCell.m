//
//  YJAnswerAlertCell.m
//  TPFnowledgeFramework
//
//  Created by 刘亚军 on 2018/11/8.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "YJAnswerAlertCell.h"
#import <Masonry/Masonry.h>
#import "YJConst.h"

#import <YJExtensions/YJExtensions.h>

static CGFloat kSpace = 3;
@interface YJAnswerAlertCell ()
@property (nonatomic,strong) UIImageView *bgImageView;
@property (nonatomic,strong) UILabel *titleLab;
@end
@implementation YJAnswerAlertCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self layoutUI];
    }
    return self;
}
- (void)layoutUI{
    [self.contentView addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(kSpace);
        make.width.mas_equalTo(self.contentView.width-10);
    }];
    [self.bgImageView yj_clipLayerWithRadius:(kCellHeight-kSpace*2)/2 width:0 color:nil];
    [self.contentView addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerX.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView);
    }];
}
- (void)setIsSingle:(BOOL)isSingle{
    _isSingle = isSingle;
    if (isSingle) {
        [self.bgImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(120);
        }];
    }else{
        [self.bgImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.contentView.width-10);
        }];
    }
}
- (void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    self.titleLab.text = titleStr;
}
- (void)setClickHighlighted:(BOOL)clickHighlighted{
    _clickHighlighted = clickHighlighted;
    if (clickHighlighted) {
        self.titleLab.textColor = [UIColor whiteColor];
        self.bgImageView.backgroundColor = LG_ColorWithHex(0x22B0F8);
        [self.bgImageView yj_clipLayerWithRadius:(kCellHeight-kSpace*2)/2 width:0 color:nil];
    }else{
        self.titleLab.textColor = LG_ColorWithHex(0x22B0F8);
        self.bgImageView.backgroundColor = [UIColor whiteColor];
         [self.bgImageView yj_clipLayerWithRadius:(kCellHeight-kSpace*2)/2 width:1.5 color:LG_ColorWithHex(0x22B0F8)];
    }
}
- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _bgImageView;
}
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        if (LG_ScreenWidth <= 320) {
            _titleLab.font = [UIFont systemFontOfSize:12];
        }else if (LG_ScreenWidth <= 375) {
            _titleLab.font = [UIFont systemFontOfSize:14];
        }else{
            _titleLab.font = [UIFont systemFontOfSize:16];
        }
    }
    return _titleLab;
}
@end
