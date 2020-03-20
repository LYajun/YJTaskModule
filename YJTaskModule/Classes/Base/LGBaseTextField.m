//
//  ZH_BaseTextField.m
//  LGEducationCenter
//
//  Created by 刘亚军 on 2017/3/17.
//  Copyright © 2017年 刘亚军. All rights reserved.
//

#import "LGBaseTextField.h"
#import <BlocksKit/BlocksKit+UIKit.h>
#import "YJConst.h"
#import <LGAlertHUD/LGAlertHUD.h>

@interface LGBaseTextField ()<UITextFieldDelegate>
@property (nonatomic, strong) UIToolbar *customAccessoryView;
@end
@implementation LGBaseTextField
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
-(void)initialize{
    self.maxLength = NSUIntegerMax;
    __weak typeof(self) weakSelf = self;
    self.bk_shouldBeginEditingBlock = ^BOOL(UITextField *textField) {
        return [weakSelf j1_textFieldShouldBeginEditing:textField];
    };
    self.bk_didBeginEditingBlock = ^(UITextField *textField) {
        [weakSelf j1_textFieldDidBeginEditing:textField];
    };
    self.bk_shouldEndEditingBlock = ^BOOL(UITextField *textField) {
        return [weakSelf j1_textFieldShouldEndEditing:textField];
    };
    self.bk_didEndEditingBlock = ^(UITextField *textField) {
        [weakSelf j1_textFieldDidEndEditing:textField];
    };
    self.bk_shouldChangeCharactersInRangeWithReplacementStringBlock = ^BOOL(UITextField *textField, NSRange range, NSString *string) {
        return [weakSelf j1_textField:textField shouldChangeCharactersInRange:range replacementString:string];
    };
    self.bk_shouldClearBlock = ^BOOL(UITextField *textField) {
        return [weakSelf j1_textFieldShouldClear:textField];
    };
    self.bk_shouldReturnBlock = ^BOOL(UITextField *textField) {
        return [weakSelf j1_textFieldShouldReturn:textField];
    };
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
- (void)deleteAccessoryView{
    self.inputAccessoryView = nil;
}
- (void)clearAction{
    self.text = @"";
}
- (void)done{
    [self resignFirstResponder];
}
#pragma mark UITextFieldDelegate
- (BOOL)j1_textFieldShouldBeginEditing:(UITextField *)textField{
    if (self.yjDelegate && [self.yjDelegate respondsToSelector:@selector(yj_textFieldShouldBeginEditing:)]) {
        return [self.yjDelegate yj_textFieldShouldBeginEditing:self];
    }
    return YES;
}
- (void)j1_textFieldDidBeginEditing:(UITextField *)textField{
    if (self.yjDelegate && [self.yjDelegate respondsToSelector:@selector(yj_textFieldDidBeginEditing:)]) {
        [self.yjDelegate yj_textFieldDidBeginEditing:self];
    }
}
- (BOOL)j1_textFieldShouldEndEditing:(UITextField *)textField{
    if (self.yjDelegate && [self.yjDelegate respondsToSelector:@selector(yj_textFieldShouldEndEditing:)]) {
        return [self.yjDelegate yj_textFieldShouldEndEditing:self];
    }
    return YES;
}
- (void)j1_textFieldDidEndEditing:(UITextField *)textField{
    if (self.yjDelegate && [self.yjDelegate respondsToSelector:@selector(yj_textFieldDidEndEditing:)]) {
        [self.yjDelegate yj_textFieldDidEndEditing:self];
    }
}
- (BOOL)j1_textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSLog(@"%@",string);
    if (self.yjDelegate && [self.yjDelegate respondsToSelector:@selector(yj_textField:shouldChangeCharactersInRange:replacementString:)]) {
        return [self.yjDelegate yj_textField:self shouldChangeCharactersInRange:range replacementString:string];
    }
    if (IsStrEmpty(string)) {
        return YES;
    }
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *pos = [textField positionFromPosition:selectedRange.start offset:0];
    if (selectedRange && pos) {
        NSInteger startOffset = [textField offsetFromPosition:textField.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textField offsetFromPosition:textField.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        //如果有高亮且当前字数开始位置小于最大限制时允许输入
        if (offsetRange.location < self.maxLength) {
            return [self isContainEmojiInRange:range replacementText:string];
        }else{
            return NO;
        }
    }else{
        return [self isContainEmojiInRange:range replacementText:string];
    }

}
- (BOOL)isContainEmojiInRange:(NSRange)range replacementText:(NSString *)text{
    NSString *emojis = @"➋➌➍➎➏➐➑➒";
    if ([emojis containsString:text]) {
        return YES;
    }
    switch (self.limitType) {
        case YJTextFieldLimitDefault:
            return [self limitTypeDefaultInRange:range replacementText:text];
            break;
        case YJTextFieldLimitNumber:
            return [self limitTypeNumberInRange:range replacementText:text];
            break;
        case YJTextFieldLimitDecimal:
            return [self limitTypeDecimalInRange:range replacementText:text];
            break;
        case YJTextFieldLimitCharacter:
            return [self limitTypeCharacterInRange:range replacementText:text];
            break;
        case YJTextFieldLimitEmojiLimit:
            return [self limitTypeEmojiInRange:range replacementText:text];
            break;
        default:
            break;
    }
}
- (BOOL)j1_textFieldShouldClear:(UITextField *)textField{
    if (self.yjDelegate && [self.yjDelegate respondsToSelector:@selector(yj_textFieldShouldClear:)]) {
        return [self.yjDelegate yj_textFieldShouldClear:self];
    }
    return YES;
}
- (BOOL)j1_textFieldShouldReturn:(UITextField *)textField{
    if (self.yjDelegate && [self.yjDelegate respondsToSelector:@selector(yj_textFieldShouldReturn:)]) {
       return [self.yjDelegate yj_textFieldShouldReturn:self];
    }
    return YES;
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
            if (self.yjDelegate && [self.yjDelegate respondsToSelector:@selector(yj_textFieldDidEndEditing:)]) {
                [self.yjDelegate yj_textFieldDidEndEditing:self];
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

@end
