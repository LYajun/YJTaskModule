//
//  YJSpeechTalkListCell.m
//  YJTaskModule_Example
//
//  Created by 刘亚军 on 2020/7/17.
//  Copyright © 2020 lyj. All rights reserved.
//

#import "YJSpeechTalkListCell.h"
#import "YJConst.h"
#import <Masonry/Masonry.h>
#import "YJSpeechTalkModel.h"

@interface YJSpeechTalkListCell ()
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *contentLab;
@end
@implementation YJSpeechTalkListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self layoutUI];
    }
    return self;
}
- (void)layoutUI{
    [self.contentView addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView).offset(10);
        make.height.mas_equalTo(30);
    }];
    
    [self.contentView addSubview:self.contentLab];
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.left.equalTo(self.titleLab);
        make.top.equalTo(self.titleLab.mas_bottom).offset(5);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    
    self.titleLab.text = @"张三(20949595)";
    self.contentLab.text = @"阿杀手锏好卡拉手机打开类数据，爱神的箭。 索拉卡的静安寺枯鲁杜鹃 啦圣诞节快乐撒娇的卡萨丁";
}
- (void)setTalkModel:(YJSpeechTalkModel *)talkModel{
    _talkModel = talkModel;
    NSMutableAttributedString *nameAttr = talkModel.userName.yj_toMutableAttributedString;
    [nameAttr yj_setFont:16];
    [nameAttr yj_setColor:LG_ColorWithHex(0x414141)];
    NSMutableAttributedString *idAttr = [NSString stringWithFormat:@"(%@)",talkModel.userID].yj_toMutableAttributedString;
    [idAttr yj_setFont:14];
    [idAttr yj_setColor:LG_ColorWithHex(0x989898)];
    [nameAttr appendAttributedString:idAttr];
    self.titleLab.attributedText = nameAttr;
    self.contentLab.text = talkModel.evaluation;
}
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
    }
    return _titleLab;
}
- (UILabel *)contentLab{
    if (!_contentLab) {
        _contentLab = [UILabel new];
        _contentLab.numberOfLines = 0;
        _contentLab.textColor = LG_ColorWithHex(0x414141);
        _contentLab.font = LG_SysFont(16);
    }
    return _contentLab;
}
@end
