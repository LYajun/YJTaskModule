//
//  ZH_BaseTableViewCell.m
//  LGEducationCenter
//
//  Created by 刘亚军 on 2017/3/20.
//  Copyright © 2017年 刘亚军. All rights reserved.
//

#import "LGBaseTableViewCell.h"
#import "YJConst.h"


@implementation LGBaseHighlightBtn

- (void)setHighlighted:(BOOL)highlighted{};

@end


@implementation LGBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self defaultSetup];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self defaultSetup];
    }
    return self;
}
- (void)defaultSetup{
    _isShowSeparator = NO;
    _separatorOffset = 0;
    _separatorWidth = 0.8;
    _sepColor = [UIColor yj_colorWithHex:0xdcdcdc];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (void)drawRect:(CGRect)rect{
//    if (!_isShowSeparator) return;
    CGFloat width = self.separatorWidth;
    if (!self.isShowSeparator) {
        width = 0;
    }
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:CGRectMake(self.separatorOffset, rect.size.height - width, rect.size.width-self.separatorOffset*2, width)];
    [self.sepColor setFill];
    [bezierPath fillWithBlendMode:kCGBlendModeNormal alpha:1];
    [bezierPath closePath];
}
- (void)setIsShowSeparator:(BOOL)isShowSeparator{
    _isShowSeparator = isShowSeparator;
    [self setNeedsDisplay];
}
- (void)setSeparatorOffset:(CGFloat)separatorOffset{
    _separatorOffset = separatorOffset;
    [self setNeedsDisplay];
}
- (void)setSeparatorWidth:(CGFloat)separatorWidth{
    _separatorWidth = separatorWidth;
    [self setNeedsDisplay];
}
- (void)setSepColor:(UIColor *)sepColor{
    _sepColor = sepColor;
    [self setNeedsDisplay];
}
@end
