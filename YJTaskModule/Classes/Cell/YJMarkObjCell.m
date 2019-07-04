//
//  YJMarkObjCell.m
//  LGTeachCloud
//
//  Created by 刘亚军 on 2019/3/29.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "YJMarkObjCell.h"
#import "LGBaseTextView.h"
#import <Masonry/Masonry.h>
#import "YJConst.h"

@interface YJMarkObjCell ()
@property(nonatomic,strong) UILabel *titleLab;
@property(nonatomic,strong) LGBaseTextView *textView;
@end
@implementation YJMarkObjCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self layoutUI];
    }
    return self;
}
- (void)layoutUI{
    [self.contentView addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.contentView).offset(8);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
    }];
    
    [self.contentView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.titleLab.mas_right).offset(5);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.contentView).offset(5);
        make.height.mas_greaterThanOrEqualTo(40);
    }];
    [self.textView yj_clipLayerWithRadius:4 width:0 color:nil];
}
- (void)setTitleStr:(NSString *)titleStr{
    self.titleLab.text = titleStr;
}
- (void)setTitleColor:(UIColor *)titleColor{
    self.titleLab.textColor = titleColor;
}
- (void)setText:(NSString *)text{
    self.textView.text = text;
    if (!IsStrEmpty(text) && [text isEqualToString:@"未作答"]) {
        self.textView.textColor = LG_ColorWithHex(0x999999);
    }else{
        self.textView.textColor = [UIColor darkGrayColor];
    }
}
- (void)setIsAddBgColor:(BOOL)isAddBgColor{
    _isAddBgColor = isAddBgColor;
    if (isAddBgColor) {
        self.textView.backgroundColor = LG_ColorWithHex(0xDFEFFE);
    }else{
        self.textView.backgroundColor = [UIColor whiteColor];
    }
}
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = LG_SysFont(16);
    }
    return _titleLab;
}
- (LGBaseTextView *)textView{
    if (!_textView) {
        _textView = [LGBaseTextView new];
        _textView.editable = NO;
        _textView.selectable = NO;
        _textView.scrollEnabled = NO;
        _textView.font = LG_SysFont(16);
        _textView.textColor = [UIColor darkGrayColor];
    }
    return _textView;
}
@end
