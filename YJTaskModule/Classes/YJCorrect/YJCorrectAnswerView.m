//
//  YJCorrectAnswerView.m
//  LGEducationCloud
//
//  Created by 刘亚军 on 2019/4/23.
//  Copyright © 2019 lange. All rights reserved.
//

#import "YJCorrectAnswerView.h"
#import "LGBaseTextField.h"
#import "YJConst.h"

#define kMainWindow  [UIApplication sharedApplication].keyWindow
@interface YJCorrectAnswerView ()<LGBaseTextFieldDelegate>
/**  圆角半径 Default is 5.0 */
@property (nonatomic, assign) CGFloat cornerRadius;
/** 设置偏移距离 (>= 0) Default is 0.0 */
@property (nonatomic, assign) CGFloat offset;

@property (nonatomic, weak) id <YJCorrectAnswerViewDelegate> delegate;
@end
@implementation YJCorrectAnswerView
{
    UIView * _mainView;
    LGBaseTextField * _contentView;
    UIView * _bgView;
    
    CGPoint _anchorPoint;
    
    CGFloat kArrowHeight;
    CGFloat kArrowWidth;
    CGFloat kArrowPosition;
    
    UIColor * _contentColor;
}
@synthesize cornerRadius = kCornerRadius;

- (instancetype)initWithAnswerWidth:(CGFloat)width placehold:(NSString *)placehold delegate:(id<YJCorrectAnswerViewDelegate>)delegate{
    if (self = [super init]) {
        kArrowHeight = 10;
        kArrowWidth = 15;
        kCornerRadius = 5.0;
        
        _offset = 0.0;
        _contentColor = [UIColor whiteColor];
        
        if (delegate) self.delegate = delegate;
        
        self.width = width;
        
        self.height = 36 + 2 * kArrowHeight;
        
        kArrowPosition = 0.5 * self.width - 0.5 * kArrowWidth;
        
        self.alpha = 0;
        self.layer.shadowOpacity = 1.0;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowRadius = 1.0;
        self.layer.shadowColor = LG_ColorThemeBlue.CGColor;
        
        _mainView = [[UIView alloc] initWithFrame: self.bounds];
        _mainView.backgroundColor = _contentColor;
        _mainView.layer.cornerRadius = kCornerRadius;
        _mainView.layer.masksToBounds = YES;
        
        _contentView = [[LGBaseTextField alloc] initWithFrame:_mainView.bounds];
        _contentView.maxLength = 30;
        _contentView.placeholder = placehold;
        _contentView.tintColor = [UIColor lightGrayColor];
        _contentView.yjDelegate = self;
        _contentView.limitType = YJTextFieldLimitEmojiLimit;
        [_contentView deleteAccessoryView];
        _contentView.returnKeyType = UIReturnKeyDone;
        _contentView.height -= 2 * kArrowHeight;
        _contentView.width -= 10;
        _contentView.x += 10;
        _contentView.centerY = _mainView.centerY;
        
        [_mainView addSubview: _contentView];
        [self addSubview: _mainView];
        
        _bgView = [[UIView alloc] initWithFrame: [UIScreen mainScreen].bounds];
        
        _bgView.backgroundColor = [UIColor clearColor];
        _bgView.alpha = 0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(dismiss)];
        [_bgView addGestureRecognizer: tap];
    }
    return self;
}

- (void)dismiss{
    if (self.delegate && [self.delegate respondsToSelector:@selector(YJCorrectAnswerView:didFinishAnswer:)]) {
        [self.delegate YJCorrectAnswerView:self didFinishAnswer:_contentView.text];
    }
    [UIView animateWithDuration: 0.25 animations:^{
        self.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
        self.alpha = 0;
        _bgView.alpha = 0;
    } completion:^(BOOL finished) {
        self.delegate = nil;
        [self removeFromSuperview];
        [_bgView removeFromSuperview];
    }];
}

- (void)show {
    
    [_contentView becomeFirstResponder];
    
    [kMainWindow addSubview: _bgView];
    [kMainWindow addSubview: self];
    
    self.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration: 0.25 animations:^{
        self.layer.affineTransform = CGAffineTransformMakeScale(1.0, 1.0);
        self.alpha = 1;
        _bgView.alpha = 1;
    }];
}
- (void)showRelyOnView:(UIView *)view{
    CGRect absoluteRect = [view convertRect:view.bounds toView:kMainWindow];
    CGPoint relyPoint = CGPointMake(absoluteRect.origin.x + absoluteRect.size.width / 2, absoluteRect.origin.y + absoluteRect.size.height);
    _mainView.layer.mask = [self getMaskLayerWithPoint:relyPoint];

    if (self.y < _anchorPoint.y) {
        self.y -= absoluteRect.size.height;
    }
    [self show];
}

#pragma mark - LGBaseTextFieldDelegate
- (BOOL)yj_textFieldShouldBeginEditing:(LGBaseTextField *)textField{
    if (self.delegate && [self.delegate respondsToSelector:@selector(YJCorrectAnswerViewBeginEditing)]) {
        [self.delegate YJCorrectAnswerViewBeginEditing];
    }
    return YES;
}
- (BOOL)yj_textFieldShouldReturn:(LGBaseTextField *)textField{
    
    [self dismiss];
    
    return NO;
}

#pragma mark - Setter & Getter
- (void)setOffset:(CGFloat)offset{
    _offset = offset;
    if (offset < 0) {
        offset = 0.0;
    }
    self.y += self.y >= _anchorPoint.y ? offset : -offset;
}
- (void)setCornerRadius:(CGFloat)cornerRadius{
    kCornerRadius = cornerRadius;
    _mainView.layer.mask = [self drawMaskLayer];
    if (self.y < _anchorPoint.y) {
        _mainView.layer.mask.affineTransform = CGAffineTransformMakeRotation(M_PI);
    }
}

- (void)setArrowPointingWhere: (CGPoint)anchorPoint{
    _anchorPoint = anchorPoint;
    
    self.x = anchorPoint.x - kArrowPosition - 0.5*kArrowWidth;
    self.y = anchorPoint.y;
    
    CGFloat maxX = CGRectGetMaxX(self.frame);
    CGFloat minX = CGRectGetMinX(self.frame);
    
    if (maxX > LG_ScreenWidth - 10) {
        self.x = LG_ScreenWidth - 10 - self.width;
    }else if (minX < 10) {
        self.x = 10;
    }
    
    maxX = CGRectGetMaxX(self.frame);
    minX = CGRectGetMinX(self.frame);
    
    if ((anchorPoint.x <= maxX - kCornerRadius) && (anchorPoint.x >= minX + kCornerRadius)) {
        kArrowPosition = anchorPoint.x - minX - 0.5*kArrowWidth;
    }else if (anchorPoint.x < minX + kCornerRadius) {
        kArrowPosition = kCornerRadius;
    }else {
        kArrowPosition = self.width - kCornerRadius - kArrowWidth;
    }
}

- (void)setAnimationAnchorPoint:(CGPoint)point{
    CGRect originRect = self.frame;
    self.layer.anchorPoint = point;
    self.frame = originRect;
}

- (void)determineAnchorPoint{
    CGPoint aPoint = CGPointMake(0.5, 0.5);

    if (CGRectGetMaxY(self.frame) < 0) {
        aPoint = CGPointMake(fabs(kArrowPosition) / self.width, 0);
    }else {
        aPoint = CGPointMake(fabs(kArrowPosition) / self.width, 1);
    }
    [self setAnimationAnchorPoint:aPoint];
}
- (CAShapeLayer *)getMaskLayerWithPoint:(CGPoint)point{
    [self setArrowPointingWhere:point];
    CAShapeLayer *layer = [self drawMaskLayer];
    [self determineAnchorPoint];
    if (CGRectGetMaxY(self.frame) < 0) {
        
        kArrowPosition = self.width - kArrowPosition - kArrowWidth;
        layer = [self drawMaskLayer];
        layer.affineTransform = CGAffineTransformMakeRotation(M_PI);
        self.y = _anchorPoint.y + self.height;
    }else{
        kArrowPosition = self.width - kArrowPosition - kArrowWidth;
        layer = [self drawMaskLayer];
        layer.affineTransform = CGAffineTransformMakeRotation(M_PI);
        self.y = _anchorPoint.y - self.height;
    }
    self.y += self.y >= _anchorPoint.y ? _offset : -_offset;
 
    return layer;
}
- (CAShapeLayer *)drawMaskLayer{
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = _mainView.bounds;
    CGPoint topRightArcCenter = CGPointMake(self.width-kCornerRadius, kArrowHeight+kCornerRadius);
    CGPoint topLeftArcCenter = CGPointMake(kCornerRadius, kArrowHeight+kCornerRadius);
    CGPoint bottomRightArcCenter = CGPointMake(self.width-kCornerRadius, self.height - kArrowHeight - kCornerRadius);
    CGPoint bottomLeftArcCenter = CGPointMake(kCornerRadius, self.height - kArrowHeight - kCornerRadius);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(0, kArrowHeight+kCornerRadius)];
    [path addLineToPoint: CGPointMake(0, bottomLeftArcCenter.y)];
    [path addArcWithCenter: bottomLeftArcCenter radius: kCornerRadius startAngle: -M_PI endAngle: -M_PI-M_PI_2 clockwise: NO];
    [path addLineToPoint: CGPointMake(self.width-kCornerRadius, self.height - kArrowHeight)];
    [path addArcWithCenter: bottomRightArcCenter radius: kCornerRadius startAngle: -M_PI-M_PI_2 endAngle: -M_PI*2 clockwise: NO];
    [path addLineToPoint: CGPointMake(self.width, kArrowHeight+kCornerRadius)];
    [path addArcWithCenter: topRightArcCenter radius: kCornerRadius startAngle: 0 endAngle: -M_PI_2 clockwise: NO];
    [path addLineToPoint: CGPointMake(kArrowPosition+kArrowWidth, kArrowHeight)];
    [path addLineToPoint: CGPointMake(kArrowPosition+0.5*kArrowWidth, 0)];
    [path addLineToPoint: CGPointMake(kArrowPosition, kArrowHeight)];
    [path addLineToPoint: CGPointMake(kCornerRadius, kArrowHeight)];
    [path addArcWithCenter: topLeftArcCenter radius: kCornerRadius startAngle: -M_PI_2 endAngle: -M_PI clockwise: NO];
    
    [path closePath];
    
    maskLayer.path = path.CGPath;
    
    return maskLayer;
}
@end
