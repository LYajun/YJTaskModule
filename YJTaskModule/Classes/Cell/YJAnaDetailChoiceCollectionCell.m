//
//  YJAnaDetailChoiceCollectionCell.m
//  LGTeachCloud
//
//  Created by 刘亚军 on 2019/6/28.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "YJAnaDetailChoiceCollectionCell.h"
#import <Masonry/Masonry.h>
#import "YJConst.h"

@interface YJAnaDetailChoiceCollectionCell ()
@property (nonatomic,strong) UILabel *contentLab;
@property (nonatomic,strong) UILabel *titleLab;

@end
@implementation YJAnaDetailChoiceCollectionCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView).offset(-15);
            make.height.mas_equalTo(18);
        }];
        
        [self.contentView addSubview:self.contentLab];
        [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.contentView).offset(15);
        }];
    }
    return self;
}

- (void)setContent:(NSString *)content{
    _content = content;
    self.contentLab.text = content;
}

- (void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    self.titleLab.text = titleStr;
}

- (void)setContentColor:(UIColor *)contentColor{
    _contentColor = contentColor;
    self.contentLab.textColor = contentColor;
}

- (UILabel *)contentLab{
    if (!_contentLab) {
        _contentLab = [UILabel new];
        _contentLab.font = [UIFont systemFontOfSize:17];
        _contentLab.textAlignment = NSTextAlignmentCenter;
    }
    return _contentLab;
}
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont systemFontOfSize:16];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.textColor = LG_ColorWithHex(0xA7A7A7);
    }
    return _titleLab;
}
@end
