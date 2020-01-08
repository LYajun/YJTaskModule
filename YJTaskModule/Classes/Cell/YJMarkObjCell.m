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
        make.left.equalTo(self.contentView).offset(2);
        make.top.equalTo(self.contentView).offset(8);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
    }];
    
    [self.contentView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.titleLab.mas_right).offset(0);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.contentView).offset(5);
        make.height.mas_greaterThanOrEqualTo(40);
    }];
    [self.textView yj_clipLayerWithRadius:4 width:0 color:nil];
}
- (void)setTitleStr:(NSString *)titleStr{
    self.titleLab.text = titleStr;
    if (!IsStrEmpty(titleStr) && [titleStr containsString:@"考点"]) {
        CGFloat width = [titleStr yj_widthWithFont:LG_SysFont(16)]+5;
        [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
        }];
    }
}
- (void)setTitleColor:(UIColor *)titleColor{
    self.titleLab.textColor = titleColor;
}
- (void)setText:(NSString *)text{
    self.textView.text = text;
    if (!IsStrEmpty(text) && [text isEqualToString:@"未作答"]) {
        self.textView.textColor = LG_ColorWithHex(0x999999);
    }else{
        NSMutableArray *spanTextArray = [NSMutableArray array];
        if ([text containsString:[NSString yj_Char1]]) {
            NSArray *char1Arr = [text componentsSeparatedByString:[NSString yj_Char1]];
            for (int i = 0; i < char1Arr.count-1; i++) {
                if (i > 0) {
                    NSString *spanText = char1Arr[i];
                    if (!IsStrEmpty(spanText) && [spanText hasSuffix:[NSString stringWithFormat:@"%c",2]]) {
                        [spanTextArray addObject:spanText];
                    }
                }
            }
        }
        if (spanTextArray.count > 0) {
            NSMutableAttributedString *attr = text.yj_toMutableAttributedString;
            [attr yj_setFont:16];
            [attr yj_setColor:LG_ColorWithHex(0x333333)];
            for (NSString *spanText in spanTextArray) {
                NSRange range = [attr.string rangeOfString:spanText];
                if (range.location != NSNotFound) {
                    [attr yj_setBoldFont:17 atRange:range];
                    [attr yj_setColor:LG_ColorWithHex(0x252525) atRange:range];
                }
            }
            self.textView.attributedText = attr;
        }else{
            self.textView.textColor = LG_ColorWithHex(0x333333);
        }
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
        _textView.textColor = LG_ColorWithHex(0x333333);
    }
    return _textView;
}
@end
