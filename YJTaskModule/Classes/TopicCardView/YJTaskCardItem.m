//
//  YJTaskCardItem.m
//
//
//  Created by 刘亚军 on 2018/8/1.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "YJTaskCardItem.h"
#import "YJImageLabel.h"

#import <Masonry/Masonry.h>
#import "YJConst.h"

@interface YJTaskCardItem ()
@property (strong, nonatomic) YJImageLabel *indexL;
@property (strong, nonatomic) UIImageView *curentImage;
@end

@implementation YJTaskCardItem
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.indexL = [YJImageLabel new];
        self.indexL.fontSize = 17;
        self.indexL.textColor = LG_ColorWithHex(0x252525);
        self.indexL.bgImageName = @"lg_answer_card_nsel";
        [self.contentView addSubview:self.indexL];
        [self.indexL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
            if (IsIPad) {
                make.left.equalTo(self.contentView.mas_left).offset(7);
                make.top.equalTo(self.contentView.mas_top).offset(7);
            }else{
                make.left.equalTo(self.contentView.mas_left).offset(10);
                make.top.equalTo(self.contentView.mas_top).offset(10);
            }
        }];
        [self.indexL layoutIfNeeded];
        [self.indexL yj_clipLayerWithRadius:self.indexL.bounds.size.width/2 width:0 color:nil];
        
        self.curentImage = [[UIImageView alloc] initWithImage:[UIImage yj_imageNamed:@"lg_answer_card_ssanjiao" atDir:YJTaskBundle_Cell atBundle:YJTaskBundle()]];
        [self.contentView addSubview:self.curentImage];
        [self.curentImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.bottom.equalTo(self.contentView);
            if (IsIPad) {
                make.width.mas_equalTo(9);
                make.height.mas_equalTo(5);
            }else{
                make.width.height.mas_equalTo(8);
            }
        }];
        self.curentImage.hidden = YES;
    }
    return self;
}

- (void)setIsCurrentTopic:(BOOL)isCurrentTopic{
    _isCurrentTopic = isCurrentTopic;
    self.curentImage.hidden = !isCurrentTopic;
}

- (void)setIndex:(NSInteger)index{
    _index = index;
    self.indexL.textStr = [NSString stringWithFormat:@"%li",index];
}

- (void)setIsFinishAnswer:(BOOL)isFinishAnswer{
    _isFinishAnswer = isFinishAnswer;
    if (_isFinishAnswer) {
        self.indexL.bgImageName = @"lg_answer_card_sel";
        self.indexL.textColor = [UIColor whiteColor];
    }else{
        self.indexL.bgImageName = @"lg_answer_card_nsel";
        self.indexL.textColor = LG_ColorWithHex(0x40A0EF);
    }
}
@end
