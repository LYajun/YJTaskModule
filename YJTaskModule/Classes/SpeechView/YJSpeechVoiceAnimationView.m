//
//  YJSpeechVoiceAnimationView.m
//  YJTaskModule_Example
//
//  Created by 刘亚军 on 2020/7/17.
//  Copyright © 2020 lyj. All rights reserved.
//

#import "YJSpeechVoiceAnimationView.h"
@interface YJSpeechVoiceAnimationView ()
{
    NSMutableArray *_heights;
    
    CGFloat _minHeight;
    CGFloat _heightInterval;
    CGFloat _currentHeight;
    
    CADisplayLink *_displayLink;
    NSInteger _counter;
    NSInteger _lineCount;
    CGFloat _lineWidth;
    CGFloat _lineSpace;
}

@end
@implementation YJSpeechVoiceAnimationView
- (void)startAnimating {
    _animating = YES;
    
    [self resetHeights];
    
    _displayLink.paused = NO;
}

- (void)stopAnimating {
    _animating = NO;
    
    _displayLink.paused = YES;
    
    [self resetHeights];
}

- (void)dealloc
{
    _displayLink.paused = YES;
    [_displayLink invalidate];
    _displayLink = nil;
    
    [self removeObserver:self forKeyPath:@"bounds"];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAction)];
        [_displayLink addToRunLoop:NSRunLoop.currentRunLoop forMode:NSRunLoopCommonModes];
        _displayLink.paused = YES;
        
        _lineWidth = 3.0f;
        _lineSpace = 8.0f;
        
        [self resetHeights];
        
        [self addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    [self resetHeights];
}

- (void)resetHeights {
    _lineCount = CGRectGetWidth(self.bounds) / (_lineWidth + _lineSpace);
    
    _minHeight = CGRectGetHeight(self.bounds) / 3.0;
    _heightInterval = _minHeight;
    _currentHeight = _minHeight;
    
    _heights = [@[@(_currentHeight)] mutableCopy];
    for (NSInteger i = 0; i < _lineCount; i ++) {
        [self updateHeights];
    }
}

- (void)displayLinkAction {
    _counter ++;
    
    if (_counter % 10 == 0) {
        [self updateHeights];
    }
}

- (void)updateHeights {
    if (_currentHeight >= CGRectGetHeight(self.bounds)) {
        _heightInterval = -1 * _heightInterval;
    } else if (_currentHeight <= _minHeight) {
        _heightInterval = fabs(_heightInterval);
    }
    _currentHeight = _currentHeight + _heightInterval;
    if (_heights.count == _lineCount) {
        [_heights removeObjectAtIndex:0];
    }
    [_heights addObject:@(_currentHeight)];
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, self.bounds);
    [UIColor.whiteColor setFill];
    CGContextFillRect(context, rect);
    
    CGContextSetRGBFillColor(context, 255/255.0f, 142/255.0f, 0/255.0f, 1.0f);
    CGContextSetLineWidth(context, _lineWidth);
    
    CGFloat space = _lineSpace;
    for (NSInteger i = 0; i < _heights.count; i ++) {
        CGFloat height = [_heights[i] doubleValue];
        CGFloat lineHeight = MAX(_minHeight, height);
        CGFloat lineX = space + (space + _lineWidth) * i;
        CGFloat lineY = (CGRectGetHeight(self.bounds) - lineHeight) / 2;
        CGRect rect = CGRectMake(lineX, lineY, _lineWidth, lineHeight);
        CGContextFillRect(context, rect);
    }
}

@end
