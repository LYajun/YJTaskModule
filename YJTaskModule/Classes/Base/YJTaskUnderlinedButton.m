//
//  YJTaskUnderlinedButton.m
//  YJTaskModule_Example
//
//  Created by 刘亚军 on 2020/7/24.
//  Copyright © 2020 lyj. All rights reserved.
//

#import "YJTaskUnderlinedButton.h"

@implementation YJTaskUnderlinedButton

- (void)drawRect:(CGRect)rect {
    CGRect textRect = self.titleLabel.frame;
    
    CGFloat textWidth = [self.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleLabel.font} context:nil].size.width;
    
    // need to put the line at top of descenders (negative value)
    CGFloat descender = self.titleLabel.font.descender + 2 + self.lineSpace;
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    // set to same colour as text
    CGContextSetStrokeColorWithColor(contextRef, self.lineColor.CGColor);
    
    CGContextMoveToPoint(contextRef, textRect.origin.x, textRect.origin.y + textRect.size.height + descender);
    
    CGContextAddLineToPoint(contextRef, textRect.origin.x + textWidth, textRect.origin.y + textRect.size.height + descender);
    
    CGContextClosePath(contextRef);
    CGContextDrawPath(contextRef, kCGPathStroke);
}
- (void)setLineSpace:(CGFloat)lineSpace{
    _lineSpace = lineSpace;
    [self setNeedsDisplay];
}
- (void)setTitle:(NSString *)title forState:(UIControlState)state{
    [super setTitle:title forState:state];
    [self setNeedsDisplay];
}
- (void)setLineColor:(UIColor *)lineColor{
    _lineColor = lineColor;
    [self setNeedsDisplay];
}
@end
