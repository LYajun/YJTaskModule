//
//  ZH_BaseTextField.h
//  LGEducationCenter
//
//  Created by 刘亚军 on 2017/3/17.
//  Copyright © 2017年 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, YJTextFieldLimitType)
{
    YJTextFieldLimitDefault,      // 不限制
    YJTextFieldLimitNumber,      // 只允许输入数字
    YJTextFieldLimitDecimal,     //  只允许输入实数，包括.
    YJTextFieldLimitCharacter,  // 只允许非中文输入
    YJTextFieldLimitEmojiLimit  // 过滤表情
};

@class LGBaseTextField;
@protocol LGBaseTextFieldDelegate <NSObject>
@optional
- (BOOL)yj_textFieldShouldBeginEditing:(nullable LGBaseTextField *)textField;
- (void)yj_textFieldDidBeginEditing:(nullable LGBaseTextField *)textField;
- (BOOL)yj_textFieldShouldEndEditing:(nullable LGBaseTextField *)textField;
- (void)yj_textFieldDidEndEditing:(nullable LGBaseTextField *)textField;
- (BOOL)yj_textField:(nullable LGBaseTextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(nullable NSString *)string;
- (BOOL)yj_textFieldShouldClear:(nullable LGBaseTextField *)textField;
- (BOOL)yj_textFieldShouldReturn:(nullable LGBaseTextField *)textField;

@end

@interface LGBaseTextField : UITextField
@property (nonatomic,assign) YJTextFieldLimitType limitType;
@property (nonatomic,assign) NSInteger maxLength;
@property (nullable,nonatomic,weak) id<LGBaseTextFieldDelegate> yjDelegate;

/** 移除辅助视图 */
- (void)deleteAccessoryView;

@end
