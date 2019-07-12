//
//  YJStatisticTopicClassLookTopicDetailCell.m
//  LGTeachCloud
//
//  Created by 刘亚军 on 2019/5/24.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "YJStatisticTopicClassLookTopicDetailCell.h"
#import <Masonry/Masonry.h>


@interface YJStatisticTopicClassLookTopicDetailCell ()

@property (nonatomic,strong) UILabel *contentL;

@end
@implementation YJStatisticTopicClassLookTopicDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.contentL];
        [self.contentL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.top.equalTo(self.contentView).offset(5);
        }];
    }
    return self;
}
- (void)setTextAttr:(NSAttributedString *)textAttr{
    _textAttr = textAttr;
    self.contentL.attributedText = textAttr;
}
- (UILabel *)contentL{
    if (!_contentL) {
        _contentL = [UILabel new];
        _contentL.numberOfLines = 0;
    }
    return _contentL;
}

@end
