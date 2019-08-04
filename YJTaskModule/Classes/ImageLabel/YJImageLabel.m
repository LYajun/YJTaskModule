//
//  YJImageLabel.m
//  YJEducationCloud
//
//  Created by 刘亚军 on 2018/5/14.
//  Copyright © 2018年 lange. All rights reserved.
//

#import "YJImageLabel.h"
#import <Masonry/Masonry.h>
#import "YJConst.h"

@interface YJImageLabel ()
@property (nonatomic,strong) UIImageView *bgImageView;
@property (nonatomic,strong) UILabel *titleLab;
@end
@implementation YJImageLabel
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.bgImageView];
        [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}
- (void)setBgImageName:(NSString *)bgImageName{
    _bgImageName = bgImageName;
    self.bgImageView.image = [UIImage yj_imageNamed:bgImageName atDir:YJTaskBundle_Cell atBundle:YJTaskBundle()];
}
- (void)setFontSize:(NSInteger)fontSize{
    _fontSize = fontSize;
    self.titleLab.font = [UIFont systemFontOfSize:fontSize];
}
- (void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    self.titleLab.textColor = textColor;
}
- (void)setTextStr:(NSString *)textStr{
    _textStr = textStr;
    self.titleLab.text = textStr;
}
- (void)setIsHideIndexBgImg:(BOOL)isHideIndexBgImg{
    _isHideIndexBgImg = isHideIndexBgImg;
    self.bgImageView.hidden = isHideIndexBgImg;
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
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}
@end
