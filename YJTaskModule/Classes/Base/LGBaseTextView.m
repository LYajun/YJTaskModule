//
//  ZH_BaseTextView.m
//  LGEducationCenter
//
//  Created by 刘亚军 on 2017/3/17.
//  Copyright © 2017年 刘亚军. All rights reserved.
//

#import "LGBaseTextView.h"
#import "YJConst.h"
#import <LGAlertHUD/LGAlertHUD.h>
@interface LGBaseTextView ()<UITextViewDelegate>
{
    UILabel *placeHolderLabel;
}
@property (nonatomic, strong) UIToolbar *customAccessoryView;
@property (nonatomic, strong) UIButton *clearBtn;
@property (nonatomic, strong) UIButton *shouqiBtn;
-(void)refreshPlaceholder;
@end
@implementation LGBaseTextView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.inputAccessoryView = self.customAccessoryView;
        [self initialize];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.inputAccessoryView = self.customAccessoryView;
        [self initialize];
    }
    return self;
}
- (UIToolbar *)customAccessoryView{
    if (!_customAccessoryView) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        _customAccessoryView = [[UIToolbar alloc]initWithFrame:(CGRect){0,0,width,40}];
        _customAccessoryView.barTintColor = [UIColor whiteColor];
        
        UIBarButtonItem *clear = [[UIBarButtonItem alloc]initWithTitle:@"清空" style:UIBarButtonItemStyleDone target:self action:@selector(clearAction)];
        UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *finish = [[UIBarButtonItem alloc]initWithTitle:@"收起" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
        [_customAccessoryView setItems:@[clear,space,finish]];
        
    }
    return _customAccessoryView;
}
//- (UIButton *)clearBtn{
//    if (!_clearBtn) {
//        _clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _clearBtn.frame
//        [_clearBtn setTitle:@"清空" forState:UIControlStateNormal];
//        [_clearBtn setTitleColor:LG_ColorWithHex(0x8B8E98) forState:UIControlStateNormal];
//        _clearBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//        [_clearBtn addTarget:self action:@selector(clearAction) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _clearBtn;
//}
//- (UIButton *)shouqiBtn{
//    if (!_shouqiBtn) {
//        _shouqiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        
//        [_shouqiBtn addTarget:self action:@selector(clearAction) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _shouqiBtn;
//}
- (void)deleteAccessoryView{
    self.inputAccessoryView = nil;
}
- (void)clearAction{
    self.text = @"";
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.delegate textViewDidChange:self];
    }
}
- (void)done{
    [self resignFirstResponder];
}
-(void)initialize
{
    self.delegate = self;
    self.maxLength = NSUIntegerMax;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPlaceholder) name:UITextViewTextDidChangeNotification object:self];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)refreshPlaceholder
{
    if([[self text] length])
    {
        [placeHolderLabel setAlpha:0];
    }
    else
    {
        [placeHolderLabel setAlpha:1];
    }
    @try {
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self refreshPlaceholder];
}

-(void)setFont:(UIFont *)font
{
    [super setFont:font];
    placeHolderLabel.font = self.font;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if (IsStrEmpty(self.placeholder)) {
        self.placeholder = @"请输入...";
    }
    [placeHolderLabel sizeToFit];
    if (self.placeholdOrigin.x > 0 || self.placeholdOrigin.y > 0) {
        placeHolderLabel.frame = CGRectMake(self.placeholdOrigin.x, self.placeholdOrigin.y, CGRectGetWidth(self.frame)-self.placeholdOrigin.x*2, CGRectGetHeight(placeHolderLabel.frame));
    }else{
        placeHolderLabel.frame = CGRectMake(8, 8, CGRectGetWidth(self.frame)-16, CGRectGetHeight(placeHolderLabel.frame));
    }
    
}

-(void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    
    if ( placeHolderLabel == nil )
    {
        placeHolderLabel = [[UILabel alloc] init];
        placeHolderLabel.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
        placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
        placeHolderLabel.numberOfLines = 0;
        placeHolderLabel.font = self.font;
        placeHolderLabel.backgroundColor = [UIColor clearColor];
        placeHolderLabel.textColor = LG_ColorWithHex(0xC7C7CF);
        placeHolderLabel.alpha = 0;
        [self addSubview:placeHolderLabel];
    }
    
    placeHolderLabel.text = self.placeholder;
    [self refreshPlaceholder];
}
//When any text changes on textField, the delegate getter is called. At this time we refresh the textView's placeholder
-(id<UITextViewDelegate>)delegate
{
    [self refreshPlaceholder];
    return [super delegate];
}


#pragma mark UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (self.yjDelegate && [self.yjDelegate respondsToSelector:@selector(yj_textViewShouldBeginEditing:)]) {
       return [self.yjDelegate yj_textViewShouldBeginEditing:self];
    }
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if (self.yjDelegate && [self.yjDelegate respondsToSelector:@selector(yj_textViewShouldEndEditing:)]) {
        return [self.yjDelegate yj_textViewShouldEndEditing:self];
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if (self.yjDelegate && [self.yjDelegate respondsToSelector:@selector(yj_textViewDidBeginEditing:)]) {
        [self.yjDelegate yj_textViewDidBeginEditing:self];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if (self.yjDelegate && [self.yjDelegate respondsToSelector:@selector(yj_textViewDidEndEditing:)]) {
        [self.yjDelegate yj_textViewDidEndEditing:self];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //如果用户点击了return
    if([text isEqualToString:@"\n"]){
        if (self.yjDelegate && [self.yjDelegate respondsToSelector:@selector(yj_textViewShouldReturn:)]) {
            return [self.yjDelegate yj_textViewShouldReturn:self];
        }
        return YES;
    }
    if (self.yjDelegate && [self.yjDelegate respondsToSelector:@selector(yj_textView:shouldChangeTextInRange:replacementText:)]) {
        return [self.yjDelegate yj_textView:self shouldChangeTextInRange:range replacementText:text];
    }
    if (IsStrEmpty(text)) {
        return YES;
    }
    //获取高亮部分
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        //如果有高亮且当前字数开始位置小于最大限制时允许输入
        if (offsetRange.location < self.maxLength) {
            if (self.yjDelegate && [self.yjDelegate respondsToSelector:@selector(yj_textViewDidChange:)]) {
                [self.yjDelegate yj_textViewDidChange:self];
            }
            return [self isContainEmojiInRange:range replacementText:text];
        }else{
            return NO;
        }
    }else{
        return [self isContainEmojiInRange:range replacementText:text];
    }
}
- (BOOL)isContainEmojiInRange:(NSRange)range replacementText:(NSString *)text{
    NSString *emojis = @"➋➌➍➎➏➐➑➒";
    if ([emojis containsString:text]) {
        return YES;
    }
    switch (self.limitType) {
        case YJTextViewLimitTypeDefault:
            return [self limitTypeDefaultInRange:range replacementText:text];
            break;
        case YJTextViewLimitTypeNumber:
            return [self limitTypeNumberInRange:range replacementText:text];
            break;
        case YJTextViewLimitTypeDecimal:
            return [self limitTypeDecimalInRange:range replacementText:text];
            break;
        case YJTextViewLimitTypeCharacter:
            return [self limitTypeCharacterInRange:range replacementText:text];
            break;
        case YJTextViewLimitTypeEmojiLimit:
            return [self limitTypeEmojiInRange:range replacementText:text];
            break;
        default:
            break;
    }
}
- (void)textViewDidChange:(UITextView *)textView{
    if (self.yjDelegate && [self.yjDelegate respondsToSelector:@selector(yj_textViewDidChange:)]) {
        [self.yjDelegate yj_textViewDidChange:self];
    }
}
#pragma mark LimitAction
- (BOOL)limitTypeDefaultInRange:(NSRange)range replacementText:(NSString *)text{
    if ([self exceedLimitLengthInRange:range replacementText:text]) {
        return NO;
    }else{
        return YES;
    }
}
- (BOOL)limitTypeNumberInRange:(NSRange)range replacementText:(NSString *)text{
    if ([self exceedLimitLengthInRange:range replacementText:text]) {
        return NO;
    }else{
        if ([self predicateMatchWithText:text matchFormat:@"^\\d$"]) {
            return YES;
        }
        return NO;
    }
}
- (BOOL)limitTypeDecimalInRange:(NSRange)range replacementText:(NSString *)text{
    if ([self exceedLimitLengthInRange:range replacementText:text]) {
        return NO;
    }else{
        if ([self predicateMatchWithText:text matchFormat:@"^[0-9.]$"]) {
            return YES;
        }
        return NO;
    }
}
- (BOOL)limitTypeCharacterInRange:(NSRange)range replacementText:(NSString *)text{
    if ([self exceedLimitLengthInRange:range replacementText:text]) {
        return NO;
    }else{
        if ([self predicateMatchWithText:text matchFormat:@"^[^[\\u4e00-\\u9fa5]]$"]) {
            return YES;
        }
        return NO;
    }
}
- (BOOL)limitTypeEmojiInRange:(NSRange)range replacementText:(NSString *)text{
    if ([self exceedLimitLengthInRange:range replacementText:text]) {
        return NO;
    }else{
//        if (![NSString stringContainsEmoji:text]) {
//            return YES;
//        }
        if (![text yj_containsEmoji]) {
            return YES;
        }
        return NO;
    }
}
- (BOOL)exceedLimitLengthInRange:(NSRange)range replacementText:(NSString *)text{
    NSString *str = [NSString stringWithFormat:@"%@%@", self.text, text];
    if (str.length > self.maxLength){
        
        NSRange rangeIndex = [str rangeOfComposedCharacterSequenceAtIndex:self.maxLength];
        if (rangeIndex.length == 1){//字数超限
            self.text = [str substringToIndex:self.maxLength];
            if (self.yjDelegate && [self.yjDelegate respondsToSelector:@selector(yj_textViewDidChange:)]) {
                [self.yjDelegate yj_textViewDidChange:self];
            }
        }else{
            NSRange rangeRange = [str rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, self.maxLength)];
            self.text = [str substringWithRange:rangeRange];
        }
        [LGAlert showInfoWithStatus:@"字数已达限制"];
        return YES;
    }
    return NO;
}
- (NSString *)filterStringWithText:(NSString *) text matchFormat:(NSString *) matchFormat{
    NSMutableString * modifyString = text.mutableCopy;
    for (NSInteger idx = 0; idx < modifyString.length;) {
        NSString * subString = [modifyString substringWithRange: NSMakeRange(idx, 1)];
        if ([self predicateMatchWithText:subString matchFormat:matchFormat]) {
            idx++;
        } else {
            [modifyString deleteCharactersInRange: NSMakeRange(idx, 1)];
        }
    }
    return modifyString;
}
- (BOOL)predicateMatchWithText:(NSString *) text matchFormat:(NSString *) matchFormat{
    NSPredicate * predicate = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", matchFormat];
    return [predicate evaluateWithObject:text];
}


#pragma mark 自适应键盘方法
- (CGFloat)keyboardHeight{
    if (_keyboardHeight == 0) {
        _keyboardHeight = 225;
    }
    return _keyboardHeight;
}
- (void)setAutoAdjust:(BOOL)autoAdjust{
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(keyboardWillShow:) name: UIKeyboardWillShowNotification object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(keyboardWillHide:) name: UIKeyboardWillHideNotification object: nil];
    //        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(textDidChanged:) name: UITextViewTextDidChangeNotification object: nil];
    //        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(textDidChanged:) name: UITextViewTextDidBeginEditingNotification object: nil];
}
- (void)setAutoCursorPosition:(BOOL)autoCursorPosition{
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(cp_keyboardWillShow:) name: UIKeyboardWillShowNotification object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(cp_keyboardWillShow:) name: UIKeyboardWillChangeFrameNotification object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(keyboardWillHide:) name: UIKeyboardWillHideNotification object: nil];
    //    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(cp_keyboardWillShow:) name: UITextViewTextDidChangeNotification object: nil];
    //    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(cp_keyboardWillShow:) name: UITextViewTextDidBeginEditingNotification object: nil];
}
- (void)keyboardWillShow: (NSNotification *)notification
{
    CGFloat keyboardHeight = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    self.keyboardHeight = keyboardHeight;
    if (!self.isOffset) {
        [self adjustFrameWithNoti:notification];
    }
}
- (void)cp_keyboardWillShow: (NSNotification *)notification
{
    CGFloat keyboardHeight = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    self.keyboardHeight = keyboardHeight;
    [self cp_adjustFrameWithNoti:notification];
}
//- (void)textDidChanged:(NSNotification *)notification{
//    [self adjustFrameWithNoti:notification];
//}
- (void)keyboardWillHide: (NSNotification *)notification{
    self.isOffset = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:LGUITextViewWillDidEndEditingNotification object:nil userInfo:nil];
}
- (void)cp_adjustFrameWithNoti:(NSNotification *)notification{
    if (self.isFirstResponder) {
        CGFloat actualKeyboardHeight = self.keyboardHeight+self.assistHeight;
        [[NSNotificationCenter defaultCenter] postNotificationName:LGUITextViewWillDidBeginEditingCursorNotification object:nil userInfo:@{@"offset":@(actualKeyboardHeight)}];
    }
}
- (void)adjustFrameWithNoti:(NSNotification *)notification{
    if (self.isFirstResponder) {
        self.isOffset = YES;
        NSLog(@"%@",NSStringFromCGRect(self.bounds));
        CGPoint relativePoint = [self convertRect: self.bounds toView: [UIApplication sharedApplication].keyWindow].origin;
        CGSize relativeSize = [self convertRect: self.bounds toView: [UIApplication sharedApplication].keyWindow].size;
        CGFloat textActualHeight = relativePoint.y + relativeSize.height - CGRectGetHeight([UIScreen mainScreen].bounds);
        if (textActualHeight < 0) {
            textActualHeight = 0;
        }
        CGFloat keyboardHeight = self.keyboardHeight;
        keyboardHeight += self.assistHeight;
        CGFloat actualHeight = CGRectGetHeight(self.frame) - textActualHeight + relativePoint.y + keyboardHeight;
        CGFloat overstep = actualHeight - CGRectGetHeight([UIScreen mainScreen].bounds);
        if (overstep > 1 && [notification.name isEqualToString:UIKeyboardWillShowNotification]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:LGUITextViewWillDidBeginEditingNotification object:nil userInfo:@{@"offset":@(overstep)}];
        }
    }
}
@end
