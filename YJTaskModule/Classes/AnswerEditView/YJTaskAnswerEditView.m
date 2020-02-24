//
//  YJTaskAnswerEditView.m
//  YJTaskKit
//
//  Created by 刘亚军 on 2018/7/31.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "YJTaskAnswerEditView.h"

#import <Masonry/Masonry.h>
#import "YJConst.h"

@interface YJTaskAnswerEditView ()<LGBaseTextViewDelegate>
{
    CGFloat keyboardY;
}
@property (nonatomic,strong) UIButton *sureButton;
@end
@implementation YJTaskAnswerEditView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = LG_ColorWithHex(0xF0F0F0);
        [self layoutUI];
        [self addNotification];
    }
    return self;
}
- (void)layoutUI{
    UIButton *touchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [touchBtn setTitle:@"" forState:UIControlStateNormal];
    [self addSubview:touchBtn];
    [touchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self addSubview:self.sureButton];
    [self addSubview:self.textView];
    
    [self.textView becomeFirstResponder];
    
    [self.sureButton yj_clipLayerWithRadius:3 width:0 color:nil];
}
- (void)changeFrame:(CGFloat)height{
    CGFloat maxH = 0;
    if (self.maxVisibleLine) {
        maxH = ceil(self.textView.font.lineHeight * (self.maxVisibleLine - 1) + self.textView.textContainerInset.top + self.textView.textContainerInset.bottom);
    }
    self.textView.scrollEnabled = height >maxH && maxH >0;
    if (self.textView.scrollEnabled) {
        height = 5+maxH;
    }
    CGFloat totalH = height + self.textViewSpace *2;
    self.y = keyboardY - totalH - self.contentOffsetHeight;
    self.height = totalH;
    self.sureButton.y = (self.height - self.sureButton.height)/2;
    self.textView.y = self.textViewSpace;
    self.textView.height = height;
    [self.textView scrollRangeToVisible:NSMakeRange(0, self.textView.text.length)];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)addNotification{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (NSInteger)maxVisibleLine{
    return 3;
}
- (CGFloat)tabbarHeight{
    return 49;
}
- (CGFloat)textViewHeight{
    return 30;
}
- (CGFloat)textViewSpace{
    return (self.tabbarHeight - self.textViewHeight)/2;
}
- (void)sureAction{
    if (self.answerResultBlock) {
        NSString *text = self.textView.text;
        if (!IsStrEmpty(text) && IsStrEmpty([text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]])) {
            text = @"";
        }
        self.answerResultBlock(text);
    }
    if (self.keyboardHideBlock) {
        self.keyboardHideBlock();
    }
}
#pragma mark UITextViewDelegate
- (void)yj_textViewDidBeginEditing:(LGBaseTextView *)textView{
    [self changeFrame:ceilf([textView sizeThatFits:textView.frame.size].height)];
}
- (void)yj_textViewDidChange:(LGBaseTextView *)textView{
    self.sureButton.enabled = YES;
    [self changeFrame:ceilf([textView sizeThatFits:textView.frame.size].height)];
}
#pragma mark NSNotification
-(void)keyboardWillChangeFrame:(NSNotification *)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardY = keyboardF.origin.y;
    
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        // 工具条的Y值 == 键盘的Y值 - 工具条的高度
        self.y = keyboardF.origin.y - self.height - self.contentOffsetHeight;
    }];
}
- (CGFloat)contentOffsetHeight{
    return LG_ScreenHeight - self.superview.height;
}
-(void)keyboardDidChangeFrame:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.y = keyboardF.origin.y - self.height - self.contentOffsetHeight;
}
-(void)keyboardWillHide:(NSNotification *)notification{
    if (self.keyboardHideBlock) {
        self.keyboardHideBlock();
    }
}
- (LGBaseTextView *)textView{
    if (!_textView) {
        CGFloat w = CGRectGetMinX(self.sureButton.frame) - 20;
        CGFloat h = self.textViewHeight;
        CGFloat x = 10;
        CGFloat y = (self.tabbarHeight-h)/2;
        _textView = [[LGBaseTextView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        _textView.font = [UIFont systemFontOfSize:17];
        _textView.placeholder = @"请输入...";
//        _textView.maxLength = 200;
        _textView.limitType = YJTextViewLimitTypeEmojiLimit;
        [_textView yj_clipLayerWithRadius:4 width:0.5 color:LG_ColorWithHex(0xA5A5A5)];
        _textView.yjDelegate = self;
        [_textView deleteAccessoryView];
    }
    return _textView;
}
- (UIButton *)sureButton{
    if (!_sureButton) {
        CGFloat w = 50;
        CGFloat h = self.textViewHeight;
        CGFloat x = LG_ScreenWidth-w-10;
        CGFloat y = (self.tabbarHeight-h)/2;
        _sureButton = [[UIButton alloc] initWithFrame:CGRectMake(x, y, w, h)];
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sureButton setTitleColor:LG_ColorWithHex(0x999999) forState:UIControlStateDisabled];
        [_sureButton setBackgroundImage:[UIImage yj_imageWithColor:LG_ColorWithHex(0x23a1fa) size:CGSizeMake(100, 40)] forState:UIControlStateNormal];
        [_sureButton setBackgroundImage:[UIImage yj_imageWithColor:LG_ColorWithHex(0xcccccc) size:CGSizeMake(100, 40)] forState:UIControlStateDisabled];
        [_sureButton addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
        _sureButton.enabled = NO;
    }
    return _sureButton;
}
@end
