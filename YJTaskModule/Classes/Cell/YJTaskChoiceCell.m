//
//  YJTaskChoiceCell.m
//  YJTaskKit
//
//  Created by 刘亚军 on 2018/7/27.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "YJTaskChoiceCell.h"
#import "YJTaskChoiceLabel.h"
#import <Masonry/Masonry.h>
#import "YJConst.h"

@interface YJTaskChoiceCell ()
@property (nonatomic,strong) UITextView *textView;
@property (nonatomic,strong) YJTaskChoiceLabel *choiceLab;
@end
@implementation YJTaskChoiceCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self layoutUI];
    }
    return self;
}
- (void)layoutUI{
    [self.contentView addSubview:self.choiceLab];
    [self.choiceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(3);
        make.width.height.mas_equalTo(LabHeight);
        make.left.equalTo(self.contentView).offset(10);
    }];
    [self.contentView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.choiceLab.mas_right).offset(5);
        make.top.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-10);
        make.height.greaterThanOrEqualTo(@44);
    }];
    
    BOOL isHideIndexBgImg = [NSUserDefaults yj_boolForKey:YJTaskModule_ImageLabelBgHidden_UserDefault_Key];
    self.choiceLab.isHideIndexBgImg = isHideIndexBgImg;
}
- (void)setIsChoiced:(BOOL)isChoiced{
    _isChoiced = isChoiced;
    self.choiceLab.isChoiced = isChoiced;
}
- (void)setIsRight:(BOOL)isRight{
    _isRight = isRight;
    self.choiceLab.isRight = isRight;
}
- (void)setIndex:(NSInteger)index{
    _index = index;
     self.choiceLab.index = index;
}
- (void)setTextAttr:(NSMutableAttributedString *)textAttr{
    _textAttr = textAttr;
    [textAttr yj_setFont:16];
    self.textView.attributedText = textAttr;
}
- (YJTaskChoiceLabel *)choiceLab{
    if (!_choiceLab) {
        _choiceLab = [[YJTaskChoiceLabel alloc] initWithFrame:CGRectZero];
        _choiceLab.fontSize = 16;
    }
    return _choiceLab;
}
- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectZero];
        _textView.editable = NO;
        _textView.selectable = NO;
        _textView.scrollEnabled = NO;
        _textView.userInteractionEnabled = NO;
    }
    return _textView;
}
@end
