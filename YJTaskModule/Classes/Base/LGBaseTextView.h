//
//  ZH_BaseTextView.h
//  LGEducationCenter
//
//  Created by 刘亚军 on 2017/3/17.
//  Copyright © 2017年 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *LGUITextViewWillDidBeginEditingNotification = @"LGUITextViewWillDidBeginEditingNotification";
static NSString *LGUITextViewWillDidEndEditingNotification = @"LGUITextViewWillDidEndEditingNotification";
static NSString *LGUITextViewWillDidBeginEditingCursorNotification = @"LGUITextViewWillDidBeginEditingCursorNotification";

typedef NS_ENUM(NSInteger, YJTextViewLimitType)
{
    YJTextViewLimitTypeDefault,      // 不限制
    YJTextViewLimitTypeNumber,      // 只允许输入数字
    YJTextViewLimitTypeDecimal,     //  只允许输入实数，包括.
    YJTextViewLimitTypeCharacter,  // 只允许非中文输入
    YJTextViewLimitTypeEmojiLimit  // 过滤表情
};
@class LGBaseTextView;
@protocol LGBaseTextViewDelegate <NSObject>
@optional
- (BOOL)yj_textViewShouldReturn:(nullable LGBaseTextView *)textView;
- (BOOL)yj_textViewShouldBeginEditing:(nullable LGBaseTextView *)textView;
- (BOOL)yj_textViewShouldEndEditing:(nullable LGBaseTextView *)textView;

- (void)yj_textViewDidBeginEditing:(nullable LGBaseTextView *)textView;
- (void)yj_textViewDidEndEditing:(nullable LGBaseTextView *)textView;

- (BOOL)yj_textView:(nullable LGBaseTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(nullable NSString *)text;
- (void)yj_textViewDidChange:(nullable LGBaseTextView *)textView;

@end

@interface LGBaseTextView : UITextView
@property(nullable, nonatomic,copy) IBInspectable NSString   *placeholder;
@property (nonatomic,assign) YJTextViewLimitType limitType;
@property (nonatomic,assign) NSInteger maxLength;
@property (nullable,nonatomic,weak) id<LGBaseTextViewDelegate> yjDelegate;

/** 移除辅助视图 */
- (void)deleteAccessoryView;
/** 获取键盘高度 */
@property (nonatomic, assign) CGFloat keyboardHeight;
/** 辅助视图高度 */
@property (nonatomic, assign) CGFloat assistHeight;
@property (nonatomic, assign) BOOL isOffset;
/** 自动适应 */
- (void)setAutoAdjust: (BOOL)autoAdjust;
/** 自动适应光标 */
- (void)setAutoCursorPosition: (BOOL)autoCursorPosition;

@end
