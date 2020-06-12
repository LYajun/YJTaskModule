//
//  YJTaskTitleView.m
//  YJTaskKit
//
//  Created by 刘亚军 on 2018/7/27.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "YJTaskTitleView.h"
#import <Masonry/Masonry.h>
#import "YJConst.h"


@interface YJTaskMarqueeLabel ()<UIScrollViewDelegate>{
    NSTimer *_timer;
    UIScrollView *_scrollV;
    UILabel *_label1;
    CGSize _scrollViewCcontentSize;
    CGFloat x;
    UILabel *_label2;
    BOOL _isRight;
}

@end
@implementation YJTaskMarqueeLabel

- (instancetype)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

-(void)commonInit{
    self.marqueeLabelType = YJTaskMarqueeLabelTypeLeft;
    self.secondLabelInterval = 44;
    self.speed = 0.3f;
    self.stopTime = 1.5f;
}

-(UILabel *)comnInitLabel:(UILabel *)label {
    label = [[UILabel alloc]initWithFrame:self.bounds];
    label.text = self.text;
    label.font = self.font;
    label.textColor = self.textColor;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    return label;
}

-(void)drawTextInRect:(CGRect)rect {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    CGFloat height = self.bounds.size.height;
    CGFloat width = self.bounds.size.width;
    
    x = 0;
    _label1 = [self comnInitLabel:_label1];
    if (self.marqueeLabelType == YJTaskMarqueeLabelTypeLeft) {
        _label2 = [self comnInitLabel:_label2];
    }
    
    CGSize size = [_label1 sizeThatFits:CGSizeMake(MAXFLOAT,height)];
    
    //如果字符串的宽度小于或等于自身的宽度
    if (size.width <= width) {
        _label1 = nil;
        _label2 = nil;
        [super drawTextInRect:rect];
        return;
    }
    
    _scrollV = [[UIScrollView alloc]initWithFrame:self.bounds];
    _scrollV.delegate = self;
    if (self.marqueeLabelType == YJTaskMarqueeLabelTypeLeft) {
        _scrollViewCcontentSize = CGSizeMake(size.width+width+self.secondLabelInterval, size.height);
    }else {
        _scrollViewCcontentSize = CGSizeMake(size.width, size.height);
    }
    _scrollV.contentSize = _scrollViewCcontentSize;
    
    [self addSubview:_scrollV];
    
    CGRect rect1 =  _label1.frame;
    rect1.size.width = size.width;
    _label1.frame = rect1;
    [_scrollV addSubview:_label1];
    
    if (self.marqueeLabelType == YJTaskMarqueeLabelTypeLeft) {
        CGRect rect2 =  _label2.frame;
        rect2.size.width = width;
        rect2.origin.x = size.width + self.secondLabelInterval;
        _label2.frame = rect2;
        [_scrollV addSubview:_label2];
    }
    
    [self Timer];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    x = scrollView.contentOffset.x;
    [self Timer];
}

-(void)Timer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(refreshMarqueeLabelFrame) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

-(void)FistTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:self.stopTime target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];
}
- (void)invalidateTimer{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}


-(void)delayMethod {
    [self Timer];
}

- (void)refreshMarqueeLabelFrame {
    
    if (self.marqueeLabelType == YJTaskMarqueeLabelTypeLeft) {
        
        x += self.speed;
        if (x > _scrollViewCcontentSize.width - _scrollV.bounds.size.width) {
            [self FistTimer];
            x = 0;
        }
        [_scrollV setContentOffset:CGPointMake(x, 0)];
        
    }else {
        if (_isRight) {
            x -= self.speed;
        }else {
            x += self.speed;
        }
        
        if (x > _scrollViewCcontentSize.width - _scrollV.bounds.size.width) {
            [self FistTimer];
            _isRight = YES;
            return;
        }
        
        if (x <= 0) {
            [self FistTimer];
            _isRight = NO;
        }
        
        [_scrollV setContentOffset:CGPointMake(x, 0)];
    }
}

@end




@interface YJTaskTitleView ()
@property(nonatomic,strong) YJTaskMarqueeLabel *taskNameL;
@property(nonatomic,strong) UILabel *topicIndexL;

@property(nonatomic,strong) UIView *topicCardBgView;
@property(nonatomic,strong) UIView *botLine;
@end
@implementation YJTaskTitleView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self layoutUI];
    }
    return self;
}
- (void)dealloc{
    [self.taskNameL invalidateTimer];
}
- (void)layoutUI{
    [self addSubview:self.topicCardBgView];
    [self.topicCardBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.top.equalTo(self);
        make.right.equalTo(self.mas_right).offset(-8);
        make.width.mas_equalTo(35);
    }];
    [self.topicCardBgView addSubview:self.topicCarkBtn];
    [self.topicCarkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerY.equalTo(self.topicCardBgView);
         make.right.equalTo(self.topicCardBgView);
        make.width.height.mas_equalTo(25);
    }];
    UIView *lineImage = [UIView new];
    lineImage.backgroundColor = LG_ColorWithHex(0xE0E0E0);
    [self.topicCardBgView addSubview:lineImage];
    [lineImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topicCardBgView);
        make.left.equalTo(self.topicCardBgView);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(1);
    }];
    
    [self addSubview:self.topicIndexL];
    [self.topicIndexL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.top.equalTo(self);
        make.right.equalTo(self.topicCardBgView.mas_left).offset(-8);
        make.width.mas_equalTo(50);
    }];
    [self addSubview:self.taskNameL];
    [self.taskNameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.top.equalTo(self);
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.topicIndexL.mas_left).offset(-10);
    }];
    
    [self addSubview:self.botLine];
    [self.botLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.left.bottom.equalTo(self);
        make.height.mas_equalTo(0.6);
    }];
}
- (void)setBotLineable:(BOOL)botLineable{
    _botLineable = botLineable;
    self.botLine.hidden = !botLineable;
}
- (void)setIndexable:(BOOL)indexable{
    _indexable = indexable;
    self.topicIndexL.hidden = !indexable;
    [self.topicIndexL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(indexable ? 60:0);
        make.right.equalTo(self.topicCardBgView.mas_left).offset(indexable ? -8 : -2);
    }];
}
- (void)setCarkable:(BOOL)carkable{
    _carkable = carkable;
    [self.topicCardBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(carkable ? 35:0);
    }];
    self.topicCardBgView.hidden = !carkable;
    if (carkable) {
        self.taskNameL.textColor = LG_ColorWithHex(0x989898);
    }else{
        self.taskNameL.textColor = LG_ColorWithHex(0x989898);
    }
}
- (void)setTaskName:(NSString *)taskName{
    _taskName = taskName;
    self.taskNameL.text = taskName;
}
- (void)setTopicIndexAttr:(NSAttributedString *)topicIndexAttr{
    _topicIndexAttr = topicIndexAttr;
    self.topicIndexL.attributedText = topicIndexAttr;
}
- (void)topicCarkClickAction{
    if (self.topicCardClickBlock) {
        self.topicCardClickBlock();
    }
}
- (UIView *)botLine{
    if (!_botLine) {
        _botLine = [UIView new];
        _botLine.backgroundColor = LG_ColorWithHex(0xE5E5E5);
    }
    return _botLine;
}
- (YJTaskMarqueeLabel *)taskNameL {
    if (!_taskNameL) {
        _taskNameL = [[YJTaskMarqueeLabel alloc] init];
        _taskNameL.font = [UIFont systemFontOfSize:14];
        _taskNameL.textColor = LG_ColorWithHex(0x989898);
        _taskNameL.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
    return _taskNameL;
}
- (UILabel *)topicIndexL{
    if (!_topicIndexL) {
        _topicIndexL = [UILabel new];
        _topicIndexL.textAlignment = NSTextAlignmentRight;
    }
    return _topicIndexL;
}
- (UIView *)topicCardBgView{
    if (!_topicCardBgView) {
        _topicCardBgView = [UIView new];
    }
    return _topicCardBgView;
}
- (UIButton *)topicCarkBtn{
    if (!_topicCarkBtn) {
        _topicCarkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_topicCarkBtn setImage:[UIImage yj_imageNamed:@"lg_topiccark" atDir:YJTaskBundle_Cell atBundle:YJTaskBundle()] forState:UIControlStateNormal];
        [_topicCarkBtn addTarget:self action:@selector(topicCarkClickAction) forControlEvents:UIControlEventTouchDown];
    }
    return _topicCarkBtn;
}
@end
