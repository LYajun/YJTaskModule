//
//  YJTalkImageDeleteView.m
//  LGEducationCloud
//
//  Created by 刘亚军 on 2019/4/28.
//  Copyright © 2019 lange. All rights reserved.
//

#import "YJTalkImageDeleteView.h"
#import <Masonry/Masonry.h>
#import "YJConst.h"

@interface YJTalkImageDeleteView ()
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,assign) BOOL isBottom;
@end
@implementation YJTalkImageDeleteView
- (instancetype)initWithFrame:(CGRect)frame atBottom:(BOOL)isBottom{
    if (self = [super initWithFrame:frame]) {
        self.isBottom = isBottom;
        self.backgroundColor = LG_ColorWithHex(0xFA8072);
        [self addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self).offset(isBottom ? -15 : -5);
            make.height.mas_equalTo(18);
        }];
        [self addSubview:self.imgView];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self.titleLab.mas_top).offset(-3);
            make.height.mas_equalTo(24);
        }];
    }
    return self;
}
+ (YJTalkImageDeleteView *)showTalkImageDeleteViewAtBottom:(BOOL)isBottom{
    for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([view isKindOfClass:YJTalkImageDeleteView.class]) {
            [view removeFromSuperview];
        }
    }
    CGFloat height = [YJTalkImageDeleteView deleteViewHeight];
    CGFloat y = -[YJTalkImageDeleteView deleteViewHeight];
    if (isBottom) {
        height = 74;
        y = LG_ScreenHeight;
    }
    YJTalkImageDeleteView *deleteView = [[YJTalkImageDeleteView alloc] initWithFrame:CGRectMake(0, y, LG_ScreenWidth, height) atBottom:isBottom];
    [deleteView show];
    return deleteView;
}
+ (CGFloat)deleteViewHeight{
    return ([self yj_isIPhoneX] ? 24 : 0) + 64 + 10;
}
+ (BOOL)yj_isIPhoneX{
    if ((MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) >= 375 &&
         MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) >= 812)) {
        return YES;
    }
    return NO;
}
- (void)setDeleteViewDeleteState{
    self.imgView.highlighted = YES;
    self.titleLab.text = @"松手即可删除";
}
- (void)setDeleteViewNormalState{
    self.imgView.highlighted = NO;
    self.titleLab.text = @"拖到此处删除";
}
- (void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        if (self.isBottom) {
            self.transform = CGAffineTransformTranslate(self.transform, 0, - 74);
        }else{
            self.transform = CGAffineTransformTranslate(self.transform, 0, [YJTalkImageDeleteView deleteViewHeight]);
        }
    }];
}
- (void)hide{
    [UIView animateWithDuration:0.25 animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.text = @"拖到此处删除";
        _titleLab.font = [UIFont systemFontOfSize:16];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.textColor = [UIColor whiteColor];
    }
    return _titleLab;
}
- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithImage:[UIImage yj_imageNamed:@"wc_drag_delete" atDir:YJTaskBundle_Cell atBundle:YJTaskBundle()] highlightedImage:[UIImage yj_imageNamed:@"wc_drag_delete_activate" atDir:YJTaskBundle_Cell atBundle:YJTaskBundle()]];
    }
    return _imgView;
}
@end
