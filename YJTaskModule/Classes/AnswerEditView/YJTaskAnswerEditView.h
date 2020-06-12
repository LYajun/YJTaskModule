//
//  YJTaskAnswerEditView.h
//  YJTaskKit
//
//  Created by 刘亚军 on 2018/7/31.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGBaseTextView.h"
@interface YJTaskAnswerTextView : LGBaseTextView

@end

@interface YJTaskAnswerEditView : UIView
@property (nonatomic,strong) YJTaskAnswerTextView *textView;
@property (nonatomic,copy) void (^answerResultBlock) (NSString *result);
@property (nonatomic,copy) void (^keyboardHideBlock) (void);
@end
